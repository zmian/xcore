# ADR 0008: Product gates index

## Status

Accepted (PR #153, T-111).

## Context

Some architectural cleanups need product confirmation (breaking API, test default behavior, or user-visible formatting). Scattered notes in `TASK_POOL.md` were easy to miss; agents re-litigated the same gates each round.

## Decision

1. **`PRODUCT_GATES.md`** is the canonical index of pending and recently resolved product gates (P-00x IDs).
2. Each gate links to a **topic SSOT** (`ADDRESS_SEARCH_CLIENT.md`, `DATE_LEGACY_FORMAT.md`, `APP_PHASE_CLIENT.md`, …).
3. **`audit_product_gates.sh`** enforces index ↔ SSOT parity in `make audit-architecture`.
4. Closing a gate requires updating the index, the topic SSOT, and any allowlists (e.g. `audit_dependency_keys.sh` for P-003).

## Consequences

- Agents check `PRODUCT_GATES.md` before large migrations blocked on product input.
- Resolved gates stay listed briefly with SSOT links for migration archaeology (e.g. P-001).