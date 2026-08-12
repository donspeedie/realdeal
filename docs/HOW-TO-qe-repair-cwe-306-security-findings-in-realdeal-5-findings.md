# How-To: QE repair: CWE-306 security findings in realdeal (5 findings)

## Overview

Five RealDeal Cloud Functions (`cloudCalcs`, `cloudCalcsSync`, `hubspotTrackCalculation`, `hubspotCreateContact`, `hubspotFindContact`) were raw `onRequest` HTTP endpoints with wildcard CORS and no authentication check, each guarding a Secret-Manager-backed credential (OA Data API or HubSpot API key). This doc covers the shared auth-gate fix (`functions/authGuard.js`) applied to all five, and how to extend it to future `onRequest` endpoints.

## Setup

- Node 20.x (per project stack), `functions/` is a standalone npm package — run all commands from `functions/`.
- Install/verify deps: `npm install` (no new dependencies were added; `firebase-admin` was already a dependency).
- Firebase Admin SDK must be initialized before any handler using `requireFirebaseAuth` runs — it already is, at the top of `functions/index.js`, so no change needed there.
- Tests run under Jest (already configured in `functions/package.json`).

## Implementation Details

**`functions/authGuard.js`** (new file)
- Exports one function: `requireFirebaseAuth(req, res)`.
- Reads the `Authorization` header, requires `Bearer <token>` format via regex (`/^Bearer (.+)$/`).
- Verifies the token with `admin.auth().verifyIdToken(token)`.
- On any failure (missing header, malformed header, invalid/expired token), writes a `401` JSON response — `res.set({"Access-Control-Allow-Origin": "*"})` is applied to the error response too, so browser callers can still read the error body — and returns `null`.
- On success, resolves with the decoded Firebase token (not currently used by callers beyond the truthiness check, but available for future per-user logic, e.g. rate limiting by `uid`).

**`functions/index.js`** (modified — 5 call sites, 1 import)
- New import: `const {requireFirebaseAuth} = require("./authGuard");`
- Each of the 5 handlers gets one line inserted **after** the existing `OPTIONS`/CORS-preflight branch and **before** any business logic:
  ```js
  if (!(await requireFirebaseAuth(req, res))) return;
  ```
- Line-by-line placement (see `git diff functions/index.js` for exact context):
  - `cloudCalcsSync` — inserted right after the preflight check, before body parsing.
  - `cloudCalcs` — inserted right after the preflight check, **before** `initSSE(res)` is called. This ordering is deliberate: `initSSE` opens a Server-Sent-Events stream and starts writing to `res`. If the auth check ran after `initSSE`, a 401 would have to be written mid-stream (or not at all). Gating first keeps the failure path a normal JSON 401.
  - `hubspotTrackCalculation`, `hubspotCreateContact`, `hubspotFindContact` — inserted right after each handler's preflight check, before the `try` block containing business logic.

**`functions/tests/authGuard.test.js`** (new file, 4 tests)
- Unit tests directly against `requireFirebaseAuth`: missing `Authorization` header, malformed (non-`Bearer`) header, `verifyIdToken` throwing, and a valid token resolving successfully. Mocks `firebase-admin`'s `auth()`.

**`functions/tests/httpEndpointAuth.test.js`** (new file, 19 tests)
- Integration-style tests against all 5 exported handlers directly (not through the Firebase emulator). For each endpoint: no-token → 401, invalid-token → 401, `OPTIONS` → 204 with no auth required. For the 4 non-streaming endpoints, an additional case proves a valid token clears the gate and the handler proceeds to its next validation step (e.g., missing `email` / `location` field) rather than being blocked — confirming the gate isn't just failing closed on everything.

**`HOW-TO-SECURITY-PATCHES.md`** (modified)
- The prior "Auth Gap — none of these were applied" section (written by an earlier NightShift run that explicitly deferred this fix) was replaced with the actual fix record, plus the deployment-blocker note about the live Flutter caller (see Gotchas below).

## Configuration

No new environment variables, secrets, or config files. The fix relies entirely on:
- `firebase-admin` (already a dependency) and its `admin.auth()` module, which uses the project's existing Firebase Admin credentials (already initialized in `functions/index.js`).
- No changes to `functions/package.json`, Secret Manager bindings, or `firebase.json`.

## Gotchas & Nuances

- **This is not a login wall.** `requireFirebaseAuth` accepts *any* valid Firebase ID token, including anonymous-auth sessions (already used elsewhere in the RealDeal app). It proves the caller went through Firebase Auth, not that they're a named/verified user. If a stricter bar is needed later (e.g., email-verified only, or role-based), add that check inside `requireFirebaseAuth` or as a second gate — don't loosen the shared helper for one caller and tighten it for another without renaming it.
- **`OPTIONS` preflight is intentionally NOT gated.** Browsers never attach credentials/headers to a CORS preflight request, so gating `OPTIONS` would break CORS entirely for legitimate browser callers. The auth check is inserted after the preflight `if (req.method === "OPTIONS") { ... return res.status(204).send(""); }` block, never before it.
- **`cloudCalcs` ordering is load-bearing.** If a future edit moves `requireFirebaseAuth` after `initSSE(res)`, a rejected caller will get a broken/hanging SSE stream instead of a clean 401. Keep the auth check before any `res` stream is opened.
- **Known production risk — not resolved by this patch alone:** `cloudCalcs` has a live caller in the Flutter app (`app/lib/backend/api_requests/api_calls.dart`). This patch was scoped to `functions/` only and does **not** verify or update whether that client already sends a Firebase Bearer token. If it doesn't, deploying this fix will 401 real traffic. Same open question applies to any external (non-app) caller of the three HubSpot endpoints (e.g., a marketing site lead-capture form). **Do not deploy until this is verified** — see the roadmap item in the overnight report.
- **This supersedes a prior deferred fix.** An earlier NightShift run (commit `fa700f7`) found this same gap and explicitly declined to fix it for the reason above. If you're auditing history, the old `HOW-TO-SECURITY-PATCHES.md` entry has been replaced, not appended — check `git log -p -- HOW-TO-SECURITY-PATCHES.md` if you need the original deferral note.
- **`hubspotFindContact` is a CRM oracle.** Beyond CWE-306, this endpoint reveals whether an email exists in HubSpot to anyone who can call it. Authentication closes the *unauthenticated* access vector, but any authenticated user can still enumerate emails one at a time. If that's a concern, consider rate-limiting by `uid` in a follow-up (the decoded token from `requireFirebaseAuth` already exposes `uid` for this purpose).

## Testing

Run targeted tests only:
```bash
cd functions
npx jest tests/authGuard.test.js tests/httpEndpointAuth.test.js --runInBand
```
Expected: 2 suites, 23/23 passing.

Run the required repo smoke command (from `functions/`):
```bash
npm test -- --watchAll=false --passWithNoTests
```
Expected: 4 suites, 32/32 passing (9 pre-existing + 23 new — no regressions).

Lint:
```bash
npx eslint index.js authGuard.js tests/authGuard.test.js tests/httpEndpointAuth.test.js
```
Expected: exit 0, no issues.

**Known gaps:**
- No emulator-based end-to-end test (Firebase emulator suite was not exercised) — tests call the exported handler functions directly with mocked `req`/`res`, not through an actual HTTP transport.
- No test verifies real Flutter-app client behavior (whether it currently sends a bearer token) — that requires checking outside this repo/patch, flagged as a pre-deploy blocker above.
