# How-To: QE repair: CWE-346 security findings in realdeal (1 finding)

## Overview

This repair closes QE #8207 (CWE-346, Origin Validation Error, fingerprint `5fdefb455f9802aa13cd36c2f79e89ec`) in the `realdeal` repo's Firebase Functions backend. The `cloudCalcsSync` Cloud Function was setting `Access-Control-Allow-Origin: "*"` unconditionally on every response, letting any browser origin read data from an authenticated, financial-data-returning endpoint. The fix replaces the wildcard with an allowlist-based origin resolver.

## Setup

- Node 20.x (project standard for Firebase functions).
- Working directory: `functions/` inside the RealDeal repo.
- No new dependencies were added — the fix uses only `req.get("Origin")`, already available on the Express-style request object Firebase Functions provides via `onRequest`.
- Test runner: Jest, invoked via `npm test` (project-level) or `npx jest` (targeted) from `functions/`.

## Implementation Details

### `functions/index.js` (modified)

Two additions immediately above `exports.cloudCalcsSync`, plus a one-line change inside it:

1. **`CLOUD_CALCS_SYNC_ALLOWED_ORIGINS`** — a `Set` of exact origin strings (scheme + host + optional port) permitted to receive a reflected `Access-Control-Allow-Origin`:
   - `https://getrealdeal.ai`
   - `https://app.getrealdeal.ai`
   - `https://habu-1gxak2.web.app`
   - `https://habu-1gxak2.firebaseapp.com`
   - `http://localhost:8080` (local dev)

2. **`resolveCloudCalcsSyncOrigin(req)`** — reads `req.get("Origin")`; returns the origin string if it's in the allowlist, otherwise `null`.

3. Inside `cloudCalcsSync`, the `res.set({...})` call that used to hardcode the wildcard now spreads a conditional object:
   ```js
   const allowedOrigin = resolveCloudCalcsSyncOrigin(req);
   res.set({
     ...(allowedOrigin ? {"Access-Control-Allow-Origin": allowedOrigin, "Vary": "Origin"} : {}),
     "Access-Control-Allow-Methods": "POST, OPTIONS",
     "Access-Control-Allow-Headers": "Content-Type, Authorization",
   });
   ```
   When the origin isn't recognized (or is absent), `Access-Control-Allow-Origin` and `Vary` are omitted entirely rather than set to a fallback value — this is a fail-closed design, not fail-open.

Net diff: 20 lines added, 1 removed, all within/above `cloudCalcsSync`. No other function in `index.js` was touched.

### `functions/tests/corsOriginValidation.test.js` (new)

Five tests, two `describe` blocks:

- **Behavioral suite** (`QE #8207 CWE-346 fix: cloudCalcsSync validates the request Origin`):
  1. Allowlisted origin on an OPTIONS preflight → `Access-Control-Allow-Origin` reflects it, `Vary: Origin` is set, status 204.
  2. Unrecognized origin on OPTIONS → no `Access-Control-Allow-Origin` header, still 204.
  3. No `Origin` header at all (native/FlutterFlow-style caller) → no CORS header, request still proceeds through normal handler logic (asserted via downstream auth/validation behavior, not blocked at the origin check).
  4. Allowlisted origin present but no `Authorization` header → still 401, proving the origin allowlist doesn't bypass the existing CWE-306 auth check.

- **Static-source guard** (`QE #8207 (CWE-346, fingerprint ...) regression`):
  5. Reads `index.js` off disk, extracts the `cloudCalcsSync` function body via string slicing between `exports.cloudCalcsSync = onRequest(` and the next `\nexports.`, and asserts the wildcard pattern `"Access-Control-Allow-Origin": "*"` is absent from it while `resolveCloudCalcsSyncOrigin(req)` is present. This catches any future regression that reintroduces the wildcard specifically in this function, independent of the behavioral tests.

Test file mocks `firebase-admin`, `oaDataApi`, `propertyProcessor`, `hubspotIntegration`, `dealScoringEngine`, `fluidcmHandoff`, `ga4Service`, and `ga4Transformer` — the same dependency set `cloudCalcsSync` transitively touches — so the suite runs without live Firebase or external API access. `mockReq`/`mockRes` helpers simulate the Express-style `req`/`res` objects Firebase Functions' `onRequest` provides, including a `req.get(name)` implementation that returns the `Origin` or `Authorization` header based on what the test passes in.

## Configuration

No new environment variables, secrets, or config files. The allowlist is a static in-code `Set` in `functions/index.js` — there is no `CORS_ORIGINS` env var or Firebase Hosting-derived config in this repo. If the set of valid frontend origins changes (new custom domain, staging environment, preview channel), it must be updated directly in `CLOUD_CALCS_SYNC_ALLOWED_ORIGINS`.

## Gotchas & Nuances

- **The finding's cited line number (226) was stale by the time this ran.** Three prior NIGHTSHIFT passes (CWE-306, CWE-532, CWE-770) had already modified this same file, shifting the CORS block to ~line 196-200. If you're auditing this fix against the original finding, match on the evidence text (`res.set({...})` with the CORS headers), not the line number.
- **This fix is intentionally narrow.** The identical `"Access-Control-Allow-Origin": "*"` pattern still exists in 7 other places: `corsProxy`, `cloudCalcs`'s OPTIONS branch, and 3 `hubspot*` endpoints in `index.js`, plus 2 auth-failure response paths in `authGuard.js`. These were out of scope for this fingerprint (`occurrence_count: 1`) and were deliberately left untouched — do not assume this PR hardens CORS repo-wide.
- **`authGuard.js`'s wildcard on 401 responses is not a regression of this fix** — it was already there, is unrelated to `cloudCalcsSync`, and the smoke suite passing with it still present is expected, not a leak.
- **Fail-closed, not fail-open:** an unrecognized or missing `Origin` results in *no* CORS header, not a default/fallback origin. This is deliberate — silently degrading to a permissive default would reintroduce the same class of bug.
- **Non-browser callers are unaffected.** FlutterFlow's HTTP client (and similar native callers) don't send/enforce CORS the way browsers do, so omitting the header for them doesn't break functionality — verified by the "no Origin header" test case, which confirms the request still proceeds to normal auth/validation logic.
- **`localhost:8080` is hardcoded into the same allowlist as production origins.** This was the simplest option under the "no broad refactors" constraint, but means local dev config lives in the same list as production trust decisions — worth revisiting if this pattern gets replicated to other endpoints.

## Testing

Run the targeted regression suite from `functions/`:

```bash
cd functions
npx jest tests/corsOriginValidation.test.js --runInBand
```
Expected: 1 suite, 5/5 tests passed.

Run the required repo-wide smoke command:

```bash
cd functions
npm test -- --watchAll=false --passWithNoTests
```
Expected: 8 suites, 51/51 tests passed (includes the new suite plus all pre-existing coverage, including `authGuard.js` tests that still exercise its unrelated, unchanged wildcard-on-401 behavior).

**Known gaps:** no test exists yet for the 7 other wildcard occurrences, since they're out of scope for this finding. If those are remediated later, follow the same pattern here — allowlist + resolver helper + behavioral tests + a static-source guard — rather than introducing a new approach per endpoint.
