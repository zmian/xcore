# Entropy inventory

Living catalog of parallel implementations, drift, and tracked compiler warnings.  
Pair with `TASK_POOL.md` for execution status.

## Compiler warnings in sources

**Total: 6** `#warning` directives (`make audit-architecture`).

| File | Note |
| --- | --- |
| `PushNotificationsClient+Live.swift` | Settings URL segfault when enabled |
| `Pond.swift` | Future migration to Point-Free Shared |
| `AddressSearchClient+Live.swift` | Localization via stringsdict |
| `ButtonStyle+Prominent.swift` | iOS 16 control size APIs |
| `Device.swift` / `Device+Model.swift` | Unimplemented device paths |

## Multiple implementations (same semantics)

| Semantics | Locations | Canonical | Action |
| --- | --- | --- | --- |
| Unique-by-id registration | `CompositeFeatureFlagProvider`, `CompositeImageFetcher`, `Analytics` | `Collection.uniqued(\.id)` + guard on `add` | Align ImageFetcher inits (Round 7) |
| Event client | `EventsClient<Event>`, `AppPhaseClient` typealias | `EventsClient` | Document pattern (ADR 0004) |
| Address search client | Protocol + Live/Noop/Unimplemented | Protocol (for now) | P-001 |
| Date formatting | Modern `FormatStyle` vs `Date.LegacyFormatStyle` | Modern APIs | P-002 |
| Storage | `Pond` vs future Shared | Pond until migration | Pond `#warning` |

## Dependency client shapes

| Shape | Count | Examples |
| --- | --- | --- |
| Struct + closures | Majority | `OpenURLClient`, `QRCodeClient` |
| Protocol + conformers | 1 | `AddressSearchClient` |
| Typealias over `EventsClient` | 1 | `AppPhaseClient` |

## Enforcement coverage

| Concern | Tool |
| --- | --- |
| Dependency keys | `audit_dependency_keys.sh` |
| Module placement / unimplemented copy | `audit_module_placement.sh` |
| `nonisolated(unsafe)` count | `audit_concurrency_inventory.sh` |
| `#warning` count | `audit_compiler_warnings.sh` |