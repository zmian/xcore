# Concurrency inventory (`nonisolated(unsafe)`)

Snapshot for reducing concurrency entropy. **Total: 39 annotations** (regenerate with `make audit-architecture`).

## Global / configurable state (high locality impact)

| Location | Role |
| --- | --- |
| `Constants.swift` | Spacing, layout, and formatting defaults |
| `Calendar+Extensions.swift` | Default calendar codable/current |
| `Locale+Extensions.swift` | Default locale for numbers |
| `Theme+Default.swift` | Default SwiftUI theme |
| `UIFont+App.swift` | Default app typeface |
| `CodingFormatStyle+Defaults.swift` | JSON encode-as-string default (`Decimal`/`Double` forward) |
| `AddressSearchClient+Live.swift` | `supportedRegions` configuration |

**Intent:** Single source of truth for app-wide defaults; changes here affect many call sites by design. Future work: narrow public mutation surface or move to injected configuration.

## Associated object keys (UIKit pattern)

| Location |
| --- |
| `ExtensibleByAssociatedObject.swift` (documented pattern) |
| `UINavigationBar+Extensions`, `UIImage+Fetcher`, `Timer+Extensions`, `ProcessInfo+Extensions`, gesture/mail blocks |

**Intent:** Stable key strings for associated objects; low business semantics.

## Test / mock doubles

| Location |
| --- |
| `AnalyticsProvider+Mock.swift` |

**Intent:** Test-only mutation without actor isolation; acceptable in mock types.

## Media / UI runtime handles

| Location |
| --- |
| `Cache.swift`, `AudioPlayerClient+Live`, `AddressSearchClient+Live`, `AddressSearchResult` |

**Intent:** Bridge non-Sendable UIKit/AVFoundation/MapKit types. Candidates for actor-isolated facades if warnings increase.

**Resolved (Round 50):** `CompositeImageFetcher` uses `LockIsolated` for fetcher list (was `nonisolated(unsafe)`).

**Resolved (Round 51):** `FeatureFlag` global provider registry uses `LockIsolated` (was `nonisolated(unsafe)`).

**Resolved (Round 52):** `Publisher/done(_:)` retains one-shot subscribers via `LockIsolated` (dropped redundant `NSRecursiveLock` + `nonisolated(unsafe)` set).

**Resolved (Round 53):** `Device` and `Screen` singleton subscriptions use `LockIsolated<AnyCancellable?>` (was instance `nonisolated(unsafe)`).

## Animation / presentation

| Location |
| --- |
| `CoreAnimation+Extensions.swift`, `Popup.swift` |

## Validation

| Location |
| --- |
| `ValidationRule+Rules.swift` |

Regressions: `BuildTools/Scripts/audit_concurrency_inventory.sh` compares live count to the total in this file's first paragraph.