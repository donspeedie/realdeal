# How-To: QE repair: CWE-770 security findings in realdeal (1 finding)

## Overview

This run investigated one QE-flagged CWE-770 (Allocation of Resources Without Limits or Throttling) finding in RealDeal's `functions/index.js` and determined it to be a stale duplicate of an already-remediated finding rather than a live vulnerability. No production code was changed; this doc records the investigation trail and the existing guard that already covers this threat class, so a future scan of the same fingerprint family doesn't trigger duplicate remediation work.

## Setup

- Repository: `realdeal` (Firebase Cloud Functions backend, Node 20)
- Working tree used for this run: `C:\Dev\nightshift-workdirs\RealDeal-grd-qe-cwe770-ef50-fce4c399`
- Prerequisites: Node 20.x, `npm install` run in `functions/` (standard project setup — no new dependencies were introduced by this run)
- Required smoke command: `npm test -- --watchAll=false --passWithNoTests` (run from `functions/`)
- Relevant prior commit: `8e3c4b3` — "[NightShift] GRD-QE-CWE770-56F3" (PR #20, merged 2026-08-23) — this is the commit that actually fixed the underlying bug class referenced by this run's finding.

## Implementation Details

No files were created or modified in this run. For maintainers, here's what already exists and why this finding didn't require touching it:

- **`functions/utils.js`** — contains `resolveProcessingLimits()`, added in commit `8e3c4b3`. This function takes client-supplied `maxPages`/`maxProperties` values and clamps them to hard server-side ceilings:
  - `MAX_ALLOWED_PAGES = 1000`
  - `MAX_ALLOWED_PROPERTIES = 10000`
  - It rejects non-numeric or non-positive input and falls back to safe defaults, rather than trusting `params.maxPages || 1000`-style fallbacks (which only guard against falsy values, not against arbitrarily large ones).

- **`functions/index.js:389`** — `exports.cloudCalcs` calls `resolveProcessingLimits()` before entering its pagination loop, with an inline `CWE-770 guard` comment marking why it's there. This is the enforcement point: no matter what a caller passes in the request body/query, the effective pagination limits used by the loop are clamped server-side.

- **`functions/index.js:260`** — the line cited by this run's finding (QE #8206). In the *current* codebase this line sits inside `exports.cloudCalcsSync`, an unrelated function that formats a JSON response — it is not part of the pagination logic at all. The scanner's evidence text was a verbatim match for the pre-fix `cloudCalcs` code that existed before commit `8e3c4b3`, at a line number that has since shifted because of that same fix. This is the key signal that identified the finding as stale rather than new.

- **`functions/tests/resolveProcessingLimits.test.js`** — pre-existing regression suite (shipped with `8e3c4b3`) exercising:
  1. Default limits when no client values are supplied.
  2. Honoring a smaller-than-ceiling client-requested value.
  3. Clamping a client value above the ceiling back down to the ceiling.
  4. Rejecting non-numeric / non-positive input.

## Configuration

No new configuration, environment variables, or secrets were introduced. The existing ceilings (`MAX_ALLOWED_PAGES = 1000`, `MAX_ALLOWED_PROPERTIES = 10000`) are hardcoded constants in `functions/utils.js` rather than environment-configurable — if a future requirement needs these tunable per-environment, that would be a separate, deliberate change with its own review, not something to bolt on opportunistically during a QE pass.

## Gotchas & Nuances

- **Stale scanner fingerprints look like new findings.** QE #8206's evidence block was a byte-for-byte match for code that was deleted/replaced six days earlier. If you're triaging a CWE-770 (or any) finding, always diff the evidence text against the *current* file content at the cited location before assuming it's live — a scanner running against a slightly stale snapshot, or re-fingerprinting after a line-number shift, can resurrect an already-fixed bug as a "new" ticket.
- **Line numbers move.** The cited line (260) no longer corresponds to the function named in the evidence (`cloudCalcs`) — it now falls inside `cloudCalcsSync`. Don't trust the line number in isolation; confirm which function actually contains it.
- **`|| defaultValue` is not a throttle.** The original vulnerable pattern (`params.maxPages || 1000`) is a common anti-pattern that looks like it sets a safe default but does nothing to stop a caller from supplying a huge explicit value. The real fix is an explicit ceiling clamp (`Math.min(requested, MAX_ALLOWED)`), which is what `resolveProcessingLimits()` does — worth grepping for the `||`-only pattern elsewhere in the codebase if similar CWE-770 findings appear against other endpoints.
- **Internal config callers are out of scope.** `trigger-scan.js` and `seed-scanconfigs.js` also reference `maxPages`/`maxProperties`-style values, but those are populated from server-side scheduled-scan configuration, not attacker-controlled HTTP request parameters — they were reviewed and confirmed out of scope for this CWE-770 finding rather than silently ignored.
- **No PR was opened.** The standard completion criterion for these QE-repair runs includes a draft PR; that step was skipped here because there was no code diff to open a PR against. If your process requires an audit-trail PR even for declined false positives, that's a process gap to close separately (see the report's "Questions for Review").

## Testing

Run the targeted regression test:

```bash
cd functions
npx jest tests/resolveProcessingLimits.test.js --watchAll=false
```
Expected: 1 suite, 4 tests passing.

Run the full repo smoke command:

```bash
cd functions
npm test -- --watchAll=false --passWithNoTests
```
Expected: 7 suites, 46 tests passing (as of this run).

**Known gaps:** None introduced by this run. The existing `resolveProcessingLimits.test.js` suite is the full regression coverage for this CWE-770 guard; no additional test was needed since no new behavior was added.
