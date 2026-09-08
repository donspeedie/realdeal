const mockVerifyIdToken = jest.fn();
jest.mock("firebase-admin", () => ({
  auth: () => ({verifyIdToken: mockVerifyIdToken}),
}));

const {requireFirebaseAuth, requireOwnEmail} = require("../authGuard");

function mockRes() {
  return {
    _status: undefined,
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
  };
}

function mockReq(authorizationHeader) {
  return {
    get: (name) => (name === "Authorization" ? authorizationHeader : undefined),
  };
}

describe("requireFirebaseAuth — CWE-306 shared auth guard", () => {
  beforeEach(() => {
    mockVerifyIdToken.mockReset();
  });

  test("rejects with 401 when the Authorization header is missing", async () => {
    const res = mockRes();
    const result = await requireFirebaseAuth(mockReq(undefined), res);
    expect(result).toBeNull();
    expect(res._status).toBe(401);
    expect(res._headers["Access-Control-Allow-Origin"]).toBe("*");
    expect(mockVerifyIdToken).not.toHaveBeenCalled();
  });

  test("rejects with 401 when the Authorization header is not a Bearer token", async () => {
    const res = mockRes();
    const result = await requireFirebaseAuth(mockReq("Basic abc123"), res);
    expect(result).toBeNull();
    expect(res._status).toBe(401);
    expect(mockVerifyIdToken).not.toHaveBeenCalled();
  });

  test("rejects with 401 when the token fails verification", async () => {
    mockVerifyIdToken.mockRejectedValueOnce(new Error("Firebase ID token has expired"));
    const res = mockRes();
    const result = await requireFirebaseAuth(mockReq("Bearer expired-token"), res);
    expect(result).toBeNull();
    expect(res._status).toBe(401);
    expect(mockVerifyIdToken).toHaveBeenCalledWith("expired-token");
  });

  test("resolves with the decoded token for a valid bearer token", async () => {
    mockVerifyIdToken.mockResolvedValueOnce({uid: "user-123"});
    const res = mockRes();
    const result = await requireFirebaseAuth(mockReq("Bearer good-token"), res);
    expect(result).toEqual({uid: "user-123"});
    expect(res._status).toBeUndefined();
    expect(mockVerifyIdToken).toHaveBeenCalledWith("good-token");
  });
});

describe("requireOwnEmail — CWE-639 caller-owns-key guard", () => {
  test("rejects with 403 when the token has no email claim (anonymous session)", () => {
    const res = mockRes();
    const result = requireOwnEmail({uid: "anon-1"}, "someone@example.com", res);
    expect(result).toBe(false);
    expect(res._status).toBe(403);
    expect(res._headers["Access-Control-Allow-Origin"]).toBe("*");
  });

  test("rejects with 403 when the requested email is missing", () => {
    const res = mockRes();
    const result = requireOwnEmail({uid: "user-1", email: "user@example.com"}, undefined, res);
    expect(result).toBe(false);
    expect(res._status).toBe(403);
  });

  test("rejects with 403 when the requested email does not match the token's email", () => {
    const res = mockRes();
    const result = requireOwnEmail({uid: "user-1", email: "user@example.com"}, "other@example.com", res);
    expect(result).toBe(false);
    expect(res._status).toBe(403);
  });

  test("allows a case-insensitive match between token email and requested email", () => {
    const res = mockRes();
    const result = requireOwnEmail({uid: "user-1", email: "User@Example.com"}, "user@example.com", res);
    expect(result).toBe(true);
    expect(res._status).toBeUndefined();
  });
});
