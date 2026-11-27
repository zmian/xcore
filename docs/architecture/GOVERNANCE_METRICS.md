# Governance metrics (enforced snapshot)

Headline budgets agents should not regress without updating source inventories and this file.  
`audit_governance_metrics.sh` compares documented values to live counts and `make audit-architecture` script total.

| Metric | Value |
| --- | --- |
| Architecture audit scripts | 17 |
| Production dependency keys | 14 |
| nonisolated(unsafe) in Sources/Xcore | 44 |
| #warning in Sources/Xcore | 3 |
| Swift/Components domains | 14 |
| SwiftUI/Components domains | 21 |
| Cocoa/Components domains | 3 |
| Swift/Helpers files | 9 |
| Cocoa→SwiftUI allowlist | 4 |
| Swift/Components→UIKit allowlist | 3 |

Sources: `AUDIT_INDEX.md`, `DEPENDENCY_REGISTRY.md`, `CONCURRENCY_INVENTORY.md`, `ENTROPY_INVENTORY.md`, component indexes, `LAYER_IMPORTS.md`.