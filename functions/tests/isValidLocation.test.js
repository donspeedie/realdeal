const { isValidLocation } = require('../oaDataApi.js');

// Regression coverage for QE #8155 / #8156 (CWE-20, functions/index.js) —
// cloudCalcsSync and cloudCalcs both forward req.body.location into an
// outbound fetchZillowDataWithCache() call guarded only by a truthiness
// check. isValidLocation() is the fix: a real type/length/format gate.
describe('isValidLocation — CWE-20 boundary guard for req.body.location', () => {
  test('accepts well-formed city/state/zip style strings', () => {
    expect(isValidLocation('Stockton, CA')).toBe(true);
    expect(isValidLocation('San Francisco')).toBe(true);
    expect(isValidLocation("O'Fallon")).toBe(true);
    expect(isValidLocation('Winston-Salem, NC')).toBe(true);
    expect(isValidLocation('95201-1234')).toBe(true);
    expect(isValidLocation('St. Louis, MO')).toBe(true);
  });

  test('rejects missing or empty location', () => {
    expect(isValidLocation(undefined)).toBe(false);
    expect(isValidLocation(null)).toBe(false);
    expect(isValidLocation('')).toBe(false);
    expect(isValidLocation('   ')).toBe(false);
  });

  test('rejects non-string types (objects/arrays/numbers)', () => {
    expect(isValidLocation({ $where: 'x' })).toBe(false);
    expect(isValidLocation(['Stockton', 'CA'])).toBe(false);
    expect(isValidLocation(12345)).toBe(false);
    expect(isValidLocation(true)).toBe(false);
  });

  test('rejects strings past the length bound', () => {
    expect(isValidLocation('A'.repeat(200))).toBe(true);
    expect(isValidLocation('A'.repeat(201))).toBe(false);
  });

  test('rejects control characters, URLs, and injection-shaped payloads', () => {
    expect(isValidLocation('Stockton\r\nX-Injected: 1')).toBe(false);
    expect(isValidLocation('http://169.254.169.254/latest/meta-data/')).toBe(false);
    expect(isValidLocation('Stockton"; DROP TABLE properties;--')).toBe(false);
    expect(isValidLocation('<script>alert(1)</script>')).toBe(false);
  });
});
