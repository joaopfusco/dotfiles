---
paths:
  - "**/*.py"
  - "**/pyproject.toml"
---

# Python

> Generic defaults. Pin versions and project-specific rules in the repo's own config.

- `pyproject.toml` is the source of truth for deps and tooling when present.
- Type-hint public functions; keep it clean under the repo's type checker.
- Follow the repo's formatter/linter (e.g. ruff/black) — don't impose one it lacks.
- Prefer `pathlib`, dataclasses / typed models, and explicit over clever.
- Use the project's virtualenv / dev shell — don't install packages globally.
- Raise specific exceptions; never bare `except:`. Use context managers for resources.

<!-- Per-repo: Python version, web framework, async conventions, package manager. -->
