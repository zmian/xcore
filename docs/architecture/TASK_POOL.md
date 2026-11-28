# Architecture optimization task pool

Tasks are independent unless marked **blocked by**. Status: `ready` | `in-progress` | `pending-confirmation` | `done`.

## Ready

Concurrency inventory is at **0** `nonisolated(unsafe)` (ADR 0006). Independent code work is gated by **P-002–P-003** unless expanding audits/docs, `@unchecked` reduction, or module-boundary refactors.

## Pending confirmation

| ID | Task | Question |
| --- | --- | --- |
| P-001 | Converge `AddressSearchClient` to struct client | **Done** (T-107). |
| P-002 | Remove `Date.LegacyFormatStyle` per in-file note | Any apps still depend on legacy phrasing? See [DATE_LEGACY_FORMAT.md](./DATE_LEGACY_FORMAT.md). |
| P-003 | `AppPhaseClient` testValue uses `.live` | Keep for integration tests or switch to `.unimplemented`? See [APP_PHASE_CLIENT.md](./APP_PHASE_CLIENT.md). |

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
| T-093 | AddressSearch + ValidationRule Regex CI fixes |
| T-094 | AudioPlayer + SessionCounter live Sendable CI |
| T-095 | AssociatedObjectKey pointer cast |
| T-096 | Cache, SessionAwareCache, Publisher.done CI |
| T-097 | `LiveAudioClient` `NSLock` for `AVAudioPlayer` (LockIsolated capture) |
| T-098 | `Cache` direct thread-safe `NSCache` |
| T-099 | Regex `Box` + `AddressSearchResult` `NSLock` |
| T-100 | File-scoped `RegexValidationPattern` |
| T-101 | `ThemeLayoutTests` spacing scale reset (parallel CI) |
| T-102 | `audit_theme_test_isolation.sh` + TEST_CI_POLICY (**29** audits) |
| T-103 | Green macOS CI on #153 (`1e1f7443`, build-test-lint) |
| T-104 | `DEPENDENCY_REGISTRY` AppPhase exception + `audit_dependency_keys` guard (P-003) |
| T-105 | `audit_dependency_client_shapes.sh` + ENTROPY enforcement (**30** audits) |
| T-106 | `ADDRESS_SEARCH_CLIENT.md` + conformer allowlist in shape audit |
| T-107 | P-001: `AddressSearchClient` protocol → struct; delete noop/unimplemented types |
| T-108 | Example `AddressFormReducer` closure call labels after P-001 |
| T-109 | `DATE_LEGACY_FORMAT.md` + `audit_date_legacy_format.sh` (**31** audits) |
| T-110 | `APP_PHASE_CLIENT.md` + dependency key audit cross-check (P-003) |
| T-111 | `PRODUCT_GATES.md` + `audit_product_gates.sh` (**32** audits) |
| T-112 | ADR 0008 product gates + ENTROPY enforcement row |
| T-113 | `AddressSearchResult` → `Sendable` struct (22→21 `@unchecked`) |
| T-114 | `UNCHECKED_SENDABLE_ROADMAP` + inventory audit parity |
| T-115 | `UserDefaultsPond` plain `Sendable` attempt (reverted; CI) |
| T-116 | Delete `RegexValidationPattern` attempt (reverted T-121; CI `Regex` not `Sendable`) |
| T-117 | `Publisher.done` `LockIsolated` attempt (reverted T-122; CI `AnyCancellable`) |
| T-118 | `AssociatedObjectKey` plain `Sendable` attempt (reverted; CI `UnsafeRawPointer`) |
| T-119 | `ValuePublisher` plain `Sendable` attempt (reverted; CI `CurrentValueSubject`) |
| T-120 | Revert T-118/T-119; budget **19** (`976fa8cd`) |
| T-121 | Revert T-116; restore `RegexValidationPattern`; budget **20** |
| T-122 | Revert T-117; restore `DoneSubscriberCancellables`; budget **21** |
| T-123 | `UNCHECKED_SENDABLE_CI_EVIDENCE` + `audit_unchecked_sendable_ci_holds.sh` (**33** audits) |
| T-124 | Green macOS CI on #153 (`48043ae1`, build-test-lint after T-122/T-123) |
| T-125 | ADR 0009 unchecked Sendable CI holds |
| T-126 | `AGENTS.md` + `REGISTRY_CATALOG` sync (33 audits, CI evidence) |
| T-127 | Registry audit CI evidence row + `GOVERNANCE_SUMMARY` sync |
| T-128 | `listRowInsetsFollowDefaultSpacing` Theme reset + audit (parallel CI) |
| T-129 | Theme audit script Bash 3.2 (`head -n -1` fix) |
| T-130 | Green macOS CI on #153 (`f025d663`, build-test-lint + 33 audits) |
| T-131 | `defaultSpacingForwardsToDefaultTheme` Theme reset + audit |
| T-132 | Ban `head -n -` in audit scripts via `audit_ci_test_policy.sh` |
| T-133 | Green macOS CI on #153 (`a77cbce1`) |
| T-134 | Green macOS CI on #153 (`d070fa20`, T-132 fix) |
| T-135 | Theme parallel-reset helper + audit SSOT |
| T-136 | Green macOS CI on #153 (`7dd0d122`, T-135) |
| T-137 | Theme test reset via `s5`/`s3`; audit ↔ `SPACING_SCALE.md` |
| T-138 | Green macOS CI on #153 (`d467cc82`, T-137) |
| T-139 | `Theme.init` default spacing via `s5`/`s3` + layout audit |
| T-140 | Green macOS CI on #153 (`e7062737`, T-139) |
| T-141 | ADR 0005 docs: Theme init + parallel test spacing SSOT |
| T-142 | GOVERNANCE_SUMMARY / ARCHITECTURE_MAP spacing audit sync |
| T-143 | Spacing scale audit theme-default parity + AUDIT_INDEX |
| T-144 | Green macOS CI on #153 (`4d5c42b2`, T-142–T-143) |
| T-145 | `AGENTS.md` layout spacing SSOT pointer |
| T-146 | Registry audit guards AGENTS + layout audit triple |
| T-147 | `audit_ci_test_policy` guards Theme parallel reset docs |
| T-148 | Green macOS CI on #153 (`b3ced217`, T-146–T-147) |
| T-149 | Governance SSOT cites `audit_ci_test_policy` for Theme reset |
| T-150 | `CGFloat.s3`/`s5` docs link Theme defaults + `SPACING_SCALE` |
| T-151 | Green macOS CI on #153 (`ae2eb580`, T-149–T-150) |
| T-152 | Theme spacing property docs + spacing audit guards |
| T-153 | `ThemeLayoutTests` `.serialized` + audit (parallel race) |
| T-154 | `audit_ci_test_policy` Theme serialized cross-check |
| T-155 | Serialized test suite catalog + CI policy audit |
| T-156 | Governance metrics sync with `TEST_CI_POLICY` CI budgets |
| T-157 | Registry catalog + architecture map CI test SSOT |
| T-158 | `AGENTS.md` + ADR 0005 CI test policy pointers |
| T-159 | `#if !CI` compile-excluded suite budget in metrics audits |
| T-160 | ENTROPY/registry catalog CI budget cross-links |