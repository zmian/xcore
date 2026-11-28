# Architecture Governance — Progress

Worktree: `cursor/architecture-governance-825b` at `/agent/repos/xcore-governance`.

## Objective

Reduce architectural entropy across Xcore; converge toward single sources of truth, canonical implementations, deep modules, enforceable standards, and safe incremental refactors.

## Baseline (Round 0 — discovery)

| Metric | Value |
| --- | --- |
| Swift sources (`Sources/`) | 419 files |
| Package target | Single `Xcore` library (`import Xcore`) |
| Organizational layers | `Swift/`, `SwiftUI/`, `Cocoa/` (folders only, not separate modules) |
| External dependencies | SDWebImage, AnyCodable, KeychainAccess, swift-dependencies |
| CI verification | `make build`, `make test`, `make lint` (macOS + Xcode) |

### Module responsibility map (high level)

| Area | Path | Responsibility |
| --- | --- | --- |
| Domain & cross-cutting Swift | `Sources/Xcore/Swift/` | Analytics, errors, cache, encoding, feature flags, money, validation, transformers |
| Dependency injection clients | `Sources/Xcore/Swift/Dependencies/` | Point-Free `DependencyValues` clients for platform/services |
| UIKit / AppKit | `Sources/Xcore/Cocoa/` | Extensions, HUD, image pipeline, swizzling |
| SwiftUI | `Sources/Xcore/SwiftUI/` | Reusable views, environment, formatting |
| Re-exports & bundle | `Sources/Xcore/Swift/Helpers/Xcore.swift` | `@_exported` AnyCodable, KeychainAccess, Dependencies |

### Entropy hotspots (initial inventory)

| ID | Category | Finding | Status |
| --- | --- | --- | --- |
| E-001 | Canonical implementation | Four `@Dependency` clients lacked `testValue` while siblings define `testValue` + often `previewValue` | **Round 1 — fixed** |
| E-002 | Pattern divergence | `AddressSearchClient` is a protocol; most other clients are closure structs | Pending (documented; migration needs call-site audit) |
| E-003 | Pattern divergence | `AppPhaseClient` uses `testValue: .live` (intentional for lifecycle tests?) | Pending confirmation |
| E-004 | Duplication | Provider/fetcher registration uses shared `uniqued` but separate composite types (Analytics, FeatureFlag, ImageFetcher) | Accepted — composites wrap different protocols |
| E-005 | Enforceable architecture | No automated check for dependency registration consistency | **Round 1 — audit script + CI** |
| E-006 | Date formatting | `Date.LegacyFormatStyle` marked for eventual removal in-source | Pending product decision |

## Rounds

### Round 1 — Dependency client registration standard (2026-11-27)

- **Discover:** `PasteboardClient`, `OpenURLClient`, `ImageColorClient`, `QRCodeClient` missing `testValue`.
- **Migrate:** Added `testValue: .unimplemented` and `previewValue: .noop` where `noop` exists.
- **Enforce:** `BuildTools/Scripts/audit_dependency_keys.sh` + `make audit-architecture` in CI.
- **Verify:** CI `make build` / `make test` (on macOS runner).

### Round 2 — Preview values + client template (2026-11-27)

- **Discover:** `AudioPlayerClient`, `RequestReviewClient`, `AddressSearchClient`, and `Pond` lacked `previewValue` despite `noop`/`empty` variants.
- **Migrate:** Added canonical `previewValue` on those keys; `Pond` uses `.empty` for side-effect-free previews.
- **Document:** ADR 0002 (file template); updated `EventsClient` usage doc; tightened audit for `previewValue` when `noop`/`empty` exists in the client directory.
- **Audit (T-012):** `Analytics.register` variadic overload, `FeatureFlag.register(at:)`, and `ImageFetcher.register` are thin ergonomics over array/composite APIs — deletion test: removing them would push array-literal noise to every caller; **no removal**.
- **Verify:** `make audit-architecture` passes (14 keys).

### Round 3 — Concurrency inventory baseline (2026-11-27)

- **Discover:** 58 `nonisolated(unsafe)` uses across 28 files (globals, associated objects, mocks, UI bridges).
- **Document:** `CONCURRENCY_INVENTORY.md` grouped by intent.
- **Enforce:** `audit_concurrency_inventory.sh` wired into `make audit-architecture`.
- **Verify:** audit passes against documented total.

### Round 4 — Module boundaries + canonical unimplemented diagnostics (2026-11-27)

- **Discover:** `AddressSearchClient+Unimplemented` used `IssueReporting.unimplemented` (and mislabeled `.search`); only parallel implementation in `Swift/Dependencies/`.
- **Migrate:** Standardized on `reportIssue` with `@Dependency(\.addressSearch).*` messages.
- **Enforce:** `audit_module_placement.sh` (DependencyKey placement, client paths, no `IssueReporting` in Dependencies).
- **Document:** ADR 0003; `AGENTS.md` links governance docs (T-014).
- **Verify:** `make audit-architecture` passes.

### Round 5 — Unimplemented diagnostic canon (2026-11-27)

- **Discover:** Mixed `IssueReporting`, `"\(Self.self)...is unimplemented"`, and `@Dependency` raw strings across dependency clients.
- **Migrate:** All `Swift/Dependencies` unimplemented paths now use `reportIssue(#"Unimplemented: ..."#)`.
- **Enforce:** `audit_module_placement.sh` rejects `IssueReporting`, `Self.self` wording, and legacy ` is unimplemented` strings.
- **Verify:** `make audit-architecture` passes.

### Round 7 — Entropy inventory + composite dedupe (2026-11-27)

- **Discover:** `CompositeImageFetcher` inits did not `uniqued(\.id)` unlike `CompositeFeatureFlagProvider`; 6 tracked `#warning` directives.
- **Migrate:** ImageFetcher composite inits dedupe by id (ADR 0004).
- **Document:** `ENTROPY_INVENTORY.md`, ADR 0004 composite registration pattern.
- **Enforce:** `audit_compiler_warnings.sh` for `#warning` count regression.
- **Verify:** `make audit-architecture` passes.

### Round 8 — Unimplemented analytics + metadata SSOT (2026-11-27)

- **Discover:** `UnimplementedAnalyticsProvider` still used `IssueReporting`; metadata/theme globals lacked a single documented owner.
- **Migrate:** Analytics unimplemented methods use `reportIssue`; audit bans `IssueReporting` across `Sources/Xcore`.
- **Document:** ADR 0005 (`UserInfoContainer`, `AppConstants`, `FeatureFlag.provider`); README governance section.
- **Test:** `ImageFetcherCompositeTests` for init deduplication by fetcher id.
- **Verify:** `make audit-architecture` passes; `make test TEST_ONLY=...ImageFetcherCompositeTests` on macOS CI.

### Round 9 — Audit index + composite test coverage (2026-11-27)

- **Document:** `AUDIT_INDEX.md`; ADR 0004 exception for `CompositeImageTransform`.
- **Test:** `FeatureFlagTests.compositeInitDeduplicatesProvidersWithSameId` (registration composite baseline).
- **Verify:** audits local; feature flag + image fetcher composite tests on macOS CI.

### Round 10 — Warning reduction + dependency test defaults (2026-11-27)

- **Delete:** Stale `ProminentButtonStyle` `#warning` (5 warnings remain).
- **Test:** `DependencyKeyDefaultsTests` guards ADR 0001 `testValue` behavior for SessionCounter and OpenURL.
- **Verify:** `make audit-architecture` passes.

### Round 11 — Agent quick start + pasteboard test guard (2026-11-27)

- **Document:** `GOVERNANCE_SUMMARY.md` for one-page agent onboarding.
- **Test:** `pasteboardTestValueDoesNotMutateSystemPasteboard` strengthens ADR 0001.
- **Verify:** audits local; pasteboard test on macOS CI.

### Round 12 — Dependency registry SSOT (2026-11-27)

- **Discover:** No single manifest of production `DependencyValues` keys for agents.
- **Document:** `DEPENDENCY_REGISTRY.md` (14 keys).
- **Enforce:** `audit_dependency_registry.sh`; ADR 0001 rule 0.
- **Verify:** `make audit-architecture` passes (5 audit scripts).

### Round 13 — Device macOS warning cleanup (2026-11-27)

- **Discover:** `Device` / `Device+Model` emitted `#warning` despite implemented macOS fallbacks.
- **Fix:** Remove warnings; `family` returns `"Mac"` on macOS.
- **Verify:** ENTROPY total 5→3; `make audit-architecture` local.

### Round 14 — Theme corner radius SSOT (2026-11-27)

- **Migrate:** `Theme.cornerRadius`; `AppConstants.cornerRadius` forwards (drops one `nonisolated(unsafe)`).
- **Call sites:** Prominent button/text field factories, `View+Border`, previews.
- **Test:** `ThemeLayoutTests`; concurrency inventory 62→61.
- **Verify:** `make audit-architecture` local.

### Round 15 — Layout SSOT enforcement (2026-11-27)

- **Enforce:** `audit_layout_ssot.sh` (Theme `cornerRadius`; no stray `AppConstants.cornerRadius`).
- **Document:** `AUDIT_INDEX`, `ARCHITECTURE_MAP`, ADR 0005.
- **Verify:** `make audit-architecture` (6 scripts).

### Round 16 — Theme spacing forwards (2026-11-27)

- **Migrate:** `defaultSpacing`, `interItemHSpacing` on `Theme`; `CGFloat` forwarders.
- **Document:** `SPACING_SCALE.md`; concurrency 61→59.
- **Verify:** layout audit + tests local.

### Round 17 — Freeze spacing scale (2026-11-27)

- **Migrate:** `CGFloat.s1`…`s8` → `static let` (no in-repo mutators).
- **Enforce:** `audit_spacing_scale.sh`; concurrency 59→51.
- **Verify:** `make audit-architecture` (7 scripts).

### Round 18 — Composite registration audit (2026-11-27)

- **Enforce:** `audit_composite_registration.sh` (ADR 0004 + ImageTransform exception).
- **Verify:** `make audit-architecture` (8 scripts).

### Round 19 — Component index SSOT (2026-11-27)

- **Document:** `COMPONENT_INDEX.md` (14 domain folders).
- **Enforce:** `audit_component_index.sh`; registry audit checks each dependency key name.
- **Verify:** `make audit-architecture` (9 scripts).

### Round 20 — SwiftUI component index (2026-11-27)

- **Document:** `SWIFTUI_COMPONENT_INDEX.md` (21 folders).
- **Enforce:** `audit_swiftui_component_index.sh`; README/AGENTS links.
- **Verify:** `make audit-architecture` (10 scripts).

### Round 21 — Governance catalog + audit meta-check (2026-11-27)

- **Document:** `REGISTRY_CATALOG.md`, `adr/README.md`.
- **Enforce:** `audit_audit_index.sh` (Makefile ↔ `AUDIT_INDEX.md` parity).
- **Verify:** `make audit-architecture` (11 scripts).

### Round 22 — Cocoa component index (2026-11-27)

- **Document:** `COCOA_COMPONENT_INDEX.md` (3 domains: HUD, Swizzle, UIImage).
- **Enforce:** `audit_cocoa_component_index.sh`; `ARCHITECTURE_MAP` link.
- **Verify:** `make audit-architecture` (12 scripts).

### Round 23 — List row insets SSOT (2026-11-27)

- **Migrate:** `Theme.listRowInsets` (derived from `defaultSpacing`); `EdgeInsets.listRow` forwarder.
- **Remove:** `nonisolated(unsafe)` on `EdgeInsets.listRow` (concurrency 51→50).
- **Enforce:** extended `audit_layout_ssot.sh`; `ThemeLayoutTests.listRowInsetsFollowDefaultSpacing`.
- **Verify:** `make audit-architecture`.

### Round 24 — Formatting defaults SSOT (2026-11-27)

- **Document:** `FORMATTING_DEFAULTS.md`.
- **Migrate:** freeze `Character.mask`, fraction digits, random bounds (`static let`).
- **Enforce:** `audit_formatting_defaults.sh`; concurrency 50→45.
- **Verify:** `make audit-architecture` (13 scripts).

### Round 25 — Cocoa SwiftUI import allowlist (2026-11-27)

- **Document:** `LAYER_IMPORTS.md` (4 allowed Cocoa files).
- **Enforce:** `audit_cocoa_swiftui_imports.sh` (ADR 0003).
- **Verify:** `make audit-architecture` (14 scripts).

### Round 26 — Coding numeric encode default SSOT (2026-11-27)

- **Migrate:** `CodingFormatStyleDefaults.defaultEncodeAsString`; Decimal/Double forwarders.
- **Enforce:** `audit_coding_defaults.sh`, `CODING_DEFAULTS.md`; concurrency 45→44.
- **Verify:** `make audit-architecture` (15 scripts).

### Round 27 — Swift/Components UIKit allowlist (2026-11-27)

- **Document:** `LAYER_IMPORTS.md` Swift/Components→UIKit (3 files).
- **Enforce:** merged `audit_layer_imports.sh` (replaces cocoa-only script).
- **Verify:** `make audit-architecture` (15 scripts).

### Round 28 — Helpers index (2026-11-27)

- **Document:** `HELPERS_INDEX.md` (9 `Swift/Helpers` sources).
- **Enforce:** `audit_helpers_index.sh`.
- **Verify:** `make audit-architecture` (16 scripts).

### Round 29 — Governance metrics + registry paths (2026-11-27)

- **Document:** `GOVERNANCE_METRICS.md` headline budgets.
- **Enforce:** `audit_governance_metrics.sh`; dependency registry location dirs exist.
- **Verify:** `make audit-architecture` (17 scripts).

### Round 30 — Doc sync (2026-11-27)

- **Document:** `DEPENDENCY_LAYOUT.md`; fix stale concurrency counts in agent quick start.
- **Verify:** `make audit-architecture` (unchanged).

### Round 31 — Extension + dependency layout audits (2026-11-27)

- **Document:** `EXTENSIONS_INDEX.md` (4 folders, 24 root files).
- **Enforce:** `audit_extensions_index.sh`, `audit_dependency_layout.sh`; metrics + audit count **19**.
- **Verify:** `make audit-architecture` (19 scripts).

### Round 32 — Platform extension indexes (2026-11-27)

- **Document:** `COCOA_EXTENSIONS_INDEX.md`, `SWIFTUI_EXTENSIONS_INDEX.md`.
- **Enforce:** `audit_cocoa_extensions_index.sh`, `audit_swiftui_extensions_index.sh`; audits **21**.
- **Verify:** `make audit-architecture`.

### Round 33 — Cocoa Blocks/Protocols index (2026-11-27)

- **Document:** `COCOA_SUPPORTING_INDEX.md`; refresh `ARCHITECTURE_MAP.md` index links.
- **Enforce:** `audit_cocoa_supporting_index.sh`; audits **22**.
- **Verify:** `make audit-architecture` (22 scripts).
- **CI:** #113 on `c1ad8cc8` failed `ThemeLayoutTests` (missing `import SwiftUI`); fixed before push.

### Round 34 — Swift Protocols index (2026-11-27)

- **Document:** `SWIFT_PROTOCOLS_INDEX.md` (4 files).
- **Enforce:** `audit_swift_protocols_index.sh`; audits **23**; agent quick-start index links.
- **Verify:** `make audit-architecture`. Push after green CI on `855473cb`.
- **CI:** [#114](https://github.com/zmian/xcore/actions/runs/46085331639) hung on live geocoder tests; skip under `TestEnvironment.isCI` for all `LiveAddressSearchClientTests` live cases (T-050).

### Round 35 — Swift PropertyWrappers index (2026-11-27)

- **Document:** `SWIFT_PROPERTY_WRAPPERS_INDEX.md` (6 files).
- **Enforce:** `audit_swift_property_wrappers_index.sh`; audits **24**; map + catalog links.
- **Verify:** `make audit-architecture`. Hold push until CI green on published Round 34 (`7d095f7b`).

### Round 36 — CI test hardening (2026-11-27)

- **Problem:** [#116](https://github.com/zmian/xcore/actions/runs/46096547483) still stalled on **Test** after T-050 (runtime `.disabled` on live geocoder cases).
- **Migrate:** `#if !CI` excludes `LiveAddressSearchClientTests` from CI binaries; skip `AppPhaseOperationTests.operationExecutesAfterDelay` on CI; `parallel-testing-enabled NO` + job/step timeouts in `ci.yml`.
- **Verify:** `make audit-architecture` (local). Await green CI on push.

### Round 37 — CI test policy (2026-11-27)

- **Document:** `TEST_CI_POLICY.md` (compile `#if !CI` + 4 runtime skips).
- **Enforce:** `audit_ci_test_policy.sh`; audits **25**.
- **Verify:** `make audit-architecture`. Commit held until CI **#117** on `50e89757` completes (T-043).

### Round 37 follow-up — stream test hang (2026-11-28)

- **CI:** [#117](https://github.com/zmian/xcore/actions/runs/46104037572) **Test** hit 30m step timeout (not geocoder).
- **Root cause:** `AsyncPassthroughStreamTests.iterations_asyncStream_directly` used two `for await` consumers on a single `AsyncStream` (single-consumer); unstructured `Task` work in stream tests never awaited → runner wait forever.
- **Migrate:** Await collection tasks; single consumer for `AsyncStream`; same pattern in `AsyncCurrentValueStreamTests` / `AsyncValueStreamTests` (T-053).

### Round 38 — CI test throughput (2026-11-28)

- **CI:** [#118](https://github.com/zmian/xcore/actions/runs/46107017127) **Test** hit 30m step timeout after T-053 (serial suite under `-parallel-testing-enabled NO`).
- **Migrate:** Restore default parallel testing on CI; add `-maximum-test-execution-time-allowance 300`; unfiltered `make test` on CI; job/step timeouts 60m / 45m (T-054).

### Round 39 — CI test failures on #119 (2026-11-28)

- **CI:** [#119](https://github.com/zmian/xcore/actions/runs/46110239691) failed in ~10m: `AsyncValueStreamTests.iterations` (300s allowance), `DependencyKeyDefaultsTests` (live deps without `withDependencies`), `DateTest.timeZone` (EST vs EDT).
- **Migrate:** `Task.yield` before stream mutations; scope dependency default tests with `withDependencies` + harness types; align US Eastern offset with `Calendar` (T-055).

### Round 40 — DependencyKeyDefaultsTests on #120 (2026-11-28)

- **CI:** [#120](https://github.com/zmian/xcore/actions/runs/46111947035) failed: `DependencyKeyDefaultsTests` still red — harness overrides used `.unimplemented`, which `reportIssue`s on use; pasteboard case hit 300s allowance.
- **Migrate:** Pin `DependencyValues.test` in `withDependencies` and wrap assertions in `withExpectedIssue` so production `testValue` is exercised without live side effects or spurious failures (T-056).

### Round 41 — pasteboard default test hang on #121 (2026-11-28)

- **CI:** [#121](https://github.com/zmian/xcore/actions/runs/46113442937) — session/openURL defaults passed; `pasteboardTestValueDoesNotMutateSystemPasteboard` hit 300s (likely `UIPasteboard.general` under parallel Swift Testing).
- **Migrate:** `@Suite(.serialized)` on `DependencyKeyDefaultsTests` when UIKit (same pattern as `PasteboardClientTests`) (T-057).

### Round 42 — pasteboard test without `UIPasteboard.general` (#122)

- **CI:** [#122](https://github.com/zmian/xcore/actions/runs/46114522166) — serialization did not fix 300s hang; touching `UIPasteboard.general` on the simulator runner appears unsafe here.
- **Migrate:** Pasteboard default test only asserts production `testValue` via `withExpectedIssue` on `copy` (live pasteboard guard remains in `PasteboardClientTests.noopVariant`) (T-058).

### Round 43 — green tests, audit needs `rg` on CI (#124)

- **CI:** [#124](https://github.com/zmian/xcore/actions/runs/46116163691) — **Test** and **Lint** passed; **Architecture audit** failed (`rg: command not found` in index scripts).
- **Migrate:** `brew install ripgrep` in CI workflow; restore `import Foundation` in defaults test (T-059).

### Round 44 — Bash 3.2 `mapfile` on macOS CI (#125)

- **CI:** [#125](https://github.com/zmian/xcore/actions/runs/46117082088) — tests/lint green; `audit_dependency_keys.sh` failed (`mapfile: command not found` under `/bin/bash` 3.2).
- **Migrate:** Replace `mapfile` with portable `while read` loops in audit scripts (T-060).

### Round 45 — spacing audit on Bash 3.2 (#126)

- **CI:** [#126](https://github.com/zmian/xcore/actions/runs/46118072855) — `audit_spacing_scale.sh` failed (`declare -A` unsupported; `s1: unbound variable`).
- **Migrate:** Parallel arrays in spacing audit; drop unused associative array in formatting audit (T-061).

### Round 46 — green CI #127 (2026-11-28)

- **CI:** [#127](https://github.com/zmian/xcore/actions/runs/46118732024) **success** on `ade46764` (build, test, lint, 25 architecture audits). **T-043 done.**

### Round 47 — zero `#warning` in Sources/Xcore (T-019)

- **Migrate:** Push notifications open settings via `URL.notificationSettings`; drop Pond/AddressSearch `#warning` in favor of ENTROPY “tracked product debt”.
- **Enforce:** `GOVERNANCE_METRICS.md` / `ENTROPY_INVENTORY.md` **Total: 0** `#warning`.

### Round 48 — governance doc sync (post–T-019 / CI hardening)

- **Migrate:** Align `REGISTRY_CATALOG`, `GOVERNANCE_SUMMARY` with zero `#warning`; document macOS audit runner + Swift Testing dependency pattern in `TEST_CI_POLICY.md`, `AUDIT_INDEX.md`, ADR 0001 (T-063).

### Round 49 — registry catalog budget audit (T-064)

- **Enforce:** `audit_registry_catalog.sh` keeps `REGISTRY_CATALOG.md` inventory row in sync with `GOVERNANCE_METRICS.md` and ENTROPY/CONCURRENCY totals (26 audits).

### Round 50 — `CompositeImageFetcher` concurrency (T-065)

- **Migrate:** Replace `nonisolated(unsafe)` fetcher array with `LockIsolated` (+ `@unchecked Sendable`); concurrency budget **43** (T-065).

### Round 51 — `FeatureFlag` provider registry (T-066)

- **Migrate:** Static `CompositeFeatureFlagProvider` behind `LockIsolated`; concurrency budget **42** (T-066).

### Round 52 — `Publisher.done` cancellables (T-067)

- **Migrate:** `LockIsolated<Set<AnyCancellable>>` for one-shot Combine subscribers; concurrency budget **41** (T-067).

### Round 53 — `Device` / `Screen` subscriptions (T-068)

- **Migrate:** Retain orientation/screen Combine tokens in `LockIsolated`; concurrency budget **39** (T-068).

### Round 54 — `LiveAudioClient` player handle (T-069)

- **Migrate:** `AVAudioPlayer` retention via `LockIsolated`; concurrency budget **38** (T-069).

### Round 55 — `AddressSearchResult` completion (T-070)

- **Migrate:** `MKLocalSearchCompletion` via `LockIsolated`; concurrency budget **37** (T-070).

### Round 56 — `MKLocalSearchCompleter` delegate (T-071)

- **Migrate:** Completer in `LiveAddressSearchClient.Delegate` behind `LockIsolated`; concurrency budget **36** (T-071).

### Round 57 — `supportedRegions` configuration (T-072)

- **Migrate:** Region allowlist behind `LockIsolated`; public get/set preserved; concurrency budget **35** (T-072).

### Round 58 — `ValidationRule.regex` capture (T-073)

- **Migrate:** Typed `Regex` held in `LockIsolated` for `@Sendable` validate closure; concurrency budget **34** (T-073).

### Round 59 — `Cache` NSCache storage (T-074)

- **Migrate:** All cache operations through `LockIsolated<NSCache>`; concurrency budget **32** (T-074).

### Round 60–61 — coding default + popup transition (T-075, T-076)

- **Migrate:** `CodingFormatStyleDefaults` + `Popup.Style` drop `nonisolated(unsafe)`; update `audit_coding_defaults.sh`; concurrency budget **30**.

### Round 62 — global UI/format defaults (T-077)

- **Migrate:** Theme, Calendar, Locale, Color RGB defaults → `LockIsolated`; concurrency budget **25** (T-077).

### Round 63 — typography + timing presets (T-078)

- **Migrate:** App typeface, content-size override, CAMediaTimingFunction presets; concurrency budget **18** (T-078).

### Round 64 — zero `nonisolated(unsafe)` in Sources/Xcore (T-079)

- **Migrate:** Associated-object keys → `UInt8` tokens; `MockAnalyticsProvider` → `LockIsolated` state; concurrency budget **0** (T-079).

### Round 65 — ADR 0006 + associated-key audit (T-080)

- **Enforce:** `audit_associated_object_keys.sh`; **27** architecture audits; ADR 0006 documents LockIsolated + UInt8 key pattern.

### Round 66 — entropy + concurrency doc sync (T-081)

- **Docs:** `ENTROPY_INVENTORY.md` composite dedupe marked enforced; associated-key tooling listed; `CONCURRENCY_INVENTORY.md` ADR 0006 enforcement note.

### Round 67 — `@unchecked Sendable` inventory (T-082)

- **Enforce:** `UNCHECKED_SENDABLE_INVENTORY.md`, ADR 0007, `audit_unchecked_sendable_inventory.sh` (**28** audits); registry/metrics sync for 20 annotations.

### Round 68 — peel `@unchecked Sendable` (T-083)

- **Migrate:** `ImageDownloaderCancelToken` (`@Sendable` cancel), `CompositeImageFetcher` + `MockAnalyticsProvider` → `Sendable` (`LockIsolated`). Budget **16**.

### Round 69 — timing presets + session cache (T-084)

- **Migrate:** `CAMediaTimingFunction` preset SSOT without wrapper class; `SessionAwareCache` → `Sendable`. Budget **14**.

### Round 70 — analytics hub Sendable (T-085)

- **Migrate:** `Analytics` identity + provider list in `LockIsolated`. Budget **13**.

### Round 71 — session counter live backend (T-086)

- **Migrate:** `LiveSessionCounterClient` → `Sendable` with `LockIsolated` task. Budget **12**.

### Round 72 — Money appearance Sendable (T-087)

- **Migrate:** `Money.Appearance` styling behind `LockIsolated`. Budget **11**.

### Round 73 — Popup transition storage (T-088)

- **Migrate:** `Popup.TransitionStorage` → `Sendable` (reverted on CI; budget stays **11**).

### Round 73b — Push live client isolation (T-089)

- **Migrate:** `LivePushNotificationsClient` mutable state → `LockIsolated` (NSObject delegate; `@unchecked` retained).

### Round 74 — macOS CI strict concurrency (T-090)

- **Fix:** `AssociatedObjectKey` (`static let`) replaces mutable `UInt8` keys (ADR 0006).
- **Fix:** Drop invalid `Sendable` on `Analytics`, `SessionAwareCache`, `LiveSessionCounterClient`; mock computed accessors; revert `CAMediaTimingFunction` static storage.

### Round 74b — CI follow-up (T-091)

- **Fix:** `AssociatedObjectKey` drops `Sendable` (immutable token; `UnsafeRawPointer` not Sendable).
- **Revert:** `Popup.TransitionStorage` `@unchecked Sendable`.

### Round 75 — CI associated keys + SDWebImage cancel (T-092)

- **Fix:** `AssociatedObjectKey` → `@unchecked Sendable`; `ImageDownloader` cancel via `LockIsolated`. Budget **12**.

### Round 76 — MapKit/Regex strict concurrency (T-093)

- **Fix:** `ValidationRule` regex via `LockIsolated.withValue`; Address Search `@unchecked` + query accessor. Budget **14**.

### Round 77 — Audio + session counter live clients (T-094)

- **Fix:** `LiveAudioClient` / `LiveSessionCounterClient` `@unchecked Sendable`; AVAudioPlayer via `withValue`. Budget **16**.

### Round 77b — AssociatedObjectKey pointer (T-095)

- **Fix:** `UnsafeRawPointer(storage)` assignment (Swift 6 type check).

### Round 78 — Cache/Combine session caches (T-096)

- **Fix:** `Cache` / `SessionAwareCache` `@unchecked`; NSCache via `withValue`; `done(_:)` cancel store. Budget **20**.

### Round 78b — LiveAudioClient lock (T-097)

- **Fix:** `NSLock` storage for `AVAudioPlayer` (avoid `@Sendable` `LockIsolated` capture).

### Round 79 — Cache direct NSCache (T-098)

- **Fix:** Drop `LockIsolated` around `NSCache` (thread-safe; non-`Sendable` values).

### Round 81 — ThemeLayoutTests isolation (T-101)

- **Fix:** `spacingScaleMatchesDocumentation` resets `Theme` defaults (parallel test pollution).
- **Verify:** macOS CI **green** on `1e1f7443` (build-test-lint).

### Round 82 — Theme test isolation audit (T-102)

- **Enforce:** `audit_theme_test_isolation.sh` + `TEST_CI_POLICY.md` global Theme SSOT section (**29** audits).

### Round 80 — Regex/MapKit LockIsolated capture (T-099)

- **Fix:** `ValidationRule` regex `Box`; `AddressSearchResult` `NSLock` storage. Budget **21**.

## Next scheduled work (task pool excerpt)

See [TASK_POOL.md](./TASK_POOL.md).