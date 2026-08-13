const {
  resolveProcessingLimits,
  MAX_ALLOWED_PAGES,
  MAX_ALLOWED_PROPERTIES,
} = require('../utils.js');

// Regression test for QE #8160 (CWE-770): exports.cloudCalcs in index.js used
// to trust client-supplied maxPages/maxProperties with no upper bound, so a
// caller could force unbounded upstream fetches + batch processing.
describe('resolveProcessingLimits — cloudCalcs resource ceiling guard (CWE-770)', () => {
  test('defaults to the standard limits when nothing is requested', () => {
    expect(resolveProcessingLimits({})).toEqual({
      maxPages: MAX_ALLOWED_PAGES,
      maxProperties: MAX_ALLOWED_PROPERTIES,
    });
  });

  test('honors a smaller client-requested value', () => {
    expect(resolveProcessingLimits({maxPages: 2, maxProperties: 5})).toEqual({
      maxPages: 2,
      maxProperties: 5,
    });
  });

  test('clamps a client-requested value above the hard ceiling', () => {
    const result = resolveProcessingLimits({maxPages: 999999999, maxProperties: 999999999});
    expect(result.maxPages).toBe(MAX_ALLOWED_PAGES);
    expect(result.maxProperties).toBe(MAX_ALLOWED_PROPERTIES);
  });

  test('falls back to defaults for non-positive or non-numeric input', () => {
    expect(resolveProcessingLimits({maxPages: 0, maxProperties: -5})).toEqual({
      maxPages: MAX_ALLOWED_PAGES,
      maxProperties: MAX_ALLOWED_PROPERTIES,
    });
    expect(resolveProcessingLimits({maxPages: 'unlimited', maxProperties: 'all'})).toEqual({
      maxPages: MAX_ALLOWED_PAGES,
      maxProperties: MAX_ALLOWED_PROPERTIES,
    });
  });
});
