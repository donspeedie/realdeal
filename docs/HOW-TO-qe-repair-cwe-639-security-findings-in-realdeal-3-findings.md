# How-To: QE repair: CWE-639 security findings in realdeal (3 findings)

## Overview

Three Firebase Cloud Functions in `functions/index.js` — `hubspotFindContact`, `hubspotCreateContact`, `hubspotTrackCalculation` — authenticated callers via Firebase Auth but never verified the caller was authorized to act on the specific HubSpot contact `email` supplied in the request (CWE-639: Authorization Bypass Through User-Controlled Key). This doc covers the added `requireOwnEmail()` authorization guard, where it's wired in, and what to check before deploying.

## Setup

- Node 20.x (per project convention), `functions/` is a standard Firebase Functions package.
- No new dependencies — the fix is pure application logic on top of the existing `firebase-admin` SDK already used by `requireFirebaseAuth`.
- No new environment variables or secrets. `HUBSPOT_API_KEY` (via `defineSecret`) is unchanged from before.

## Implementation Details

### `functions/authGuard.js`

Added `requireOwnEmail(decodedToken, email, res)`, exported alongside the existing `requireFirebaseAuth(req, res)`:

```js
function requireOwnEmail(decodedToken, email, res) {
  const tokenEmail = typeof decodedToken.email === "string" ? decodedToken.email.toLowerCase() : null;
  const requestedEmail = typeof email === "string" ? email.toLowerCase() : null;

  if (!tokenEmail || !requestedEmail || tokenEmail !== requestedEmail) {
    res.set({"Access-Control-Allow-Origin": "*"});
    res.status(403).json({error: "Forbidden: email must match the authenticated account"});
    return false;
  }
  return true;
}
```

- Synchronous — takes the already-decoded token (no extra Firebase round trip).
- Fails closed: missing token email claim, missing/invalid requested email, or a mismatch all return `false` and write a 403.
- Case-insensitive comparison only; does **not** check `decodedToken.email_verified`. See Gotchas.
- Sets `Access-Control-Allow-Origin: *` on the error response, matching the CORS behavior of `requireFirebaseAuth`'s own error paths, so browser callers can read the 403 body instead of hitting an opaque CORS failure.

### `functions/index.js`

Import updated: `const {requireFirebaseAuth, requireOwnEmail} = require("./authGuard");`

All three handlers changed from discarding the auth result to capturing it, then gating on `requireOwnEmail` immediately after each endpoint's pre-existing "email is required" 400 check:

```js
// before
if (!(await requireFirebaseAuth(req, res))) return;
// ...
if (!email) {
  return res.status(400).json({error: "Email is required"});
}
// ... HubSpot call uses `email` directly

// after
const decodedToken = await requireFirebaseAuth(req, res);
if (!decodedToken) return;
// ...
if (!email) {
  return res.status(400).json({error: "Email is required"});
}
if (!requireOwnEmail(decodedToken, email, res)) return;
// ... HubSpot call uses `email` directly
```

Applied at:
- `hubspotTrackCalculation` (QE #8202) — line ~518 (post-fix)
- `hubspotCreateContact` (QE #8201) — line ~574 (post-fix)
- `hubspotFindContact` (QE #8200) — line ~621 (post-fix)

Ordering matters: the 400 "email required" check stays first (it's a format/presence check, not an authz check), then `requireOwnEmail` runs before any HubSpot SDK call — no HubSpot API traffic is generated for a request that fails the ownership check.

Untouched: `cloudCalcs` and `cloudCalcsSync` (the two endpoints from the prior CWE-306 fix) — they don't accept a user-controlled resource key, so CWE-639 doesn't apply there. CORS preflight handling (`OPTIONS` → 204) in all three handlers is unchanged.

## Configuration

No new config. No new secrets or env vars. The guard relies entirely on the `email` claim already present on a Firebase ID token for non-anonymous sign-in methods (password, Google, etc.) — nothing to provision.

## Gotchas & Nuances

- **Anonymous Firebase sessions are now hard-blocked on these 3 endpoints.** Anonymous auth tokens have no `email` claim, so `requireOwnEmail` always returns `false` for them — the request gets a 403, not a 401 (401 is reserved for "no valid token at all," which `requireFirebaseAuth` already handles). If any client relies on anonymous+arbitrary-email access to these endpoints today, that flow breaks on deploy. **Verified via code search that no in-repo caller (Flutter app, React landing page) exists for any of these 3 endpoints** — but an out-of-repo caller (HubSpot workflow, Zapier automation, a marketing site in another repo) was not and cannot be ruled out from this codebase alone. Confirm before deploying to production.
- **No `email_verified` check.** The guard trusts `decodedToken.email` as the ownership anchor without also requiring `decodedToken.email_verified === true`. For Firebase's built-in email/password and OAuth providers this claim is generally trustworthy, but if a future auth method could mint a token with an unverified `email` claim, this guard would trust it. Flagged as an open question in the overnight report, not fixed preemptively since no current auth path in this repo exercises that gap.
- **Case-insensitive matching only** — `caller@Example.com` matches `caller@example.com`. This mirrors how HubSpot itself treats email as the dedup key, so it's intentional, not an oversight.
- **`requireOwnEmail` takes the decoded token, not the raw request** — if you add a fourth user-keyed HubSpot endpoint later, remember to capture `requireFirebaseAuth`'s return value (previously many handlers discarded it with `if (!(await requireFirebaseAuth(req, res))) return;`) rather than re-calling `requireFirebaseAuth` a second time.
- **Ordering is load-bearing**: `requireOwnEmail` must run after the "is email present" 400 check (so `typeof email === "string"` isn't the only guard against `undefined`) and before any external HubSpot call — get this backwards and you either 500 on missing input or leak an API call to HubSpot before the authz check runs.

## Testing

Run the full suite from `functions/`:

```bash
npm test -- --watchAll=false --passWithNoTests
```

Targeted regression tests only:

```bash
npx jest tests/authGuard.test.js tests/hubspotEmailOwnership.test.js --runInBand
```

Lint:

```bash
npx eslint index.js authGuard.js tests/authGuard.test.js tests/hubspotEmailOwnership.test.js
```

**Coverage:**
- `functions/tests/hubspotEmailOwnership.test.js` (new, 9 tests) — table-driven across all 3 endpoints (`test.each`): mismatched email → 403 and the underlying HubSpot function (`trackPropertyCalculation` / `createOrUpdateContact` / `findContactByEmail`) is never invoked; anonymous token (no `email` claim) → 403 regardless of requested email; matching email including a case difference → 200 with the HubSpot function invoked exactly once.
- `functions/tests/authGuard.test.js` (extended, +4 tests) — direct unit tests of `requireOwnEmail`: no email claim on token, missing requested email, mismatched email, case-insensitive match succeeds.
- Full suite result at last verification: 8 suites, 59/59 passing (46 pre-existing + 13 new, zero regressions).

**Known gaps:**
- No test exercises an out-of-repo caller scenario (can't — it's out of repo by definition). This is the item that needs a human product decision before deploy, not a test gap that can be closed in-repo.
- No test covers the hypothetical unverified-`email_verified` token scenario described in Gotchas, since no current auth path in this app produces one.
