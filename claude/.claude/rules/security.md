# Security (universal)

## Secrets

- Never hardcode secrets. Read from env / a secrets manager; commit a `.env.example`
  with placeholder values only.
- Don't log secrets, tokens, or full PII. Redact before logging.
- If a secret is exposed, rotate it — removing it from the diff is not enough.

## Input & output

- Treat all external input as hostile: validate type, range, length, and format.
- Parameterized queries / ORM bindings only — never build SQL by string concat.
- Encode output for its sink (HTML escape, shell quoting) to prevent injection/XSS.
- Validate redirect targets and file paths against allowlists; reject traversal.

## Auth

- Authentication ≠ authorization — check both, and check authz on every request
  for the specific resource, not just "is logged in".
- Hash passwords with a slow KDF (argon2/bcrypt/scrypt); never reversible encryption.
- Scope tokens, set expiries, and prefer short-lived + refresh over long-lived tokens.

## Dependencies & transport

- Pin/lock dependencies; review before adding. Prefer maintained, minimal libs.
- TLS everywhere; verify certificates — never disable verification to "make it work".
- Keep error responses generic to clients; keep the detail in server-side logs.

## Defaults

- Least privilege for DB users, service accounts, container capabilities, tokens.
- Deny by default; allow explicitly.
