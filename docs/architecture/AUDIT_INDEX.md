# Architecture audit index

Run from repo root: **`make audit-architecture`** (no Xcode). Wired in `.github/workflows/ci.yml`.

**macOS CI:** requires Homebrew `ripgrep`; scripts target **Bash 3.2** (no `mapfile`, no associative arrays). Linux agents may use newer Bash — keep scripts portable.

| Script | Enforces |
| --- | --- |
| `BuildTools/Scripts/audit_cocoa_component_index.sh` | `COCOA_COMPONENT_INDEX.md` matches `Cocoa/Components/` domain folders. |
| `BuildTools/Scripts/audit_cocoa_extensions_index.sh` | `COCOA_EXTENSIONS_INDEX.md` matches `Cocoa/Extensions/` layout. |
| `BuildTools/Scripts/audit_cocoa_supporting_index.sh` | `COCOA_SUPPORTING_INDEX.md` matches `Cocoa/Blocks/` and `Cocoa/Protocols/`. |
| `BuildTools/Scripts/audit_helpers_index.sh` | `HELPERS_INDEX.md` matches `Swift/Helpers/*.swift` count. |
| `BuildTools/Scripts/audit_swift_protocols_index.sh` | `SWIFT_PROTOCOLS_INDEX.md` matches `Swift/Protocols/` file count. |
| `BuildTools/Scripts/audit_swift_property_wrappers_index.sh` | `SWIFT_PROPERTY_WRAPPERS_INDEX.md` matches `Swift/PropertyWrappers/` file count. |
| `BuildTools/Scripts/audit_ci_test_policy.sh` | `TEST_CI_POLICY.md` matches CI test guards; Theme reset + serialized suite catalog. |
| `BuildTools/Scripts/audit_theme_test_isolation.sh` | `resetThemeSpacingSSOTForParallelTesting()` (`.s5`/`.s3`) + call sites (`TEST_CI_POLICY.md`). |
| `BuildTools/Scripts/audit_extensions_index.sh` | `EXTENSIONS_INDEX.md` matches `Swift/Extensions/` folders and root file count. |
| `BuildTools/Scripts/audit_component_index.sh` | `COMPONENT_INDEX.md` total matches `Swift/Components/` domain folders. |
| `BuildTools/Scripts/audit_swiftui_component_index.sh` | `SWIFTUI_COMPONENT_INDEX.md` matches `SwiftUI/Components/` folders. |
| `BuildTools/Scripts/audit_swiftui_extensions_index.sh` | `SWIFTUI_EXTENSIONS_INDEX.md` matches `SwiftUI/Extensions/` layout. |
| `BuildTools/Scripts/audit_dependency_registry.sh` | `DEPENDENCY_REGISTRY.md` total + each key has `DependencyValues` property. |
| `BuildTools/Scripts/audit_dependency_layout.sh` | `DEPENDENCY_LAYOUT.md` matches `Swift/Dependencies/` subfolders and root clients. |
| `BuildTools/Scripts/audit_dependency_keys.sh` | Every `DependencyKey` has `testValue`; `previewValue` when `noop`/`empty` exists (see ADR 0001–0002). |
| `BuildTools/Scripts/audit_dependency_client_shapes.sh` | `ENTROPY_INVENTORY` client shapes: zero protocol clients; struct `AddressSearchClient`; one `EventsClient` typealias (`AppPhaseClient`). |
| `BuildTools/Scripts/audit_concurrency_inventory.sh` | `nonisolated(unsafe)` count matches `CONCURRENCY_INVENTORY.md`. |
| `BuildTools/Scripts/audit_unchecked_sendable_inventory.sh` | `@unchecked Sendable` count matches `UNCHECKED_SENDABLE_INVENTORY.md` (ADR 0007). |
| `BuildTools/Scripts/audit_unchecked_sendable_ci_holds.sh` | CI-proven holders for `RegexValidationPattern`, `DoneSubscriberCancellables`, etc. (`UNCHECKED_SENDABLE_CI_EVIDENCE.md`). |
| `BuildTools/Scripts/audit_associated_object_keys.sh` | No `nonisolated(unsafe)`; `AssociatedKey` uses `UInt8` tokens (ADR 0006). |
| `BuildTools/Scripts/audit_module_placement.sh` | `DependencyKey` under `Swift/Dependencies/` (Pond excepted); no `IssueReporting`; canonical `Unimplemented:` strings (ADR 0003). |
| `BuildTools/Scripts/audit_layer_imports.sh` | Cross-layer imports match `LAYER_IMPORTS.md` (Cocoa→SwiftUI, Swift/Components→UIKit; ADR 0003). |
| `BuildTools/Scripts/audit_compiler_warnings.sh` | `#warning` count matches `ENTROPY_INVENTORY.md`. |
| `BuildTools/Scripts/audit_layout_ssot.sh` | Layout on `Theme`; `AppConstants.cornerRadius` forwarder only; `Theme.init` spacing uses `.s5`/`.s3` (ADR 0005). |
| `BuildTools/Scripts/audit_spacing_scale.sh` | Frozen `CGFloat.s1`…`s8`; `s3`/`s5` parity with theme-owned defaults in `SPACING_SCALE.md`. |
| `BuildTools/Scripts/audit_formatting_defaults.sh` | Frozen masking/fraction/random defaults match `FORMATTING_DEFAULTS.md`. |
| `BuildTools/Scripts/audit_date_legacy_format.sh` | `DATE_LEGACY_FORMAT.md` — single `.legacy` call site until P-002. |
| `BuildTools/Scripts/audit_coding_defaults.sh` | Single `CodingFormatStyleDefaults.defaultEncodeAsString` (see `CODING_DEFAULTS.md`). |
| `BuildTools/Scripts/audit_composite_registration.sh` | Provider/fetcher composites dedupe by `id` (ADR 0004; ImageTransform exempt). |
| `BuildTools/Scripts/audit_registry_catalog.sh` | `REGISTRY_CATALOG.md` inventory budgets match `GOVERNANCE_METRICS.md` and entropy/concurrency inventories. |
| `BuildTools/Scripts/audit_governance_metrics.sh` | `GOVERNANCE_METRICS.md` matches live inventory totals + `TEST_CI_POLICY.md` CI test budgets. |
| `BuildTools/Scripts/audit_product_gates.sh` | `PRODUCT_GATES.md` matches P-001–P-003 SSOT docs. |
| `BuildTools/Scripts/audit_audit_index.sh` | `AUDIT_INDEX.md` matches `Makefile` `audit-architecture` script list. |

Related docs: `PROGRESS.md`, `TASK_POOL.md`, `ARCHITECTURE_MAP.md`, `adr/*`.

Behavioral regression: macOS `make build` / `make test` (includes composite registration tests).