# INVARIANTS (RealDeal.ai)

## Scope & Diff

- Apply ONLY the requested change.

- Do not refactor unrelated code, rename files/functions, or reformat outside the edited lines.

- If a change outside scope is required, STOP and output:

  BLOCKED: Requires change in <path>.

## Interfaces & Contracts

- Public exports and parameter/return shapes remain unchanged unless explicitly instructed.

- Keep output keys stable: futureValue, impValue, totalCosts, valuationMethod, etc.

- Preserve override paths and business-rule filters unless task says otherwise.

## Tests & Behavior

- All Jest goldens must pass unchanged unless updated in this task.

- If a golden must change, STOP and say:

  BLOCKED: Golden needs update in tests/<file>.

## Development Tracking

**Claude Logs**: `C:\Users\donsp\.claude\file-history`

Reference these logs to access previous iteration information and maintain context across sessions. This is a temporary workaround until git process is established.