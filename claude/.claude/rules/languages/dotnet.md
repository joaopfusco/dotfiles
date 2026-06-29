---
paths:
  - "**/*.cs"
  - "**/*.csproj"
  - "**/*.sln"
---

# C# / .NET

> Generic defaults. Pin versions and project-specific rules in the repo's own config.

- Keep controllers/handlers thin: validate + delegate; no business logic at the edge.
- If the repo uses layered/clean architecture, respect its boundaries — dependencies
  point inward and the domain depends on nothing.
- Use DI (constructor injection); avoid service locators and statics for dependencies.
- `async`/`await` end-to-end for I/O; flow `CancellationToken`; never `.Result`/`.Wait()`.
- Expose DTOs at the API boundary — don't leak persistence entities directly.
- Follow the repo's `.editorconfig` and nullable-reference settings.

<!-- Per-repo: target framework, architecture, validation/mapping libs, test layout. -->
