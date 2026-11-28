# Architecture optimization task pool

Tasks are independent unless marked **blocked by**. Status: `ready` | `in-progress` | `pending-confirmation` | `done`.

## Ready

Concurrency inventory is at **0** `nonisolated(unsafe)` (ADR 0006). Independent code work is gated by **P-001–P-003** unless expanding audits/docs or module-boundary refactors.

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
| T-052 | `TEST_CI_POLICY.md` + `audit_ci_test_policy.sh` |
| T-053 | Concurrency stream tests: await collection tasks; single `AsyncStream` consumer (`1f0bfccc`) |
| T-054 | CI throughput: parallel tests, per-test allowance, longer timeouts (`452c928d`) |
| T-055 | Stream yield, `DateTests` DST, first dependency-defaults attempt (`0c9552b7`) |
| T-056 | Dependency defaults: `.test` + `withExpectedIssue` (`a1a53212`) |
| T-057 | Serialize dependency defaults suite (`1833af47`) |
| T-058 | Pasteboard default test without `UIPasteboard` (`722a220e`) |
| T-059 | CI `ripgrep` + Foundation import (`773403ff`) |
| T-060 | Audit scripts without `mapfile` (`c8512d80`) |
| T-061 | Bash 3.2-safe spacing/formatting audits (`ade46764`) |
| T-043 | Green macOS CI on #153 ([#127](https://github.com/zmian/xcore/actions/runs/46118732024) `ade46764`) |
| T-019 | Clear all tracked `#warning` in Sources/Xcore |
| T-062 | Audit scripts tolerate zero `#warning` (`rg` exit 1) |
| T-063 | Doc sync: catalogs + TEST_CI_POLICY + ADR 0001 testing notes |
| T-064 | `audit_registry_catalog.sh` + 26-audit CI gate |
| T-065 | `CompositeImageFetcher` → `LockIsolated` (concurrency 44→43) |
| T-066 | `FeatureFlag` provider registry → `LockIsolated` (concurrency 43→42) |
| T-067 | `Publisher.done` subscriber set → `LockIsolated` (concurrency 42→41) |
| T-068 | `Device` / `Screen` Combine tokens → `LockIsolated` (concurrency 41→39) |
| T-069 | `LiveAudioClient` → `LockIsolated<AVAudioPlayer?>` (concurrency 39→38) |
| T-070 | `AddressSearchResult` → `LockIsolated` MapKit completion (concurrency 38→37) |
| T-071 | `LiveAddressSearchClient.Delegate` completer → `LockIsolated` (concurrency 37→36) |
| T-072 | `supportedRegions` → `LockIsolated` static (concurrency 36→35) |
| T-073 | `ValidationRule.regex(Regex)` → `LockIsolated` capture (concurrency 35→34) |
| T-074 | `Cache` NSCache → `LockIsolated` (concurrency 34→32) |
| T-075 | `CodingFormatStyleDefaults` → `LockIsolated` + audit (concurrency 32→31) |
| T-076 | `Popup.Style` transition box (concurrency 31→30) |
| T-077 | Global Theme/Calendar/Locale/Color defaults → `LockIsolated` (30→25) |
| T-078 | UIFont/Font defaults + timing presets (25→18) |
| T-079 | Associated keys + MockAnalyticsProvider (18→0) |
| T-080 | ADR 0006 + `audit_associated_object_keys.sh` (27 audits) |
| T-081 | ENTROPY + CONCURRENCY inventory doc sync |
| T-082 | `UNCHECKED_SENDABLE_INVENTORY` + ADR 0007 + audit (28 audits, budget 20) |
| T-083 | Drop `@unchecked` on composite fetcher, mock analytics, cancel token (20→16) |
| T-084 | Timing presets + `SessionAwareCache` Sendable (16→14) |
| T-085 | `Analytics` → `LockIsolated` hub (14→13) |
| T-086 | `LiveSessionCounterClient` Sendable (13→12) |
| T-087 | `Money.Appearance` LockIsolated (12→11) |
| T-088 | `Popup.TransitionStorage` Sendable (11→10; push gated on CI) |
| T-089 | `LivePushNotificationsClient` LockIsolated (hygiene; NSObject) |
| T-090 | `AssociatedObjectKey` + CI Sendable fixes (macOS #153) |
| T-091 | Popup revert + `AssociatedObjectKey` without `Sendable` |
| T-092 | `AssociatedObjectKey` @unchecked + ImageDownloader LockIsolated |