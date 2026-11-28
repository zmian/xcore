# Governance metrics (enforced snapshot)

Headline budgets agents should not regress without updating source inventories and this file.  
`audit_governance_metrics.sh` compares documented values to live counts and `make audit-architecture` script total.

| Metric | Value |
| --- | --- |
| Architecture audit scripts | 32 |
| Runtime CI test skips (`TestEnvironment.isCI`) | 4 |
| Production dependency keys | 14 |
| nonisolated(unsafe) in Sources/Xcore | 0 |
| @unchecked Sendable in Sources/Xcore | 17 |
| #warning in Sources/Xcore | 0 |
| Swift/Components domains | 14 |
| SwiftUI/Components domains | 21 |
| Cocoa/Components domains | 3 |
| Cocoa/Extensions folders | 1 |
| Cocoa/Extensions root files | 23 |
| Cocoa/Blocks files | 4 |
| Cocoa/Protocols files | 1 |
| SwiftUI/Extensions folders | 2 |
| SwiftUI/Extensions root files | 35 |
| Swift/Helpers files | 9 |
| Swift/Protocols files | 4 |
| Swift/PropertyWrappers files | 6 |
| Swift/Extensions domains | 4 |
| Swift/Extensions root files | 24 |
| Swift/Dependencies subfolders | 9 |
| Cocoa→SwiftUI allowlist | 4 |
| Swift/Components→UIKit allowlist | 3 |

Sources: `AUDIT_INDEX.md`, `DEPENDENCY_REGISTRY.md`, `CONCURRENCY_INVENTORY.md`, `UNCHECKED_SENDABLE_INVENTORY.md`, `ENTROPY_INVENTORY.md`, component indexes, `LAYER_IMPORTS.md`.