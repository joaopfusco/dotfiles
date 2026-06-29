---
paths:
  - "**/*_test.go"
  - "**/test_*.py"
  - "**/*_test.py"
  - "**/*.{test,spec}.*"
  - "**/*Test.cs"
  - "**/*Tests.cs"
  - "**/{test,tests,__tests__}/**"
---

# Testing (universal)

## Philosophy

- Test behavior and contracts, not implementation details.
- A test should fail for exactly one reason; name it after what it asserts.
- Cover the happy path, the edges (empty/zero/nil, boundaries), and the failure modes.
- Don't chase a coverage number — cover what would actually break.

## Structure

- Arrange–Act–Assert (given/when/then). One logical assertion per test.
- Table-driven / parametrized tests for many similar cases.
- Tests are independent and order-free; no shared mutable state between them.
- Use the language's idiomatic layout (e.g. `_test.go` beside source, `tests/` for
  Python, `*.test.ts` beside source, a dedicated test project for .NET).

## Doubles

- Prefer real implementations; fake only at true boundaries (network, clock, fs, DB).
- Don't mock what you don't own — wrap it and mock the wrapper.
- Use spun-up infra (Docker Compose / testcontainers) over mocks when integration
  behavior is what's under test.

## Discipline

- A bug fix comes with a test that fails before the fix and passes after.
- Don't weaken an assertion to make a test pass — fix the code or the expectation.
- Keep tests fast; isolate slow/integration tests so the default run stays quick.
