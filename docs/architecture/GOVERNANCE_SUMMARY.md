# Xcore architecture governance (agent quick start)

**Branch / PR:** ongoing on `cursor/architecture-governance-825b` ([#153](https://github.com/zmian/xcore/pull/153)).

## Before you edit

1. Read [ADR 0002](./adr/0002-dependency-client-template.md) when adding `@Dependency` clients.
2. Run `make audit-architecture` (**28** Linux-safe checks; see `AUDIT_INDEX.md`) before push.
3. Headline budgets: [GOVERNANCE_METRICS.md](./GOVERNANCE_METRICS.md).
4. Catalog of registries and inventories: [REGISTRY_CATALOG.md](./REGISTRY_CATALOG.md).
5. Update [TASK_POOL.md](./TASK_POOL.md) for pending product decisions; do not block on them.

## Single source of truth

Production dependency keys: [DEPENDENCY_REGISTRY.md](./DEPENDENCY_REGISTRY.md) (14 keys).  
Domain components: [COMPONENT_INDEX.md](./COMPONENT_INDEX.md) (14 Swift), [SWIFTUI_COMPONENT_INDEX.md](./SWIFTUI_COMPONENT_INDEX.md) (21 SwiftUI), [COCOA_COMPONENT_INDEX.md](./COCOA_COMPONENT_INDEX.md) (3 Cocoa).  
Extensions: [EXTENSIONS_INDEX.md](./EXTENSIONS_INDEX.md) (4 folders, 24 root files); [COCOA_EXTENSIONS_INDEX.md](./COCOA_EXTENSIONS_INDEX.md); [SWIFTUI_EXTENSIONS_INDEX.md](./SWIFTUI_EXTENSIONS_INDEX.md); [COCOA_SUPPORTING_INDEX.md](./COCOA_SUPPORTING_INDEX.md); [SWIFT_PROTOCOLS_INDEX.md](./SWIFT_PROTOCOLS_INDEX.md); [SWIFT_PROPERTY_WRAPPERS_INDEX.md](./SWIFT_PROPERTY_WRAPPERS_INDEX.md). CI tests: [TEST_CI_POLICY.md](./TEST_CI_POLICY.md).

## Rules enforced in CI

| Rule | ADR |
| --- | --- |
| Dependency keys: `live` + `test` + `preview` when `noop` exists | 0001, 0002 |
| Keys live under `Swift/Dependencies/` (except `Pond`) | 0003 |
| `reportIssue` for unimplemented; no `IssueReporting` | 0003 |
| Registration composites dedupe by `id` | 0004 + `audit_composite_registration.sh` |
| Metadata: `UserInfoContainer`, `Theme` layout, `FeatureFlag.provider` | 0005 |
| `Theme.cornerRadius` canonical; `AppConstants.cornerRadius` forwarder only | 0005 + `audit_layout_ssot.sh` |
| Layer import allowlists | 0003 + `audit_layer_imports.sh` |
| Headline metrics match inventories | `audit_governance_metrics.sh` |
| Zero `nonisolated(unsafe)`; UInt8 associated keys | 0006 + `audit_concurrency_inventory.sh`, `audit_associated_object_keys.sh` |
| `@unchecked Sendable` inventory parity | 0007 + `audit_unchecked_sendable_inventory.sh` |

## Inventories

- [GOVERNANCE_METRICS.md](./GOVERNANCE_METRICS.md) — enforced snapshot of all headline budgets
- [ENTROPY_INVENTORY.md](./ENTROPY_INVENTORY.md) — parallel implementations, `#warning` budget (0)
- [CONCURRENCY_INVENTORY.md](./CONCURRENCY_INVENTORY.md) — `nonisolated(unsafe)` budget (0)
- [UNCHECKED_SENDABLE_INVENTORY.md](./UNCHECKED_SENDABLE_INVENTORY.md) — `@unchecked Sendable` budget (20)
- [SPACING_SCALE.md](./SPACING_SCALE.md) · [FORMATTING_DEFAULTS.md](./FORMATTING_DEFAULTS.md) · [CODING_DEFAULTS.md](./CODING_DEFAULTS.md)
- [HELPERS_INDEX.md](./HELPERS_INDEX.md) · [LAYER_IMPORTS.md](./LAYER_IMPORTS.md)
- [PROGRESS.md](./PROGRESS.md) — completed rounds

## macOS verification

`make build` · `make test` · `make lint` (Xcode required)