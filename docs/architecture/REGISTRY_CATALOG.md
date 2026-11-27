# Governance catalog (agent SSOT)

Single entry point for architecture artifacts on [PR #153](https://github.com/zmian/xcore/pull/153).

## Registries (counts enforced in CI)

| Doc | What |
| --- | --- |
| [DEPENDENCY_REGISTRY.md](./DEPENDENCY_REGISTRY.md) | 14 production `@Dependency` keys |
| [COMPONENT_INDEX.md](./COMPONENT_INDEX.md) | 14 `Swift/Components` domains |
| [SWIFTUI_COMPONENT_INDEX.md](./SWIFTUI_COMPONENT_INDEX.md) | 21 `SwiftUI/Components` domains |
| [COCOA_COMPONENT_INDEX.md](./COCOA_COMPONENT_INDEX.md) | 3 `Cocoa/Components` domains |
| [SPACING_SCALE.md](./SPACING_SCALE.md) | Theme layout + frozen `s1`…`s8` |
| [FORMATTING_DEFAULTS.md](./FORMATTING_DEFAULTS.md) | Mask, fraction digits, random bounds |

## Inventories (budgets enforced in CI)

| Doc | Budget |
| --- | --- |
| [ENTROPY_INVENTORY.md](./ENTROPY_INVENTORY.md) | 3 `#warning`s in `Sources/Xcore` |
| [CONCURRENCY_INVENTORY.md](./CONCURRENCY_INVENTORY.md) | 51 `nonisolated(unsafe)` |

## Process

| Doc | Use |
| --- | --- |
| [GOVERNANCE_SUMMARY.md](./GOVERNANCE_SUMMARY.md) | Quick start |
| [TASK_POOL.md](./TASK_POOL.md) | Ready / pending / done tasks |
| [PROGRESS.md](./PROGRESS.md) | Round log |
| [ARCHITECTURE_MAP.md](./ARCHITECTURE_MAP.md) | Layers and boundaries |
| [LAYER_IMPORTS.md](./LAYER_IMPORTS.md) | Cocoa → SwiftUI allowlist (4) |
| [AUDIT_INDEX.md](./AUDIT_INDEX.md) | All `make audit-architecture` scripts |
| [adr/README.md](./adr/README.md) | Accepted decisions |

## Commands

```bash
make audit-architecture   # Linux-safe, 14 checks (includes audit index parity)
make build && make test    # macOS / Xcode
```