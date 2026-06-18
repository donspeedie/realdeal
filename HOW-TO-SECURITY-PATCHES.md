# HOW-TO: Security Patching for RealDeal (Landing + Firebase Functions)

Technical reference for maintaining and extending the security posture of this repo.

---

## Package Structure

```
RealDeal/
├── landing/          # React+Vite SPA — npm package, run audits here
│   ├── package.json
│   └── src/lib/firebase.ts   # Firebase web config (public by design)
└── functions/        # Firebase Cloud Functions — separate npm package
    ├── package.json
    └── hubspotIntegration.js  # HubSpot CRM integration
```

Both directories have independent `node_modules` and `package-lock.json`. Audit and fix them separately.

---

## Running Security Audits

```bash
# Landing
cd landing && npm audit

# Functions
cd functions && npm audit

# Auto-fix non-breaking issues
cd landing && npm audit fix
cd functions && npm audit fix
```

`npm audit fix --force` installs breaking upgrades — review the "Will install X, which is a breaking change" warning before running.

---

## Vite/esbuild Vulnerability (GHSA-67mh-4wv8-2f99)

**What:** esbuild's dev server allows cross-origin requests from any website. Only affects `vite dev`, not production builds.

**Fixed in:** vite ≥6.4.3

**Advisory range:** `vite <=6.4.2` is vulnerable. Any version ≥6.4.3 is safe.

**Current pin:** `landing/package.json` → `"vite": "^6.4.3"`

**Companion upgrades required:**
- `@vitejs/plugin-react-swc`: must be `^4.x` for vite 6 compat (3.x only supports vite 4/5)
- `lovable-tagger`: `^1.3.0` supports `vite >=5.0.0 <9.0.0` — no changes needed beyond 1.3.0

**To upgrade further (vite 7 or 8):**
```bash
cd landing
npm install vite@^7.3.5 @vitejs/plugin-react-swc@^4.3.1 lovable-tagger@^1.3.0
npm run build  # verify
npm audit      # confirm 0 vulns
```

vite 7 requires Node ≥20.19.0. The functions package already targets node 22 — the landing page is used in the same environment, so this should be fine.

---

## Firebase Admin — Deferred Moderate Vulns

**What:** 26 moderate-severity vulns remain in functions, all tracing back to `uuid <11.1.1` inside the `firebase-admin` / `google-gax` / `@google-cloud/firestore` dependency chain.

**Root fix:** Upgrade `firebase-admin` from 12.x → 14.x.

**Why deferred:** firebase-admin 14 is a major version with breaking API changes. Needs:
1. Review of [firebase-admin v14 migration guide](https://firebase.google.com/docs/admin/migrate-node-v13)
2. Test pass against all Cloud Functions (especially Firestore reads/writes, Storage, Auth)
3. Staged deploy with rollback plan

**To execute the upgrade:**
```bash
cd functions
npm install firebase-admin@^14
npm test             # run unit tests
# Manual: test each function against Firebase Emulator
firebase emulators:start --only functions
```

---

## Prototype Pollution — `hubspotIntegration.js`

**What:** `createOrUpdateContact()` and `createDeal()` accept a `customProperties` object from HTTP request bodies and merge it into HubSpot API calls. Without key filtering, `__proto__` / `constructor` / `prototype` keys would poison the prototype chain.

**Fixed in:** commit fa700f7 — key blocklist applied before merge.

**Pattern (used in both functions):**
```js
if (customProperties) {
  const BLOCKED_KEYS = new Set(['__proto__', 'constructor', 'prototype']);
  for (const [k, v] of Object.entries(customProperties)) {
    if (!BLOCKED_KEYS.has(k)) properties[k] = v;
  }
}
```

**If you add more functions that accept user-supplied property objects:** use this same pattern. Do NOT use `Object.assign(target, userInput)` or `{...target, ...userInput}` directly with untrusted input.

---

## Email Validation

`createOrUpdateContact()` in `hubspotIntegration.js` now validates email format at the function boundary:

```js
if (!contactData.email || !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(contactData.email)) {
  throw new Error('Invalid email address');
}
```

This is intentionally a permissive RFC 5322 approximation. HubSpot will enforce stricter validation on the API side. The goal here is to reject clearly malicious strings (`<script>`, `http://evil.com`) before they get embedded in contact notes.

---

## Firebase Web API Key (NOT a vulnerability)

`landing/src/lib/firebase.ts` contains:
```ts
const firebaseConfig = {
  apiKey: "AIzaSyB4UDxpAWp6my_kJCBeU8ZIcBkuoyn7-F0",
  ...
};
```

**This is correct and intentional.** Firebase web SDK keys are meant to be public. They're not authentication credentials — they identify which Firebase project to connect to. Security is enforced by:
1. **Firebase Security Rules** (Firestore, Storage, Realtime DB)
2. **Authorized domains** configured in Firebase Console → Authentication
3. **App Check** (if configured)

Do NOT move this to an env var. It will break the build (Vite's `import.meta.env` requires `VITE_` prefix and adds complexity) and provides no security benefit since the key is already embedded in the compiled JS bundle.

---

## HubSpot Lead-Capture Endpoints — Auth Gap

Three Firebase Functions are currently unauthenticated public HTTP endpoints:
- `hubspotTrackCalculation`
- `hubspotCreateContact`
- `hubspotFindContact`

They have `Access-Control-Allow-Origin: *` for browser access from the landing page.

**Current risk:** Anyone can call these directly (outside the browser) to:
- Create/overwrite HubSpot contacts
- Search contacts by email (data enumeration)
- Flood the account with spam

**Options for future hardening:**
1. **HMAC signature**: Landing page includes `X-Signature: HMAC-SHA256(timestamp + body)` with a shared secret. Functions verify signature and timestamp freshness (reject >5 min old).
2. **Firebase App Check**: Limits calls to verified Firebase-connected apps.
3. **Rate limiting**: Use Firebase's built-in throttling or a Cloudflare Worker in front.

None of these were applied during this NightShift run — adding auth without coordinating with the frontend caller would break the lead-capture flow.

---

## Recurring Audit Cadence

- Run `npm audit` in both `landing/` and `functions/` before every deploy
- Auto-fix non-breaking issues (`npm audit fix`) as part of CI pre-deploy check
- Review and schedule breaking-change upgrades quarterly
- `npx update-browserslist-db@latest` in `landing/` to keep CSS compatibility data current
