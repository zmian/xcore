# Architecture optimization task pool

Tasks are independent unless marked **blocked by**. Status: `ready` | `in-progress` | `pending-confirmation` | `done`.

## Ready

| ID | Task | Rationale |
| --- | --- | --- |
| T-019 | Resolve tracked `#warning` items (see ENTROPY_INVENTORY) | Deletion / modernization |
| T-043 | Confirm green macOS CI after Round 36 CI hardening | CI stability on #153 |

## Pending confirmation

| ID | Task | Question |
| --- | --- | --- |
| P-001 | Converge `AddressSearchClient` from protocol to struct client | Breaking for conformers outside repo? |
| P-002 | Remove `Date.LegacyFormatStyle` per in-file note | Any apps still depend on legacy phrasing? |
| P-003 | `AppPhaseClient` testValue uses `.live` | Keep for integration tests or switch to `.unimplemented`? |

## Done

| ID | Task |
| --- | --- |
| T-001 | Governance docs + worktree setup |
| T-002 | Normalize `testValue` / `previewValue` on four dependency clients |
| T-003 | `audit_dependency_keys.sh` + CI wiring |
| T-010 | `previewValue` on AudioPlayer, RequestReview, AddressSearch, Pond |
| T-011 | ADR 0002 dependency client template |
| T-012 | Composite registration API deletion test (no removals) |
| T-015 | `CONCURRENCY_INVENTORY.md` + count audit script |
| T-013 | `audit_module_placement.sh` + ADR 0003 |
| T-014 | `AGENTS.md` architecture governance section |
| T-017 | Canonical `Unimplemented:` messages in all `Swift/Dependencies` clients |
| T-018 | Pond unimplemented messages + audit scope |
| T-020 | ENTROPY_INVENTORY + ADR 0004 composite registration; ImageFetcher init dedupe |
| T-021 | UnimplementedAnalyticsProvider + repo-wide IssueReporting ban |
| T-022 | ADR 0005 metadata/theme SSOT; ImageFetcherCompositeTests; README |
| T-023 | AUDIT_INDEX + FeatureFlag composite dedupe test + ADR 0004 exception |
| T-024 | Remove ProminentButtonStyle `#warning`; DependencyKeyDefaultsTests |
| T-025 | GOVERNANCE_SUMMARY + pasteboard dependency default test |
| T-026 | DEPENDENCY_REGISTRY + audit script |
| T-027 | Theme `cornerRadius` SSOT; `AppConstants` forwarder; library call sites |
| T-028 | `audit_layout_ssot.sh` + CI wiring |
| T-029 | Theme `defaultSpacing` / `interItemHSpacing`; SPACING_SCALE.md |
| T-030 | Freeze `s1`…`s8` + `audit_spacing_scale.sh` |
| T-031 | `audit_composite_registration.sh` (ADR 0004) |
| T-032 | `COMPONENT_INDEX.md` + `audit_component_index.sh`; registry key names |
| T-033 | `SWIFTUI_COMPONENT_INDEX.md` + audit |
| T-034 | `REGISTRY_CATALOG.md`, `adr/README.md`, `audit_audit_index.sh` |
| T-035 | `COCOA_COMPONENT_INDEX.md` + audit |
| T-036 | `Theme.listRowInsets` + `EdgeInsets.listRow` forwarder; concurrency −1 |
| T-037 | `FORMATTING_DEFAULTS.md` + freeze mask/fraction/random; concurrency −5 |
| T-038 | `LAYER_IMPORTS.md` + `audit_cocoa_swiftui_imports.sh` |
| T-039 | `CodingFormatStyleDefaults` SSOT + `audit_coding_defaults.sh` |
| T-040 | Swift/Components UIKit allowlist + unified `audit_layer_imports.sh` |
| T-041 | `HELPERS_INDEX.md` + audit |
| T-042 | `GOVERNANCE_METRICS.md` + `audit_governance_metrics.sh`; registry path check |
| T-044 | `DEPENDENCY_LAYOUT.md` + `GOVERNANCE_SUMMARY` sync |
| T-045 | `EXTENSIONS_INDEX.md` + `audit_dependency_layout.sh`; audits **19** |
| T-046 | Cocoa + SwiftUI extension indexes; audits **21** |
| T-047 | `COCOA_SUPPORTING_INDEX` + `ARCHITECTURE_MAP` sync; audits **22** |
| T-048 | `SWIFT_PROTOCOLS_INDEX` + audit; audits **23** |
| T-049 | `SWIFT_PROPERTY_WRAPPERS_INDEX` + audit; audits **24** (local; unpushed with Round 34) |
| T-050 | Skip live `LiveAddressSearchClientTests` on CI (`4f4a493f`) |
| T-051 | CI test hardening: `#if !CI` live address tests, phase timing skips, job timeouts |