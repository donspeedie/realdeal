---
title: "NightShift Ran a Security Sweep While I Slept"
date: 2026-06-17
tags: [nightshift, security, firebase, vite, ai-dev]
status: draft
---

# NightShift Ran a Security Sweep While I Slept

Every few months I forget to run `npm audit` and then feel mildly irresponsible about it. Last night I handed the job to NightShift — the autonomous overnight agent that does the work I'd otherwise defer for three weeks.

By morning: 0 critical, 0 high, everything building, tests green. Here's what it found and what it decided to fix.

## What It Was Working With

The RealDeal project has two Node packages: a React+Vite landing page and a Firebase Cloud Functions backend. Both are what you'd expect from a modern startup stack — React 18, Tailwind, ShadCN UI, HubSpot integration, GA4 analytics, and a real estate investment calculator.

Neither had had `npm audit` run in a while. The numbers were not pretty.

**Landing:** 24 vulnerabilities — 1 critical, 12 high, 9 moderate, 2 low.
**Functions:** 24 vulnerabilities — 1 critical, 8 high, 9 moderate, 2 low (overlapping counts with shared deps).

The headline items:

- **protobufjs** had a critical arbitrary-code-execution bug (GHSA-xq3m-2v4x-88gg). It's a transitive dependency — nothing you'd ever think to audit manually.
- **fast-xml-parser** in functions had a critical entity-encoding bypass that could enable XML bomb attacks.
- **axios** had an embarrassing pile of CVEs: SSRF via `NO_PROXY` bypass, prototype pollution gadgets, credential leaks through redirect chains, CRLF injection. The axios project went through a rough patch in 2025.
- **react-router-dom** had an XSS via open redirect in the `@remix-run/router` layer.

Most of these were transitive — they're hiding three levels down in the dependency tree, not things you'd ever see in your own `package.json`.

## The Automatic Fixes

`npm audit fix` handled the bulk of it. Two passes resolved all critical and high findings except one: the vite/esbuild chain.

The esbuild development server has a CORS bypass (GHSA-67mh-4wv8-2f99) — any website can send arbitrary requests to it and read responses. Scary in a dev context, irrelevant in production since esbuild just bundles code. But it's still "high" on the audit report, and NightShift is not the kind of agent that shrugs at high-severity findings.

The auto-fixer wanted to jump to `vite@8.0.16` — a two-major-version leap from the project's `5.4.x`. NightShift looked at the advisory range (`vite <=6.4.2` is vulnerable) and realized `6.4.3` is the minimum fix, not 8. It pinned to that and updated the companion plugin `@vitejs/plugin-react-swc` from 3.x to 4.x (which supports vite 6+). The build still compiled. 1688 modules, no errors.

## The Application-Level Find

After resolving the package vulns, NightShift did a sweep of the actual source files — not just the lockfile.

In `hubspotIntegration.js`, two functions (`createOrUpdateContact` and `createDeal`) accept a `customProperties` object from the HTTP request body and merge it directly into a HubSpot properties object with `Object.assign()`. If someone sends `{"customProperties": {"__proto__": {"isAdmin": true}}}`, that's a prototype pollution chain leading directly into HubSpot API calls.

The fix is simple: filter the keys before merging.

```js
const BLOCKED_KEYS = new Set(['__proto__', 'constructor', 'prototype']);
for (const [k, v] of Object.entries(contactData.customProperties)) {
  if (!BLOCKED_KEYS.has(k)) properties[k] = v;
}
```

NightShift also added email format validation — the endpoints checked for the presence of an email but not its structure. An `<img src=x onerror=...>` in the email field would have sailed straight into HubSpot's contact notes.

## What It Left Alone

NightShift flagged but didn't touch a few things.

**Firebase web API key in the landing page source**: It's in `landing/src/lib/firebase.ts` in plain sight. This is actually correct. Firebase web SDK keys are designed to be embedded in client JavaScript — they identify your project, they're not authentication secrets. Security is enforced by Firebase Security Rules, not by hiding the key. Any agent that "fixes" this by moving it to an env var has misunderstood how Firebase works.

**HubSpot endpoints with `Access-Control-Allow-Origin: *`**: Three lead-capture endpoints have no auth checks. They're public by design — the React landing page calls them from the browser. Slapping Bearer token validation on them without knowing the frontend's calling convention would break the app. NightShift flagged it and left it for human review.

**firebase-admin major upgrade**: The 26 remaining moderate vulnerabilities all trace back to `uuid` inside `firebase-admin`'s dependency tree. Fixing them requires `firebase-admin 12 → 14`, a major version bump that touches every Cloud Function. Too risky to ship overnight without testing. Flagged for roadmap.

## The Debrief

What I actually want to highlight here is the decision-making, not the patches.

A dumb automation would have run `npm audit fix --force` and called it done — upgrading vite to 8 and firebase-admin to 14 in one commit, potentially breaking the build and every deployed function. A less confident agent would have stopped at every ambiguity and waited for approval.

NightShift found the minimum-viable fix for vite (6.4.3 not 8), skipped the firebase-admin major bump with documentation, and distinguished between "genuinely public key" and "leaked secret." That's the kind of judgment that makes overnight automation actually useful.

The commit landed at 4:31 AM. My morning audit queue was empty.
