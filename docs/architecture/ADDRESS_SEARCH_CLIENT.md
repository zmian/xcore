# Address search client (P-001)

Single source of truth for `AddressSearchClient` shape drift and migration to the canonical struct client (ADR 0002).

## Current shape

| Item | Value |
| --- | --- |
| Public API | `protocol AddressSearchClient: Sendable` |
| Dependency key | `addressSearch` → `AddressSearchClient` |
| Variants | `.live`, `.noop`, `.unimplemented` via constrained extensions |

## In-repo conformers only

No conformers exist outside `Sources/Xcore/Swift/Dependencies/AddressSearch/`. Custom app conformers are possible via the public protocol (pending product confirmation — **P-001**).

| Type | File | Role |
| --- | --- | --- |
| `LiveAddressSearchClient` | `AddressSearchClient+Live.swift` | MapKit + Contacts live implementation |
| `NoopAddressSearchClient` | `AddressSearchClient+Noop.swift` | Previews / side-effect-free tests |
| `UnimplementedAddressSearchClient` | `AddressSearchClient+Unimplemented.swift` | Default `testValue`; `reportIssue` diagnostics |

## Target shape (when P-001 is accepted)

Replace the protocol with a closure `struct AddressSearchClient: Sendable` matching `AudioPlayerClient` / `OpenURLClient`:

- `query`, `updateQuery`, `resolve`, `validate`, `observe` as `@Sendable` closure fields.
- `.live` wires `LiveAddressSearchClient` (or inlined live implementation) without a public conformance type.
- Delete `NoopAddressSearchClient` / `UnimplementedAddressSearchClient` types; use static `.noop` / `.unimplemented` on the struct.
- Update `ENTROPY_INVENTORY` protocol count **1 → 0** and `audit_dependency_client_shapes.sh`.

## Enforcement

`audit_dependency_client_shapes.sh` verifies the three conformers above and rejects new `: AddressSearchClient` conformances in `Sources/Xcore`.

## Related

- [ADR 0002](./adr/0002-dependency-client-template.md) — struct client template
- [TASK_POOL.md](./TASK_POOL.md) — **P-001**
- [TEST_CI_POLICY.md](./TEST_CI_POLICY.md) — live geocoder tests excluded on CI