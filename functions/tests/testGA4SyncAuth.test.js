// Regression test for QE #8154 (CWE-306: Missing Authentication for Critical
// Function). testGA4Sync is an onRequest endpoint that writes engagement
// records to Firestore and calls the GA4 API on the caller's behalf — it must
// reject unauthenticated callers before touching Firestore or GA4, while
// still answering CORS preflight without auth.

jest.mock("../oaDataApi", () => ({fetchZillowDataWithCache: jest.fn()}));
jest.mock("../propertyProcessor", () => ({processProperty: jest.fn()}));
jest.mock("../hubspotIntegration", () => ({
  trackPropertyCalculation: jest.fn(),
  createOrUpdateContact: jest.fn(),
  findContactByEmail: jest.fn(),
}));
jest.mock("../dealScoringEngine", () => ({
  scoreDeal: jest.fn(),
  mapStrategyResultToDeal: jest.fn(),
}));
jest.mock("../fluidcmHandoff", () => ({createFluidCMProject: jest.fn()}));
jest.mock("../ga4Service", () => ({
  initializeGA4Client: jest.fn(),
  fetchLandingPageEvents: jest.fn(),
  fetchConversionEvents: jest.fn(),
  testConnection: jest.fn(),
}));
jest.mock("../ga4Transformer", () => ({
  transformGA4Batch: jest.fn(),
  deduplicateEngagements: jest.fn(),
  aggregatePageViews: jest.fn(),
  filterLowValueEvents: jest.fn(),
}));

const mockVerifyIdToken = jest.fn();
jest.mock("firebase-admin", () => ({
  apps: [],
  initializeApp: jest.fn(),
  auth: jest.fn(() => ({verifyIdToken: mockVerifyIdToken})),
  firestore: jest.fn(),
}));

function mockRes() {
  return {
    _status: 200,
    _headers: {},
    _body: undefined,
    set(headers) {
      Object.assign(this._headers, headers);
      return this;
    },
    status(code) {
      this._status = code;
      return this;
    },
    json(body) {
      this._body = body;
      return this;
    },
    send(body) {
      this._body = body;
      return this;
    },
  };
}

function mockReq({method = "POST", authorization, body = {}, query = {}} = {}) {
  return {
    method,
    headers: authorization ? {authorization} : {},
    get: (name) => (name === "Authorization" ? authorization : undefined),
    body,
    query,
  };
}

describe("QE-8154 testGA4Sync requires Firebase auth", () => {
  let index;

  beforeEach(() => {
    jest.resetModules();
    mockVerifyIdToken.mockReset();
    index = require("../index.js");
  });

  test("rejects a request with no Authorization header (401)", async () => {
    const res = mockRes();
    await index.testGA4Sync(mockReq({}), res);
    expect(res._status).toBe(401);
    expect(mockVerifyIdToken).not.toHaveBeenCalled();
  });

  test("rejects a request with an invalid bearer token (401)", async () => {
    mockVerifyIdToken.mockRejectedValueOnce(new Error("invalid token"));
    const res = mockRes();
    await index.testGA4Sync(mockReq({authorization: "Bearer bad-token"}), res);
    expect(res._status).toBe(401);
    expect(mockVerifyIdToken).toHaveBeenCalledWith("bad-token");
  });

  test("still answers the CORS preflight (OPTIONS) without requiring auth", async () => {
    const res = mockRes();
    await index.testGA4Sync(mockReq({method: "OPTIONS"}), res);
    expect(res._status).toBe(204);
    expect(mockVerifyIdToken).not.toHaveBeenCalled();
  });

  test("proceeds past the auth gate with a valid token (fails on missing propertyId, not auth)", async () => {
    mockVerifyIdToken.mockResolvedValueOnce({uid: "test-user"});
    const res = mockRes();
    await index.testGA4Sync(mockReq({authorization: "Bearer good-token"}), res);
    expect(mockVerifyIdToken).toHaveBeenCalledWith("good-token");
    expect(res._status).toBe(400);
    expect(res._body.error).toMatch(/GA4_PROPERTY_ID/i);
  });
});
