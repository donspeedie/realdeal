# How-To: QE repair: CWE-20 security findings in realdeal (2 findings)

## Overview

Two unauthenticated HTTP endpoints in `functions/index.js` (`cloudCalcsSync`, `cloudCalcs`) accepted `req.body.location` and forwarded it into an outbound `fetchZillowDataWithCache("propertyExtendedSearch", ...)` call with only a truthiness check (`if (params.location)`). This is CWE-20 (Improper Input Validation) — no type, length, or format constraint on user-controlled input before it crosses a trust boundary. The fix adds a dedicated validator, `isValidLocation()`, and applies it at both call sites. Findings QE #8155 and #8156 are both resolved by the same commit, `4fa8d2c`.

## Setup

- Node 20.x (per repo convention for Firebase projects).
- Work happens entirely inside `functions/` — that's the only package with the modified code, its own `package.json`, and its own Jest test runner.
- No new dependencies were added. No environment variables or secrets are involved in this fix.
- Repo root has **no** `package.json` — this is a multi-package repo (`app/` = Flutter, `functions/` = Node/Firebase Functions, `landing/` = Vite, no tests). Any command assumed to run from repo root must be scoped with `--prefix functions` or run from inside `functions/` directly.

## Implementation Details

### `functions/oaDataApi.js`
Added `isValidLocation(location)` and exported it alongside the existing `fetchZillowDataWithCache` and `normalizeLocation`. Placed next to `normalizeLocation` since both operate on the same `location` concept and this module was already imported by both vulnerable call sites — no new module was introduced.

```js
const MAX_LOCATION_LENGTH = 200;
const LOCATION_PATTERN = /^[\w\s,.'-]+$/;

function isValidLocation(location) {
  if (typeof location !== "string") return false;
  const trimmed = location.trim();
  if (trimmed.length === 0 || trimmed.length > MAX_LOCATION_LENGTH) return false;
  return LOCATION_PATTERN.test(trimmed);
}
```

Validation logic, in order:
1. **Type check** — rejects anything that isn't a `string` (objects, arrays, numbers, booleans, `null`, `undefined`).
2. **Length check** — trims whitespace, then requires `1 <= length <= 200`. Empty/whitespace-only strings fail; anything over 200 chars fails.
3. **Format check** — the trimmed string must match `/^[\w\s,.'-]+$/` in full (anchored both ends). Allowed characters: word chars (`\w` = letters, digits, underscore), whitespace, comma, period, apostrophe, hyphen. This covers real location formats like `"Stockton, CA"`, `"O'Fallon"`, `"Winston-Salem, NC"`, `"95201-1234"`, `"St. Louis, MO"`.

### `functions/index.js`
Two changes, both mechanical:
1. Import line updated to pull in `isValidLocation` alongside the existing `fetchZillowDataWithCache` import (line ~15).
2. Both guard clauses changed from `if (!params.location)` to `if (!isValidLocation(params.location))`:
   - `cloudCalcsSync`, originally around line 494 (finding #8155) — now checked before the `fetchZillowDataWithCache` call in the `try` block.
   - `cloudCalcs`, originally around line 599 (finding #8156) — same pattern, inside the SSE-streaming handler; on failure it logs and calls `writeEvent("error", ...)` / `end()` instead of `res.status(400).json(...)`, matching that endpoint's existing response style.

Error messages were updated from `"Missing required 'location' parameter"` to `"Missing or invalid 'location' parameter"` to reflect that rejection can now happen for reasons other than absence (wrong type, too long, bad characters).

### `functions/tests/isValidLocation.test.js` (new file)
Five `test()` blocks under one `describe`:
- Well-formed strings → `true` (6 real-world-shaped examples).
- Missing/empty (`undefined`, `null`, `''`, `'   '`) → `false`.
- Non-string types (object, array, number, boolean) → `false`.
- Boundary length: exactly 200 chars → `true`; 201 chars → `false`.
- Injection-shaped payloads → `false`: CRLF header injection (`'Stockton\r\nX-Injected: 1'`), SSRF-style metadata URL (`'http://169.254.169.254/latest/meta-data/'`), SQL-injection string, `<script>` tag.

## Configuration

No config files, feature flags, or environment variables were added or changed. `MAX_LOCATION_LENGTH` (200) and `LOCATION_PATTERN` are module-level constants in `functions/oaDataApi.js` — adjust there if the accepted format needs to change (see Gotchas below before doing so).

## Gotchas & Nuances

- **Repo has no root `package.json`.** The mission's specified smoke command, `npm test -- --watchAll=false --passWithNoTests` run at repo root, fails with `ENOENT: C:\package.json`. This is a structural fact of the repo (Flutter + Node + Vite subpackages, no root workspace wrapper), not a regression from this change. Run it as `npm test --prefix functions -- --watchAll=false --passWithNoTests` instead (works from any directory), or `cd functions && npm test -- --watchAll=false --passWithNoTests`.
- **Two other call sites intentionally untouched.** `functions/index.js` has two more calls to `fetchZillowDataWithCache("propertyExtendedSearch", ...)` — the scheduled deal-scanner and its manual-trigger `onCall` twin. Both source `location` from a Firestore `scanConfigs` document, not raw HTTP request body, and both sit behind `onCall` auth or a scheduler trigger. Different trust boundary, not named in either finding — do not "fix" these by reflex; they were reviewed and correctly excluded.
- **`cloudCalcsSync` and `cloudCalcs` respond differently on rejection.** `cloudCalcsSync` returns a JSON 400 via `res.status(400).json(...)`. `cloudCalcs` streams SSE and instead calls `writeEvent("error", {...})` followed by `end()`. The validator is identical; only the surrounding error-response plumbing differs — preserve that distinction if this pattern is extended to other endpoints.
- **Character whitelist is intentionally strict.** `\w\s,.'-` excludes things like `#` (unit numbers) or `&`. If a legitimate Zillow-searchable location ever needs a character outside that set, `isValidLocation` will 400 it. There's no telemetry yet confirming the whitelist covers 100% of real traffic — see TODO in the overnight report.
- **`isValidLocation` trims before validating length/format but does not mutate the caller's value.** The trimmed string is only used internally for the checks; `params.location` is passed to `fetchZillowDataWithCache` untrimmed. This matches the pre-fix behavior (no trimming happened before either) and avoids a silent behavior change beyond validation.

## Testing

Run the full functions test suite (includes the 5 new `isValidLocation` tests plus the 2 pre-existing suites):

```bash
cd functions
npm test
```

Run just the new regression tests:

```bash
cd functions
npm test -- isValidLocation --verbose
```

Run lint (eslint config already in `functions/`):

```bash
cd functions
npm run lint
```

Run the exact required smoke command in its resolvable form, from repo root:

```bash
npm test --prefix functions -- --watchAll=false --passWithNoTests
```

**Results as of the last verification pass (Phase 3):**

| Command | Location | Result |
|---|---|---|
| `npm test -- isValidLocation --verbose` | `functions/` | 1 suite, 5 tests passed |
| `npm test` | `functions/` | 3 suites, 14 tests passed |
| `npm run lint` | `functions/` | clean, no errors |
| `npm test -- --watchAll=false --passWithNoTests` | repo root | fails — `ENOENT: C:\package.json` (expected, see Gotchas) |
| `npm test --prefix functions -- --watchAll=false --passWithNoTests` | repo root | 3 suites, 14 tests passed |

**Known gaps:**
- No integration test exercises `cloudCalcsSync`/`cloudCalcs` end-to-end through an actual HTTP request (e.g. via `firebase-functions-test` or a supertest-style harness) — the regression coverage is unit-level against `isValidLocation()` directly, not against the endpoint handlers. The endpoints' pre-existing test coverage (if any) was not extended in this fix; only the new validator is covered.
- No fuzz/property-based testing of the character whitelist — coverage is example-based (specific known-good and known-bad strings), not exhaustive.
