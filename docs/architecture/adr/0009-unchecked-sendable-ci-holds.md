# ADR 0009: `@unchecked Sendable` macOS CI holds

## Status

Accepted (PR #153).

## Context

ADR 0007 allows removing `@unchecked` when types can be made properly `Sendable` or bridged via `LockIsolated`. On GitHub Actions `build-test-lint`, several reduction attempts **failed** while local Linux `make audit-architecture` still passed. Re-applying them wastes CI cycles and destabilizes parallel agent work.

## Decision

1. **Evidence SSOT:** `UNCHECKED_SENDABLE_CI_EVIDENCE.md` records each failed pattern (E-001–E-006) with task IDs and failing type messages.
2. **Enforcement:** `audit_unchecked_sendable_ci_holds.sh` asserts canonical code shapes for E-003–E-006 (holders and `@unchecked` sites referenced in the evidence doc).
3. **Agent rule:** Do not delete `RegexValidationPattern`, `DoneSubscriberCancellables`, or downgrade listed `@unchecked` sites without a **new** lever documented in a follow-up ADR amendment or new evidence row (after green macOS CI proof).

## Consequences

- Part of `make audit-architecture` (33 scripts).
- `UNCHECKED_SENDABLE_ROADMAP.md` links CI holds; reduction queue defers to evidence for listed sites.
- Preference order in ADR 0007 still applies; this ADR documents **proven** exceptions to naive application of (a)–(c).