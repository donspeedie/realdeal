# How-To: QE repair: CWE-770 security findings in realdeal (1 finding)

## Overview

`exports.cloudCalcs` in `functions/index.js` is a public, unauthenticated Firebase Cloud Function that paginates through a property search and lets the client specify `maxPages` and `maxProperties` in the request body. Prior to this fix, those values had only a falsy-fallback default (`params.maxPages || 1000`) and no upper bound, so a crafted request could force unbounded upstream API fetches and batch processing (CWE-770, QE #8160). This doc covers the fix: a hard server-side clamp via `resolveProcessingLimits()`.

## Setup

No new dependencies, environment variables, or config were introduced. Standard RealDeal Functions dev setup applies:

- Node 20.x
- `cd functions && npm install`
- Tests run via Jest: `npm test` (repo root `functions/` directory)
- The function still requires the existing `oaDataApiUrl` secret binding (`onRequest({secrets: [oaDataApiUrl]}, ...)`) — unchanged by this fix.

## Implementation Details

### `functions/utils.js` (new code, lines 50–74)

Added two constants and one helper function, exported alongside the existing utility functions:

```js
const MAX_ALLOWED_PAGES = 1000;
const MAX_ALLOWED_PROPERTIES = 10000;

const resolveProcessingLimits = (params = {}) => {
  const requestedPages = Number(params.maxPages);
  const requestedProperties = Number(params.maxProperties);
  const maxPages = Number.isFinite(requestedPages) && requestedPages > 0 ?
    Math.min(requestedPages, MAX_ALLOWED_PAGES) : MAX_ALLOWED_PAGES;
  const maxProperties = Number.isFinite(requestedProperties) && requestedProperties > 0 ?
    Math.min(requestedProperties, MAX_ALLOWED_PROPERTIES) : MAX_ALLOWED_PROPERTIES;
  return {maxPages, maxProperties};
};

module.exports = {
  analyzeDescription,
  calculateBedroomPriceAverages,
  appendZillowUrl,
  resolveProcessingLimits,
  MAX_ALLOWED_PAGES,
  MAX_ALLOWED_PROPERTIES,
};
```

Logic: `Number(params.maxPages)` coerces the input (handles strings, `undefined`, garbage). If the result is finite and positive, it's clamped to the ceiling with `Math.min`. Anything else (non-numeric, zero, negative, `NaN`) falls back to the full default ceiling — i.e., "no valid limit requested" is treated the same as "no limit requested at all," not as an error condition.

### `functions/index.js` (modified, around line 397–406)

`resolveProcessingLimits` is imported at the top of the file (line 20: `const {resolveProcessingLimits} = require("./utils");`) and called inside `cloudCalcs`, replacing the two unclamped fallback assignments:

```js
let page = 1;
let totalProcessed = 0;
// Client may request smaller maxPages/maxProperties, but cannot exceed the
// hard server-side ceilings in resolveProcessingLimits (CWE-770 guard).
const {maxPages: MAX_PAGES, maxProperties: MAX_PROPERTIES} = resolveProcessingLimits(params);
const BATCH_SIZE = 20;
let totalPages = 1;
```

The rest of the function (the `while (page <= totalPages && totalProcessed < MAX_PROPERTIES)` loop, batch processing, event streaming) is unchanged — only the source of `MAX_PAGES`/`MAX_PROPERTIES` changed, from an unbounded client-controlled value to a clamped one.

### `functions/tests/resolveProcessingLimits.test.js` (new file, 4 tests)

Targeted regression suite, imports `resolveProcessingLimits`, `MAX_ALLOWED_PAGES`, `MAX_ALLOWED_PROPERTIES` directly from `../utils.js`:

| Test | Input | Expected |
|---|---|---|
| Defaults | `{}` | `{maxPages: 1000, maxProperties: 10000}` |
| Honors smaller request | `{maxPages: 2, maxProperties: 5}` | `{maxPages: 2, maxProperties: 5}` |
| Clamps oversized request | `{maxPages: 999999999, maxProperties: 999999999}` | `{maxPages: 1000, maxProperties: 10000}` |
| Rejects invalid input | `{maxPages: 0, maxProperties: -5}` and `{maxPages: 'unlimited', maxProperties: 'all'}` | both fall back to `{maxPages: 1000, maxProperties: 10000}` |

The "clamps oversized request" case is the direct regression test for QE #8160 — it's the scenario that would have passed straight through under the old `params.maxPages || 1000` fallback.

## Configuration

No config files, env vars, or Firebase settings changed. The two ceiling constants (`MAX_ALLOWED_PAGES = 1000`, `MAX_ALLOWED_PROPERTIES = 10000`) are hardcoded in `functions/utils.js` rather than sourced from environment/config, matching the values that were already the implicit defaults before the fix. If these need to change (e.g., upstream API quota changes), edit the constants directly — there is no external override mechanism, by design (an override mechanism would reopen the same class of finding if it were client-controllable).

## Gotchas & Nuances

- **`||` vs `Math.min` clamp**: The bug wasn't "no default" — it was that `||` only guards against falsy values (`0`, `undefined`, `null`, `''`), not against values that are too large. Any fix to this class of bug needs an explicit upper-bound comparison, not just a fallback default. Watch for the same `x || default` pattern elsewhere in the codebase if auditing for similar issues.
- **Zero is treated as invalid, not as "no properties wanted"**: `resolveProcessingLimits({maxPages: 0, ...})` returns the *default* (1000), not 0. This matches the pre-existing behavior (`0 || 1000` also evaluated to 1000) — it was a deliberate choice to preserve behavior rather than introduce a new "request zero pages" semantic that didn't previously exist.
- **String numbers are accepted**: `Number('5')` is finite, so `{maxPages: '5'}` clamps to 5, not to the default. Only non-numeric strings (`'unlimited'`, `'all'`) fall through to `NaN` and hit the default branch. If the client sends `"5"` via a form field, this still works correctly.
- **`cloudCalcsSync` was not touched**: This sibling endpoint already self-limits to 1 page / 5 properties with no client override at all — it was used as corroborating evidence that the finding was a true positive (the codebase's own convention is that client input shouldn't set the ceiling), but its code was not modified since it was never vulnerable.
- **No auth/rate-limiting added**: `cloudCalcs` remains a public, unauthenticated endpoint. This fix only bounds the cost of a *single* request; it does not prevent repeated requests at the capped ceiling. If you're extending this function, don't assume the endpoint is otherwise hardened — see the TODO in the overnight report about App Check / Firestore-based throttling.
- **Function-level `concurrency: 50`** (set in the `onRequest` options) is a separate, pre-existing guard that limits simultaneous invocations of the function overall — it does not bound the resource cost of any single invocation, which is what this fix addresses. Don't conflate the two when reasoning about this endpoint's limits.

## Testing

Targeted test:
```
npx jest tests/resolveProcessingLimits.test.js --watchAll=false
```
Expected: 1 suite, 4 tests, all passing.

Repo smoke command (required by the QE repair completion standard):
```
npm test -- --watchAll=false --passWithNoTests
```
Expected: 3 suites, 13 tests, 0 failures (includes the 4 new regression tests plus the pre-existing suite).

Both were run and passed as of commit `9c9ca96` on branch `nightshift/grd-qe-cwe770-56f3-b5195d65`.

**Known gaps**: No integration/emulator-level test exercises `cloudCalcs` end-to-end through the Firebase emulator with an actual oversized request — the regression coverage is at the unit level (`resolveProcessingLimits` in isolation), not a full HTTP-level test of the deployed function. If deeper coverage is wanted, add a Firebase Functions emulator test that POSTs `{maxPages: 999999999}` to `cloudCalcs` and asserts the loop terminates within the clamped bound.
