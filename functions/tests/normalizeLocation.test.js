const { normalizeLocation } = require('../oaDataApi.js');

describe('normalizeLocation — OA Data API location parser guard', () => {
  test('strips a "City, State" suffix to a bare city', () => {
    expect(normalizeLocation('Stockton, CA')).toBe('Stockton');
    expect(normalizeLocation('Sacramento, CA')).toBe('Sacramento');
  });

  test('handles multi-word cities', () => {
    expect(normalizeLocation('San Francisco, CA')).toBe('San Francisco');
    expect(normalizeLocation('Elk Grove, California')).toBe('Elk Grove');
  });

  test('passes through a bare city unchanged', () => {
    expect(normalizeLocation('Stockton')).toBe('Stockton');
  });

  test('trims surrounding whitespace', () => {
    expect(normalizeLocation('  Fresno , CA ')).toBe('Fresno');
  });

  test('keeps the original string when the city portion would be empty', () => {
    expect(normalizeLocation(', CA')).toBe(', CA');
  });

  test('passes non-string values through unchanged', () => {
    expect(normalizeLocation(undefined)).toBeUndefined();
    expect(normalizeLocation(null)).toBeNull();
  });
});
