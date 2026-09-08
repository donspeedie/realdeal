// Regression tests for QE #8200-#8202 (CWE-639: Authorization Bypass Through
// User-Controlled Key). requireFirebaseAuth only proves the caller holds a
// valid Firebase session (any signed-in user, including anonymous auth) — it
// does not prove they're authorized to read/write the HubSpot record for the
// `email` they supply. These tests prove the added requireOwnEmail() gate
// blocks cross-identity access without breaking legitimate self-service use.

jest.mock("../hubspotIntegration", () => ({
  trackPropertyCalculation: jest.fn(),
  createOrUpdateContact: jest.fn(),
  findContactByEmail: jest.fn(),
}));
jest.mock("../oaDataApi", () => ({
  fetchZillowDataWithCache: jest.fn(),
  isValidLocation: jest.fn((loc) => typeof loc === "string" && loc.trim().length > 0),
}));
jest.mock("../propertyProcessor", () => ({processProperty: jest.fn()}));
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
  };
}

function mockReq({method = "POST", authorization = "Bearer good-token", body = {}, query = {}} = {}) {
  return {
    method,
    get: (name) => (name === "Authorization" ? authorization : undefined),
    body,
    query,
  };
}

const OWN_EMAIL = "caller@example.com";
const OTHER_EMAIL = "victim@example.com";

const ENDPOINTS = [
  {
    qeId: "QE-8202",
    name: "hubspotTrackCalculation",
    body: {email: OWN_EMAIL, address: "123 Main St", method: "flip"},
    mock: "trackPropertyCalculation",
    mockResolvedValue: {contact: {id: "c1"}, note: {id: "n1"}},
  },
  {
    qeId: "QE-8201",
    name: "hubspotCreateContact",
    body: {email: OWN_EMAIL, firstName: "Jane"},
    mock: "createOrUpdateContact",
    mockResolvedValue: {id: "c1"},
  },
  {
    qeId: "QE-8200",
    name: "hubspotFindContact",
    body: {email: OWN_EMAIL},
    mock: "findContactByEmail",
    mockResolvedValue: {id: "c1", email: OWN_EMAIL},
  },
];

describe("CWE-639 fix: HubSpot endpoints require the caller's own email", () => {
  let index;
  let hubspotIntegration;

  beforeEach(() => {
    jest.resetModules();
    mockVerifyIdToken.mockReset();
    index = require("../index.js");
    hubspotIntegration = require("../hubspotIntegration");
  });

  test.each(ENDPOINTS)(
    "$qeId $name rejects a request whose email does not match the authenticated caller (403)",
    async ({name, body, mock}) => {
      mockVerifyIdToken.mockResolvedValueOnce({uid: "user-1", email: OWN_EMAIL});
      const res = mockRes();
      await index[name](mockReq({body: {...body, email: OTHER_EMAIL}}), res);

      expect(res._status).toBe(403);
      expect(res._body.error).toMatch(/forbidden/i);
      expect(hubspotIntegration[mock]).not.toHaveBeenCalled();
    }
  );

  test.each(ENDPOINTS)(
    "$qeId $name rejects an anonymous session (no email claim) regardless of requested email (403)",
    async ({name, body, mock}) => {
      mockVerifyIdToken.mockResolvedValueOnce({uid: "anon-1"});
      const res = mockRes();
      await index[name](mockReq({body}), res);

      expect(res._status).toBe(403);
      expect(res._body.error).toMatch(/forbidden/i);
      expect(hubspotIntegration[mock]).not.toHaveBeenCalled();
    }
  );

  test.each(ENDPOINTS)(
    "$qeId $name allows the request through when the email matches the caller's own account (case-insensitive)",
    async ({name, body, mock, mockResolvedValue}) => {
      mockVerifyIdToken.mockResolvedValueOnce({uid: "user-1", email: OWN_EMAIL.toUpperCase()});
      hubspotIntegration[mock].mockResolvedValueOnce(mockResolvedValue);
      const res = mockRes();
      await index[name](mockReq({body}), res);

      expect(res._status).toBe(200);
      expect(hubspotIntegration[mock]).toHaveBeenCalledTimes(1);
    }
  );
});
