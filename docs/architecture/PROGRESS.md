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

## Next scheduled work (task pool excerpt)

See [TASK_POOL.md](./TASK_POOL.md).