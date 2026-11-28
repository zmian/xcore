# Address search client

Single source of truth for `AddressSearchClient` (canonical struct client per ADR 0002).

## Public API

| Item | Value |
| --- | --- |
| Type | `struct AddressSearchClient: Sendable` |
| Dependency key | `addressSearch` |
| Variants | `.live`, `.noop`, `.unimplemented` |

Closure fields: `query`, `updateQuery`, `resolve`, `validate`, `observe`.

## Live implementation

`LiveAddressSearchClient` in `AddressSearchClient+Live.swift` is the MapKit/Contacts engine wired by `AddressSearchClient.live`. It is **not** a protocol conformer; it remains public so tests can configure `LiveAddressSearchClient.supportedRegions`.

## Breaking change (P-001, resolved)

The public `protocol AddressSearchClient` and `NoopAddressSearchClient` / `UnimplementedAddressSearchClient` types were removed. Host apps that conformed to the protocol must switch to `AddressSearchClient` struct variants or dependency overrides.

## Enforcement

`audit_dependency_client_shapes.sh` requires zero protocol clients under `Swift/Dependencies`, struct `AddressSearchClient`, and no `: AddressSearchClient` conformances in Sources.

## Related

- [ADR 0002](./adr/0002-dependency-client-template.md)
- [TEST_CI_POLICY.md](./TEST_CI_POLICY.md) — live geocoder tests excluded on CI