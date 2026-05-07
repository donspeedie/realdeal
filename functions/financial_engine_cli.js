#!/usr/bin/env node
/**
 * Financial Engine CLI — exposes strategyCalculator.js to non-Node callers.
 *
 * Decision basis: Operating Doctrine plan, council Q4 verdict (chairman synthesis 2026-05-07):
 *   "Don't port the 60K-line strategyCalculator.js to Python. Cross-runtime
 *    floating-point divergence will eat weeks. Wrap JS via Node subprocess/CLI;
 *    Python calls via JSON. One runtime, one source of truth, no cross-language sync."
 *
 * This CLI is the wrap. Read a single JSON object from stdin, run calculateStrategy,
 * write the JSON result to stdout. Errors go to stderr with non-zero exit.
 *
 * Usage from Python:
 *   import subprocess, json
 *   result = subprocess.run(
 *       ['node', 'financial_engine_cli.js'],
 *       input=json.dumps({'method': 'flip', 'prop': {...}, 'params': {...},
 *                         'pricePerSqFt': 350, 'twoBedAvg': 1200}),
 *       capture_output=True, text=True, check=True,
 *   )
 *   data = json.loads(result.stdout)
 *
 * Input schema (single JSON object):
 *   {
 *     method:           'flip' | 'rental'
 *     prop:             property dict (see strategyCalculator)
 *     params:           strategy params dict
 *     pricePerSqFt:     number
 *     twoBedAvg:        number
 *     bedroomAnalysis:  array (optional, defaults to [])
 *   }
 *
 * Output schema (single JSON object — whatever calculateStrategy returns).
 */

const { calculateStrategy } = require('./strategyCalculator');

async function main() {
  // Read all of stdin
  let raw = '';
  for await (const chunk of process.stdin) raw += chunk;

  if (!raw.trim()) {
    process.stderr.write(JSON.stringify({ error: 'empty stdin; expected JSON object' }) + '\n');
    process.exit(2);
  }

  let input;
  try {
    input = JSON.parse(raw);
  } catch (e) {
    process.stderr.write(JSON.stringify({ error: `JSON parse failed: ${e.message}` }) + '\n');
    process.exit(2);
  }

  const required = ['method', 'prop', 'params', 'pricePerSqFt', 'twoBedAvg'];
  for (const key of required) {
    if (!(key in input)) {
      process.stderr.write(JSON.stringify({ error: `missing required field: ${key}` }) + '\n');
      process.exit(2);
    }
  }

  try {
    const result = calculateStrategy(
      input.method,
      input.prop,
      input.params,
      input.pricePerSqFt,
      input.twoBedAvg,
      input.bedroomAnalysis || [],
    );
    process.stdout.write(JSON.stringify(result));
    process.exit(0);
  } catch (e) {
    process.stderr.write(
      JSON.stringify({ error: `calculateStrategy raised: ${e.message}`, stack: e.stack }) + '\n',
    );
    process.exit(1);
  }
}

main();
