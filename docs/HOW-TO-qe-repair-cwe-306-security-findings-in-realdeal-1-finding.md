# How-To: QE repair: CWE-306 security findings in realdeal (1 finding)

## Overview

This documents the fix for QE #8154: a critical CWE-306 (Missing Authentication for Critical Function) finding in `functions/index.js`. The `testGA4Sync` Cloud Function was a public `onRequest` HTTP endpoint with wildcard CORS and no auth check, allowing any unauthenticated caller to trigger GA4 API calls and Firestore writes using attacker-controlled parameters. The fix gates the endpoint behind a shared Firebase-auth guard already established by a sibling fix (QE #8149–#8153) in the same file.

## Setup

- Node 20 (RealDeal Firebase Functions runtime).
- Working directory for all commands below: `functions/` (this is the only directory in the repo with a `package.json` that defines a `test` script — there is no root-level test runner).
- No new dependencies were introduced. `functions/authGuard.js` uses `firebase-admin` for token verification, which was already a dependency.
- No new environment variables or secrets were required.

## Implementation Details

### `functions/authGuard.js` (new, 30 lines)

Exports `requireFirebaseAuth(req, res)`, a shared guard:
- Reads the `Authorization` header, expects a `Bearer <token>` format.
- Returns `false` and writes a 401 response (via `res`) if the header is missing, malformed, or the token fails `admin.auth().verifyIdToken()`.
- Returns `true` if the token is valid, allowing the caller to proceed.

This file is **byte-for-byte identical** to the version introduced by sibling branch `nightshift/grd-qe-cwe306-0882-27637ea7`, which fixed 5 related findings (QE #8149–#8153: `cloudCalcs`, `cloudCalcsSync`, and three `hubspot*` endpoints) in this same file. Keeping the two copies identical is deliberate — see Gotchas below.

### `functions/index.js` (+3 lines)

- Requires `authGuard.js` at the top of the file (same require statement pattern as the sibling fix).
- Inside `exports.testGA4Sync`, immediately after the existing OPTIONS/CORS-preflight handling and before any Firestore or GA4 API work:
  ```js
  if (!(await requireFirebaseAuth(req, res))) return;
  ```
- No changes to CORS headers, response shapes, or the GA4 sync/Firestore business logic itself.

### `functions/tests/authGuard.test.js` (new)

Unit tests for the guard in isolation:
- Missing `Authorization` header → rejected.
- Non-bearer / malformed header → rejected.
- Invalid or expired token → rejected.
- Valid token → passes.

### `functions/tests/testGA4SyncAuth.test.js` (new)

Endpoint-level regression test specific to QE #8154:
- No auth header → 401.
- Invalid token → 401.
- OPTIONS preflight → still answered without requiring auth (confirms the guard didn't break CORS negotiation).
- Valid token → passes the auth gate (test asserts it then fails on missing `propertyId`, proving the *auth gate* — not some other validation — is what's being exercised).

## Configuration

No configuration changes. The guard relies on Firebase Admin SDK's existing service account/project configuration already used elsewhere in `functions/index.js` — nothing new to provision.

## Gotchas & Nuances

- **Finding line numbers drift.** The QE finding cited `functions/index.js:891`; the actual function was at line 751 by the time this was assessed, due to unrelated repo edits landing between the scan and the repair. Locate findings by function/export name, not by trusting the cited line number.
- **Duplicate `authGuard.js` across two branches, on purpose.** A sibling branch (`nightshift/grd-qe-cwe306-0882-27637ea7`) independently fixed 5 near-identical findings in this same file and introduced its own `authGuard.js`. This repair recreated that file byte-for-byte rather than writing a "compatible" version, so that whichever PR merges first, the second PR applies cleanly against it instead of conflicting. **When these two PRs are merged, sequence them** (merge one, then rebase/merge the other) rather than merging both independently — otherwise expect duplicate-file diff noise in git history for whichever lands second.
- **No rate limiting was added.** This fix only closes the *unauthenticated* access path (CWE-306). It does not add throttling for authenticated callers. If abuse by authenticated callers becomes a concern, that's a separate follow-up, not part of this finding's scope.
- **Do not merge autonomously.** Per the QE repair completion standard, this branch is left committed but unpushed with no PR opened — pushing and opening a draft PR is the orchestrator's responsibility, not the phase agent's.

## Testing

Run the full smoke suite (required for sign-off) from `functions/`:

```bash
npm test -- --watchAll=false --passWithNoTests
```
Expected: 4 test suites, 17 tests, all passing.

Run only the tests targeted at this finding:

```bash
npx jest tests/authGuard.test.js tests/testGA4SyncAuth.test.js --runInBand
```
Expected: 2 test suites, 8 tests, all passing.

**Known gaps:** No load/rate-limit test exists for `testGA4Sync` (out of scope for CWE-306). No integration test against a live Firebase emulator was run — tests mock `firebase-admin`'s token verification rather than exercising a real Firebase Auth token exchange.
