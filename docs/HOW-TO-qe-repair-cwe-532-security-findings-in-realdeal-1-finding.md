# How-To: QE repair: CWE-532 security findings in realdeal (1 finding)

## Overview

This repair closes QE finding #8159 (CWE-532, "Insertion of Sensitive Information into Log File," fingerprint `b6568a4c580c172e5748d29b853014b1`, severity medium) in the `realdeal` Firebase Functions codebase. The `cloudCalcs` HTTP Cloud Function — a public, CORS-open endpoint — was writing raw `req.headers`, `req.body`, and `req.query` to Cloud Functions logs on every request. Those raw dumps are replaced with key-only logging via a new `safeKeys()` helper, preserving debug visibility (which fields were present) without leaking values (auth tokens, cookies, PII).

## Setup

- Node 20 (per project convention; `functions/` is the Firebase Functions package).
- No root `package.json` in this repo — all commands run from `functions/`.
- Dependencies must be installed once before running tests: `cd functions && npm ci` (uses the committed lockfile so the project's own Jest resolves, not a globally installed one).
- No new dependencies were introduced by this fix — `functions/logSafety.js` has zero imports.

## Implementation Details

**`functions/logSafety.js`** (new file)
Single-purpose helper module:
```js
const safeKeys = (obj) => {
  if (!obj || typeof obj !== "object") return [];
  return Object.keys(obj);
};

module.exports = { safeKeys };
```
Returns field names only — never touches or serializes values. Guards against `null`/`undefined`/non-object input by returning `[]` rather than throwing, since `req.headers`/`req.body`/`req.query` are not guaranteed to be populated on every code path (e.g., malformed requests, `OPTIONS` preflight).

**`functions/index.js`** (modified — `cloudCalcs` handler, originally around line 495 per the QE scan, actual location lines 351-353 at repair time; QE line numbers drift as the file changes, always confirm current location by matching the flagged evidence text, not the reported line number)
Four call sites changed, all in the same function:
```js
// before
console.log(`📨 Headers:`, JSON.stringify(req.headers, null, 2));
console.log(`📦 Body:`, JSON.stringify(req.body, null, 2));
console.log(`🔍 Query:`, JSON.stringify(req.query, null, 2));
// ...25 lines later...
console.log(`⚙️ All parameters:`, JSON.stringify(params, null, 2));

// after
console.log(`📨 Header keys:`, safeKeys(req.headers));
console.log(`📦 Body keys:`, safeKeys(req.body));
console.log(`🔍 Query keys:`, safeKeys(req.query));
// ...
console.log(`⚙️ Parameter keys:`, safeKeys(params));
```
The fourth call site (`⚙️ All parameters:`) was **not** flagged by the QE scanner directly but was fixed as part of the same repair — it re-dumps the identical `req.body`-derived object (via the locally built `params`) under a different log label, same function, same root cause. Leaving it in place would have reopened the exact vulnerability the flagged-line fix closed, twenty-five lines down. Treat "same data, different log label, same function" as in-scope for a CWE-532 fix even when the scanner only flagged one of the two log lines.

Import added at the top of `functions/index.js`:
```js
const {safeKeys} = require("./logSafety");
```

**`functions/tests/logSafety.test.js`** (new file)
Five tests:
1. `safeKeys` returns field names only, never values (asserts the serialized output does not contain a planted secret string).
2. `safeKeys` handles `undefined`/`null`/non-object input without throwing.
3. `safeKeys` handles an empty object.
4. Regression guard: reads `functions/index.js` off disk at test time and asserts it does **not** match `JSON.stringify(req.headers`, `JSON.stringify(req.body`, `JSON.stringify(req.query`, or `JSON.stringify(params` — this is the test that will fail if the raw dump pattern ever comes back, regardless of who reintroduces it or why.
5. Regression guard (positive): asserts `functions/index.js` contains `safeKeys(req.headers)`, `safeKeys(req.body)`, `safeKeys(req.query)`.

## Configuration

No configuration, environment variables, or secrets changed. `cloudCalcs` still declares `secrets: [oaDataApiUrl]` unchanged. No `.env` or Firebase config files were touched.

## Gotchas & Nuances

- **QE line numbers drift.** The scan reported line 495; by repair time the actual code was at lines 351-353. Always locate the finding by matching the quoted evidence text against current `main`, not by trusting the reported line number — the file may have changed since the scan ran.
- **Don't just delete the logging.** The naive fix ("remove the console.log entirely") throws away real operational value — knowing which fields a request included is often the first thing you need when triaging a broken request against this endpoint. `safeKeys()` preserves that signal while eliminating the leak. If a future incident genuinely needs full request-body inspection, build a scoped, explicit redaction allowlist rather than reverting to raw `JSON.stringify` dumps.
- **Check for duplicate/adjacent dumps of the same data.** The scanner flagged three lines; a fourth line twenty-five lines down was logging the same underlying data (`req.body` → `params`) under a different label and wasn't separately flagged. A find-and-replace limited strictly to the reported lines would have left the vulnerability functionally open. When fixing a CWE-532 finding, grep the rest of the function (not just the flagged lines) for other raw dumps of the same request object.
- **No root `package.json`.** Test/lint commands must run from `functions/`, not the repo root. The sibling `app/` directory is an unrelated Flutter project — do not run Node commands against it for this fix.
- **PR was not opened by these phases.** Per the completion standard, the repair phases implement and test only — they do not push or open a PR. That step belongs to the orchestrator. As of this write-up, the fix exists as uncommitted/untracked changes in this worktree (`git status`: modified `functions/index.js`, untracked `functions/logSafety.js` and `functions/tests/logSafety.test.js`) on branch `nightshift/grd-qe-cwe532-3ffb-0714270e` — confirm the orchestrator's commit/push/PR step has actually run before assuming this finding is closed end-to-end.

## Testing

Run the targeted regression suite only:
```bash
cd functions
npx jest tests/logSafety.test.js --runInBand
```
Expected: 1 suite, 5/5 tests pass.

Run the full required smoke command (must pass before this finding is considered resolved):
```bash
cd functions
npm test -- --watchAll=false --passWithNoTests
```
Expected: 3 suites, 14/14 tests pass (includes the 5 new tests above plus 9 pre-existing tests elsewhere in `functions/`).

**Known gaps:** No repo-wide sweep was performed for similar raw-log patterns outside the `cloudCalcs` function — this repair is scoped strictly to QE #8159's flagged function per the single-finding batch. If a future QE pass or manual review turns up other `JSON.stringify(req.*)`-style log statements elsewhere in `functions/`, they are not covered by this fix or its tests.
