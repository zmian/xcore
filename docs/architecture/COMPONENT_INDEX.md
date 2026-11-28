# Swift/Components domain index

Authoritative map of **domain folders** under `Sources/Xcore/Swift/Components/`.  
Root-level Swift files in the same directory are shared primitives (not counted in **Total**).

**Total: 14** domain folders (`audit_component_index.sh`).

| Folder | Responsibility |
| --- | --- |
| `Analytics` | Provider stack, event traits, registration |
| `AppError` | Typed errors, `AppResult`, user-facing messages |
| `Assets` | `SystemAssetIdentifier` and symbol catalogs |
| `Cache` | In-memory / session-aware caching |
| `Combine` | Publisher helpers and schedulers |
| `Concurrency` | Async sequence utilities |
| `Configuration` | `Appliable` / configuration objects |
| `DataStatus` | Loadable / reloadable UI state models |
| `DatesTimers` | Date, timer, inactivity; includes legacy format (P-002) |
| `Encoding` | Hex, Base64, crypto helpers |
| `FeatureFlag` | Provider composite, flag keys (ADR 0004) |
| `Money` | Currency formatting and SwiftUI styles |
| `Transformer` | Sync/async value transformers |
| `Validation` | `ValidationRule` builders |

## Root primitives (same directory)

Single-file types: `Identifier`, `UserInfoKey`, `StringConverter`, `Version`, `Percentage`, `Observer`, `Weak`, `ReferenceBox`, `Empty`, `Either`, `Count`, `CycledCollection`, `Frequency`, `ElementPosition`, `SelectionType`, `KeyPathRepresentation`, `JSONHelpers`, `URLDescriptor`.

Place new **domain** code in a folder; add a row here before merging substantial features.