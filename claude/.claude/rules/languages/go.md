---
paths:
  - "**/*.go"
  - "**/go.mod"
---

# Go

> Generic defaults. Pin versions and project-specific rules in the repo's own config.

- Use the standard toolchain (`go build/test ./...`, `go vet`, `gofmt`).
- Errors: return them, wrap with `fmt.Errorf("...: %w", err)`; no panics in library code.
- Accept `context.Context` as the first arg on anything that does I/O; honor cancellation.
- Prefer the stdlib (`net/http`, `log/slog`, `encoding/json`) before reaching for deps.
- Keep interfaces small and defined by the consumer, not the producer.
- Concurrency: don't leak goroutines; every one has a clear exit path (ctx/channel close).

<!-- Per-repo: Go version, module layout, router/lib choices, lint config. -->
