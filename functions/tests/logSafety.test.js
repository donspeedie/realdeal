const fs = require("fs");
const path = require("path");
const { safeKeys } = require("../logSafety.js");

describe("safeKeys — CWE-532 log redaction guard", () => {
  test("returns only field names, never values", () => {
    const headers = {
      authorization: "Bearer super-secret-token",
      cookie: "session=abc123",
      "content-type": "application/json",
    };
    const keys = safeKeys(headers);
    expect(keys).toEqual(["authorization", "cookie", "content-type"]);
    expect(JSON.stringify(keys)).not.toContain("super-secret-token");
    expect(JSON.stringify(keys)).not.toContain("abc123");
  });

  test("handles missing/non-object input without throwing", () => {
    expect(safeKeys(undefined)).toEqual([]);
    expect(safeKeys(null)).toEqual([]);
    expect(safeKeys("not-an-object")).toEqual([]);
  });

  test("handles an empty object", () => {
    expect(safeKeys({})).toEqual([]);
  });
});

describe("QE #8159 (CWE-532, fingerprint b6568a4c580c172e5748d29b853014b1) regression", () => {
  const indexSource = fs.readFileSync(path.join(__dirname, "..", "index.js"), "utf8");

  test("cloudCalcs no longer dumps raw headers/body/query to logs", () => {
    expect(indexSource).not.toMatch(/JSON\.stringify\(req\.headers/);
    expect(indexSource).not.toMatch(/JSON\.stringify\(req\.body/);
    expect(indexSource).not.toMatch(/JSON\.stringify\(req\.query/);
    expect(indexSource).not.toMatch(/JSON\.stringify\(params/);
  });

  test("cloudCalcs logs header/body/query field names via the safe helper instead", () => {
    expect(indexSource).toContain("safeKeys(req.headers)");
    expect(indexSource).toContain("safeKeys(req.body)");
    expect(indexSource).toContain("safeKeys(req.query)");
  });
});
