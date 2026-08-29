// Regression tests for QE #8207 (CWE-346: Origin Validation Error,
// fingerprint 5fdefb455f9802aa13cd36c2f79e89ec). cloudCalcsSync used to set
// Access-Control-Allow-Origin: "*" unconditionally, so any origin could read
// the JSON response from an authenticated caller's browser. It must now
// reflect only known RealDeal frontend origins and omit the header for
// anything else, while leaving unrelated request handling untouched.

const fs = require("fs");
const path = require("path");

jest.mock("../oaDataApi", () => ({
  fetchZillowDataWithCache: jest.fn(),
  isValidLocation: jest.fn((loc) => typeof loc === "string" && loc.trim().length > 0),
}));
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

function mockReq({method = "POST", authorization, body = {}, query = {}, origin} = {}) {
  return {
    method,
    headers: authorization ? {authorization} : {},
    get: (name) => {
      if (name === "Authorization") return authorization;
      if (name === "Origin") return origin;
      return undefined;
    },
    body,
    query,
  };
}

describe("QE #8207 CWE-346 fix: cloudCalcsSync validates the request Origin", () => {
  let index;

  beforeEach(() => {
    jest.resetModules();
    mockVerifyIdToken.mockReset();
    index = require("../index.js");
  });

  test("reflects an allowlisted origin and adds Vary: Origin (OPTIONS preflight)", async () => {
    const res = mockRes();
    await index.cloudCalcsSync(mockReq({method: "OPTIONS", origin: "https://app.getrealdeal.ai"}), res);
    expect(res._status).toBe(204);
    expect(res._headers["Access-Control-Allow-Origin"]).toBe("https://app.getrealdeal.ai");
    expect(res._headers["Vary"]).toBe("Origin");
  });

  test("does not set Access-Control-Allow-Origin for an unrecognized origin", async () => {
    const res = mockRes();
    await index.cloudCalcsSync(mockReq({method: "OPTIONS", origin: "https://evil.example.com"}), res);
    expect(res._status).toBe(204);
    expect(res._headers["Access-Control-Allow-Origin"]).toBeUndefined();
  });

  test("omits Access-Control-Allow-Origin when no Origin header is present (native/FlutterFlow callers)", async () => {
    mockVerifyIdToken.mockResolvedValueOnce({uid: "test-user"});
    const res = mockRes();
    await index.cloudCalcsSync(mockReq({authorization: "Bearer good-token"}), res);
    expect(res._headers["Access-Control-Allow-Origin"]).toBeUndefined();
    // request still proceeds through the normal handler logic (auth passes,
    // fails downstream on missing params, not blocked by the origin check)
    expect(mockVerifyIdToken).toHaveBeenCalledWith("good-token");
    expect(res._status).toBe(400);
  });

  test("still requires auth regardless of Origin — an allowlisted origin doesn't bypass CWE-306 protections", async () => {
    const res = mockRes();
    await index.cloudCalcsSync(mockReq({origin: "https://app.getrealdeal.ai"}), res);
    expect(res._status).toBe(401);
    expect(mockVerifyIdToken).not.toHaveBeenCalled();
  });
});

describe("QE #8207 (CWE-346, fingerprint 5fdefb455f9802aa13cd36c2f79e89ec) regression", () => {
  const indexSource = fs.readFileSync(path.join(__dirname, "..", "index.js"), "utf8");

  function extractFunctionSource(exportName) {
    const start = indexSource.indexOf(`exports.${exportName} = onRequest(`);
    expect(start).toBeGreaterThan(-1);
    const nextExport = indexSource.indexOf("\nexports.", start + 1);
    return indexSource.slice(start, nextExport === -1 ? undefined : nextExport);
  }

  test("cloudCalcsSync no longer hands out a wildcard Access-Control-Allow-Origin", () => {
    const fnSource = extractFunctionSource("cloudCalcsSync");
    expect(fnSource).not.toMatch(/"Access-Control-Allow-Origin":\s*"\*"/);
    expect(fnSource).toContain("resolveCloudCalcsSyncOrigin(req)");
  });
});
