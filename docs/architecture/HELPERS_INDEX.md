# Swift/Helpers index

Flat **cross-cutting primitives** under `Sources/Xcore/Swift/Helpers/` (not domain logic — see `COMPONENT_INDEX.md`).

**Total: 9** files (`audit_helpers_index.sh`).

| File | Role |
| --- | --- |
| `Xcore.swift` | Module entry: `@_exported` AnyCodable, KeychainAccess, Dependencies |
| `Constants.swift` | AppConstants, spacing scale, layout forwards to Theme |
| `AppInfo.swift` | Bundle / version helpers for host apps |
| `Functions.swift` | Small shared top-level utilities |
| `Memoize.swift` | Memoization helper |
| `Meta.swift` | Reflection / metadata utilities |
| `Mirror+OpenExistential.swift` | Mirror ergonomics |
| `FatalReason.swift` | Debuggable precondition messages |
| `Samples.swift` | Preview / sample data helpers |

Prefer `Swift/Components/` for new domain code; only add helpers used across layers.