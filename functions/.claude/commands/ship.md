# Ship Command

Runs the complete CI/CD pipeline: test → review → deploy

## Usage

```
/ship
```

## What it does

1. **Run Tests**: Executes `npm test` to ensure all tests pass
2. **Code Review**: Runs `scripts/ask --review` to check for:
   - Interface violations
   - Golden output drift
   - Security/performance issues
   - Behavior changes
3. **Deploy**: If tests and review pass, deploys to Firebase with `firebase deploy --only functions`

## Guardrails

- Blocks deployment if tests fail
- Warns on review violations (but doesn't block by default)
- Requires explicit approval before deploying

## Notes

- Review may hit Claude API rate limits during peak usage
- Full pipeline takes 3-5 minutes
- Deployment affects production immediately
