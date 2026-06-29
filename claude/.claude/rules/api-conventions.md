---
paths:
  - "**/{api,apis,handlers,controllers,routes,endpoints,resources}/**"
  - "**/*.proto"
  - "**/openapi*.{yml,yaml,json}"
  - "**/swagger*.{yml,yaml,json}"
---

# API conventions (universal, HTTP/REST)

## Resources & verbs

- Nouns for resources, plural: `/users`, `/orders/{id}/items`.
- Verbs come from HTTP: `GET` (read, safe), `POST` (create), `PUT`/`PATCH`
  (replace/partial update), `DELETE` (remove). No verbs in paths.
- `GET` and `DELETE` carry no body; mutations validate before any side effect.

## Status codes

- `200` ok, `201` created (+ `Location`), `204` no content.
- `400` validation, `401` unauthenticated, `403` unauthorized, `404` not found,
  `409` conflict, `422` semantic validation, `429` rate-limited.
- `5xx` only for genuine server faults — never to signal client mistakes.

## Payloads

- JSON, consistent casing across the API (pick `camelCase` or `snake_case`, keep it).
- Errors share one shape: a machine code, a human message, optional field details.
  Never return stack traces or raw DB errors to clients.
- Timestamps are UTC ISO-8601; money is integer minor units or decimal strings,
  never floats.

## Behavior

- Validate and authenticate at the edge; assume all input is hostile.
- Paginate list endpoints by default; never return unbounded collections.
- Make writes idempotent where feasible; document idempotency keys when used.
- Version when breaking (`/v1`); add fields backward-compatibly, don't repurpose them.
- Document with OpenAPI; the spec and the implementation must not drift.
