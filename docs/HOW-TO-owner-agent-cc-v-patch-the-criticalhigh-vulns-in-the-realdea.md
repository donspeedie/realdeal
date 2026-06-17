# How-To: Patch Critical/High Vulns — RealDeal Landing + Firebase Functions

## Overview

This documents the security hardening pass applied to RealDeal's `landing/` and `functions/` packages on 2026-06-17. It cleared all critical and high vulnerabilities from both packages using a combination of `npm audit fix`, manual dependency pins, and source-level hardening in `hubspotIntegration.js`. Twenty-six moderate vulnerabilities remain in `functions/` pending a `firebase-admin` major version migration.

---

## Prerequisites

- Node 20.x (Firebase functions requirement)
- Access to `nightshift/grd-sec2-1b38a1a6` branch (or merge to main after review)
- Firebase CLI for deploy (not included here — deploy is a separate human-reviewed step)

---

## What Was Changed

### `landing/package.json`

**Vite + esbuild CORS bypass fix (HIGH):**

```json
"vite": "^6.4.3",
"@vitejs/plugin-react-swc": "^4.3.1"
```

The esbuild CORS bypass (CVE in esbuild dev-server, tracked via Vite) is not auto-fixed by `npm audit fix` because it requires a semver bump that the audit tool treats as potentially breaking. Pinning Vite to `^6.4.3` forces resolution to a version that ships the patched esbuild. Confirm the build is clean after any future vite upgrade:

```bash
cd landing && npm run build
```

**All other landing fixes:** applied by `npm audit fix` — protobufjs, react-router, rollup, form-data, jws, lodash, axios.

---

### `functions/package.json`

**All critical/high fixes:** applied by `npm audit fix` — fast-xml-parser, @grpc/grpc-js, plus overlapping lodash/jws/axios chains.

**What `npm audit fix` did NOT fix:** the `firebase-admin` 12 transitive chain (uuid, gaxios) — 26 moderate findings. These require `firebase-admin` 12→14 upgrade. See [Deferred Work](#deferred-work).

---

### `functions/hubspotIntegration.js`

**Prototype pollution hardening — `createOrUpdateContact()` and `createDeal()`:**

Both functions accepted a `customProperties` argument and merged it into the HubSpot API payload without key validation. An attacker who controlled the call site could inject `__proto__`, `constructor`, or `prototype` keys and pollute the JavaScript prototype chain.

Fix pattern applied to both functions:

```javascript
// Before (unsafe merge)
const properties = {
  email: contactData.email,
  ...customProperties
};

// After (filtered merge)
const safeCustomProperties = Object.fromEntries(
  Object.entries(customProperties || {}).filter(
    ([key]) => !['__proto__', 'constructor', 'prototype'].includes(key)
  )
);
const properties = {
  email: contactData.email,
  ...safeCustomProperties
};
```

**Email validation — `createOrUpdateContact()`:**

Added format validation at the function boundary before the HubSpot API call:

```javascript
const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
if (!emailRegex.test(contactData.email)) {
  throw new functions.https.HttpsError('invalid-argument', 'Invalid email format');
}
```

---

## Running the Audit

```bash
# Landing
cd landing && npm audit

# Functions
cd functions && npm audit
```

Expected state post-patch:
- `landing/`: 0 vulnerabilities
- `functions/`: 26 moderate (firebase-admin chain only)

---

## Running Tests

```bash
cd functions && npm test
```

Expected: 9/9 passing. Tests cover the Firebase function handlers. They do not currently have unit tests for the `hubspotIntegration.js` prototype pollution filter — see [Gaps](#gaps--known-issues).

---

## Deferred Work

### `firebase-admin` 12 → 14 Migration (GRD-SEC-3)

**Root cause of remaining 26 moderate vulns.** The `firebase-admin` 12 package has a transitive dependency chain through `uuid` and `gaxios` with known moderate-severity advisories.

**Why deferred:** Major version upgrade (12→14) — breaking API changes are possible. Needs a migration plan:

1. Review firebase-admin v13 and v14 changelogs for breaking changes in the functions codebase
2. Update initialization patterns if `initializeApp()` / `getFirestore()` / `getAuth()` signatures changed
3. Run full test suite, check for runtime behavior changes in emulator
4. Audit any direct calls to deprecated methods

**Not safe to do unreviewed overnight.** Scope as a dedicated NightShift run with explicit migration instructions.

### HubSpot Endpoint Auth (GRD-SEC-4)

The lead-capture endpoints (`/createContact`, `/createDeal`) are intentionally public — they're called from the landing page browser JS. No server-side token auth. This is a known architecture decision, not an oversight, but it means a motivated attacker can spam the HubSpot CRM.

Hardening options:
- reCAPTCHA v3 on the frontend + server-side token validation
- Rate limiting at the Firebase Functions level
- Honeypot field validation

Requires frontend coordination before implementing.

---

## Gaps / Known Issues

1. **No unit tests for prototype pollution filter.** The filter logic in `hubspotIntegration.js` is correct but untested. Add tests that assert `__proto__`/`constructor`/`prototype` keys are stripped and that legitimate `customProperties` keys pass through.

2. **Vite version is range-pinned (`^6.x`), not exact.** `^6.4.3` allows future 6.x patch bumps. If a future 6.x release introduces a regression, lock to exact version. Watch `npm audit` output after any `npm update` in `landing/`.

3. **`firebase-admin` moderate chain is visible but not blocking.** `npm audit --audit-level=high` passes. If you're running `npm audit` without a level flag and seeing failures in CI, add `--audit-level=high` to the CI audit step to gate only on high/critical.

---

## Deploy Checklist (for human reviewer)

- [ ] Review diff on `nightshift/grd-sec2-1b38a1a6`
- [ ] Confirm `landing/` build passes locally: `cd landing && npm run build`
- [ ] Confirm functions tests pass: `cd functions && npm test`
- [ ] Run `npm audit` on both packages, confirm no critical/high
- [ ] Merge to main
- [ ] Deploy functions: `firebase deploy --only functions`
- [ ] Deploy hosting: `firebase deploy --only hosting`
- [ ] Verify lead capture form end-to-end post-deploy
