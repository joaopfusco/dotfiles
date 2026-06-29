---
paths:
  - "**/*.rs"
  - "**/Cargo.toml"
---

# Rust

> Generic defaults. Pin versions and project-specific rules in the repo's own config.

- Use the project's toolchain (`cargo build/test`, `rustfmt`, `clippy`); keep clippy clean.
- Prefer `Result` + `?` over `unwrap()`/`expect()`/`panic!` outside truly unrecoverable init.
- Model invariants in the type system; make illegal states unrepresentable.
- Borrow over clone; reach for `Rc`/`Arc`/`Mutex` deliberately, not by reflex.
- Keep `unsafe` minimal, isolated, and documented with its safety invariants.
- For embedded / `no_std` targets, mind heap/stack limits and build through the
  project's toolchain — don't assume a host `cargo build`. Treat vendored/generated
  trees (e.g. `.embuild/`) as read-only.

<!-- Per-repo: edition, target (host vs embedded), key crates, HAL/runtime conventions. -->
