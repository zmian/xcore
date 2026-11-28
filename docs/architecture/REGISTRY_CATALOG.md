# Governance catalog (agent SSOT)

Single entry point for architecture artifacts on [PR #153](https://github.com/zmian/xcore/pull/153).

## Registries (counts enforced in CI)

| Doc | What |
| --- | --- |
| [DEPENDENCY_REGISTRY.md](./DEPENDENCY_REGISTRY.md) | 14 production `@Dependency` keys |
| [DEPENDENCY_LAYOUT.md](./DEPENDENCY_LAYOUT.md) | Folder layout for dependency clients |
| [EXTENSIONS_INDEX.md](./EXTENSIONS_INDEX.md) | Swift/Extensions folders and root files |
| [COCOA_EXTENSIONS_INDEX.md](./COCOA_EXTENSIONS_INDEX.md) | Cocoa/Extensions layout |
| [COCOA_SUPPORTING_INDEX.md](./COCOA_SUPPORTING_INDEX.md) | Cocoa/Blocks and Protocols |
| [SWIFTUI_EXTENSIONS_INDEX.md](./SWIFTUI_EXTENSIONS_INDEX.md) | SwiftUI/Extensions layout |
| [HELPERS_INDEX.md](./HELPERS_INDEX.md) | 9 `Swift/Helpers` files |
| [SWIFT_PROTOCOLS_INDEX.md](./SWIFT_PROTOCOLS_INDEX.md) | 4 `Swift/Protocols` files |
| [SWIFT_PROPERTY_WRAPPERS_INDEX.md](./SWIFT_PROPERTY_WRAPPERS_INDEX.md) | 6 `Swift/PropertyWrappers` files |
| [COMPONENT_INDEX.md](./COMPONENT_INDEX.md) | 14 `Swift/Components` domains |
| [SWIFTUI_COMPONENT_INDEX.md](./SWIFTUI_COMPONENT_INDEX.md) | 21 `SwiftUI/Components` domains |
| [COCOA_COMPONENT_INDEX.md](./COCOA_COMPONENT_INDEX.md) | 3 `Cocoa/Components` domains |
| [SPACING_SCALE.md](./SPACING_SCALE.md) | Theme layout + frozen `s1`…`s8` |
| [FORMATTING_DEFAULTS.md](./FORMATTING_DEFAULTS.md) | Mask, fraction digits, random bounds |
| [CODING_DEFAULTS.md](./CODING_DEFAULTS.md) | JSON numeric encode-as-string default |
| [TEST_CI_POLICY.md](./TEST_CI_POLICY.md) | CI-safe test guards (compile + runtime skips) |

## Inventories (budgets enforced in CI)

| Doc | Budget |
| --- | --- |
| [ENTROPY_INVENTORY.md](./ENTROPY_INVENTORY.md) | 0 `#warning`s in `Sources/Xcore` |
| [CONCURRENCY_INVENTORY.md](./CONCURRENCY_INVENTORY.md) | 0 `nonisolated(unsafe)` |
| [UNCHECKED_SENDABLE_INVENTORY.md](./UNCHECKED_SENDABLE_INVENTORY.md) | 12 `@unchecked Sendable` |

## Process

| Doc | Use |
| --- | --- |
| [GOVERNANCE_SUMMARY.md](./GOVERNANCE_SUMMARY.md) | Quick start |
| [GOVERNANCE_METRICS.md](./GOVERNANCE_METRICS.md) | Headline budgets (enforced) |
| [TASK_POOL.md](./TASK_POOL.md) | Ready / pending / done tasks |
| [PROGRESS.md](./PROGRESS.md) | Round log |
| [ARCHITECTURE_MAP.md](./ARCHITECTURE_MAP.md) | Layers and boundaries |
| [LAYER_IMPORTS.md](./LAYER_IMPORTS.md) | Cocoa→SwiftUI (4), Swift/Components→UIKit (3) |
| [AUDIT_INDEX.md](./AUDIT_INDEX.md) | All `make audit-architecture` scripts |
| [adr/README.md](./adr/README.md) | Accepted decisions |

## Commands

```bash
make audit-architecture   # Linux-safe, 28 checks (includes audit index parity)
make build && make test    # macOS / Xcode
```