---
paths:
  - "**/*.{ts,tsx,js,jsx}"
  - "**/tsconfig.json"
---

# TypeScript / React

> Generic defaults. Pin versions and project-specific rules in the repo's own config.

- Prefer TypeScript strict; avoid `any` — use `unknown` + narrowing, or a real type.
- Match the repo's stack and conventions (build tool, framework, styling); don't mix.
- Function components + hooks. Keep components small; lift state only as needed.
- Respect the rules of hooks; give effects correct dependency arrays (don't silence the lint).
- Follow the repo's styling approach and its ESLint/Prettier config — don't impose your own.

<!-- Per-repo: framework (Vite/Next/...), styling, data fetching, state mgmt, structure. -->
