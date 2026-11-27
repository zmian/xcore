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

## Next scheduled work (task pool excerpt)

See [TASK_POOL.md](./TASK_POOL.md).