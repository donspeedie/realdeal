#!/usr/bin/env node
// Replaces GMAPS_API_KEY_PLACEHOLDER in the built web index.html with the
// real Google Maps API key from the GMAPS_API_KEY env var.
//
// The key was scrubbed from source (P0 finding 2026-06-10) — app/web/index.html
// ships a placeholder, and this script injects the key into the BUILD ARTIFACT
// after `flutter build web` (never into the tracked source file).
//
// Usage:
//   GMAPS_API_KEY=... node scripts/inject-gmaps-key.mjs [target-html]
//   (default target: app/build/web/index.html)
//
// Behavior:
//   - Env var missing/empty  -> loud warning, exit 0 (build ships with maps
//     disabled rather than hard-failing — matches the empty-default policy
//     on Android/iOS/Dart).
//   - Placeholder not found  -> warning (already injected, or source drifted).
//   - Never prints the key value.

import { readFileSync, writeFileSync, existsSync } from 'node:fs';

const PLACEHOLDER = 'GMAPS_API_KEY_PLACEHOLDER';
const target = process.argv[2] ?? 'app/build/web/index.html';
const key = (process.env.GMAPS_API_KEY ?? '').trim();

if (!existsSync(target)) {
  console.error(`inject-gmaps-key: target not found: ${target} (run \`flutter build web\` first?)`);
  process.exit(1);
}

if (key === '') {
  console.warn(
    'inject-gmaps-key: WARNING — GMAPS_API_KEY env var is empty. ' +
      `Placeholder left in ${target}; Google Maps will NOT load on web.`,
  );
  process.exit(0);
}

// Sanity checks (never echo the key itself).
if (key.includes('"') || key.includes('<') || /\s/.test(key)) {
  console.error('inject-gmaps-key: GMAPS_API_KEY contains invalid characters — refusing to inject.');
  process.exit(1);
}

const html = readFileSync(target, 'utf8');
const occurrences = html.split(PLACEHOLDER).length - 1;

if (occurrences === 0) {
  console.warn(
    `inject-gmaps-key: WARNING — no ${PLACEHOLDER} found in ${target} ` +
      '(already injected, or app/web/index.html drifted). Nothing to do.',
  );
  process.exit(0);
}

writeFileSync(target, html.replaceAll(PLACEHOLDER, key));
console.log(`inject-gmaps-key: injected key into ${target} (${occurrences} occurrence(s)).`);
