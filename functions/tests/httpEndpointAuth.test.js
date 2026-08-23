// Regression tests for QE #8149-#8153 (CWE-306: Missing Authentication for
// Critical Function). Each of these onRequest endpoints must reject
// unauthenticated callers before touching any secret-backed integration
// (OA Data API / HubSpot), while still answering CORS preflight without auth.

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
    flushHeaders() {},
    write() {},
    end() {},
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

const ENDPOINTS = [
  {qeId: "QE-8149", name: "cloudCalcs"},
  {qeId: "QE-8150", name: "cloudCalcsSync"},
  {qeId: "QE-8151", name: "hubspotTrackCalculation"},
  {qeId: "QE-8152", name: "hubspotCreateContact"},
  {qeId: "QE-8153", name: "hubspotFindContact"},
];

describe("CWE-306 fix: onRequest endpoints require Firebase auth", () => {
  let index;

  beforeEach(() => {
    jest.resetModules();
    mockVerifyIdToken.mockReset();
    index = require("../index.js");
  });

  test.each(ENDPOINTS)("$qeId $name rejects a request with no Authorization header (401)", async ({name}) => {
    const handler = index[name];
    const res = mockRes();
    await handler(mockReq({}), res);
    expect(res._status).toBe(401);
    expect(mockVerifyIdToken).not.toHaveBeenCalled();
  });

  test.each(ENDPOINTS)("$qeId $name rejects a request with an invalid bearer token (401)", async ({name}) => {
    mockVerifyIdToken.mockRejectedValueOnce(new Error("invalid token"));
    const handler = index[name];
    const res = mockRes();
    await handler(mockReq({authorization: "Bearer bad-token"}), res);
    expect(res._status).toBe(401);
    expect(mockVerifyIdToken).toHaveBeenCalledWith("bad-token");
  });

  test.each(ENDPOINTS)("$qeId $name still answers the CORS preflight (OPTIONS) without requiring auth", async ({name}) => {
    const handler = index[name];
    const res = mockRes();
    await handler(mockReq({method: "OPTIONS"}), res);
    expect(res._status).toBe(204);
    expect(mockVerifyIdToken).not.toHaveBeenCalled();
  });

  test("QE-8150 cloudCalcsSync proceeds past the auth gate with a valid token (fails on missing params, not auth)", async () => {
    mockVerifyIdToken.mockResolvedValueOnce({uid: "test-user"});
    const res = mockRes();
    await index.cloudCalcsSync(mockReq({authorization: "Bearer good-token"}), res);
    expect(mockVerifyIdToken).toHaveBeenCalledWith("good-token");
    expect(res._status).toBe(400);
    expect(res._body.error).toMatch(/location/i);
  });

  test.each([
    {name: "hubspotTrackCalculation"},
    {name: "hubspotCreateContact"},
    {name: "hubspotFindContact"},
  ])("$name proceeds past the auth gate with a valid token (fails on missing params, not auth)", async ({name}) => {
    mockVerifyIdToken.mockResolvedValueOnce({uid: "test-user"});
    const res = mockRes();
    await index[name](mockReq({authorization: "Bearer good-token"}), res);
    expect(mockVerifyIdToken).toHaveBeenCalledWith("good-token");
    expect(res._status).toBe(400);
    expect(res._body.error).toMatch(/email/i);
  });
});
