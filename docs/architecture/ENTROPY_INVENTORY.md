# Entropy inventory

Living catalog of parallel implementations, drift, and tracked compiler warnings.  
Pair with `TASK_POOL.md` for execution status.

## Compiler warnings in sources

**Total: 0** `#warning` directives (`make audit-architecture`).

Resolved (Round 47 / T-019):

| Former file | Resolution |
| --- | --- |
| `PushNotificationsClient+Live.swift` | Open notification settings via `@Dependency(\.openURL)` + `URL.notificationSettings` (removed Popup path that segfaulted). |
| `Pond.swift` | Tracked under “Tracked product debt” (Shared migration); no compiler `#warning`. |
| `AddressSearchClient+Live.swift` | Region copy uses existing `Localized` helpers; stringsdict polish remains optional (P-001 scope). |

Resolved (Round 10): removed stale `ProminentButtonStyle` `#warning` (iOS 26 target).

Resolved (Round 13): removed stale Device macOS `#warning`s; `osName` / `family` already return macOS values.

## Multiple implementations (same semantics)

| Semantics | Locations | Canonical | Action |
| --- | --- | --- | --- |
| Unique-by-id registration | `CompositeFeatureFlagProvider`, `CompositeImageFetcher`, `Analytics` | `Collection.uniqued(\.id)` + guard on `add` | Enforced by `audit_composite_registration.sh` (ADR 0004) |
| Event client | `EventsClient<Event>`, `AppPhaseClient` typealias | `EventsClient` | Document pattern (ADR 0004) |
| Address search client | Protocol + Live/Noop/Unimplemented | Protocol (for now) | P-001 |
| Date formatting | Modern `FormatStyle` vs `Date.LegacyFormatStyle` | Modern APIs | P-002 |
| Storage | `Pond` vs future Shared | Pond until migration | See tracked debt below |

## Tracked product debt (no `#warning`)

| Item | Notes |
| --- | --- |
| Pond → Point-Free Shared | Large migration; Pond stays canonical until deliberate replacement. |
| AddressSearch stringsdict | Finer plural localization for region errors; current `Localized` paths are shippable. |

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
| Layer import allowlists | `audit_layer_imports.sh` |
| `nonisolated(unsafe)` count | `audit_concurrency_inventory.sh` |
| Associated-object keys | `audit_associated_object_keys.sh` (ADR 0006) |
| `#warning` count | `audit_compiler_warnings.sh` |
| Layout / spacing | `audit_layout_ssot.sh`, `audit_spacing_scale.sh` |
| Formatting defaults | `audit_formatting_defaults.sh` |
| Coding numeric defaults | `audit_coding_defaults.sh` |
| Composite dedupe | `audit_composite_registration.sh` |