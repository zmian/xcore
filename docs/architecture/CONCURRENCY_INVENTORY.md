# Concurrency inventory (`nonisolated(unsafe)`)

Snapshot for reducing concurrency entropy. **Total: 62 annotations** (regenerate with `make audit-architecture`).

## Global / configurable state (high locality impact)

| Location | Role |
| --- | --- |
| `FeatureFlag+Providers.swift` | Static composite provider registry |
| `Constants.swift` | Spacing, layout, and formatting defaults |
| `Calendar+Extensions.swift` | Default calendar codable/current |
| `Locale+Extensions.swift` | Default locale for numbers |
| `Theme+Default.swift` | Default SwiftUI theme |
| `UIFont+App.swift` | Default app typeface |
| `CodingFormatStyle+Decimal/Double` | JSON encode-as-string toggles |
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
| `ImageFetcher+Composite`, `Cache.swift`, `AudioPlayerClient+Live`, `AddressSearchClient+Live`, `AddressSearchResult`, `Device.swift`, `Screen.swift`, `Publisher+Extensions` |

**Intent:** Bridge non-Sendable UIKit/AVFoundation/MapKit types. Candidates for actor-isolated facades if warnings increase.

## Animation / presentation

| Location |
| --- |
| `CoreAnimation+Extensions.swift`, `Popup.swift` |

## Validation

| Location |
| --- |
| `ValidationRule+Rules.swift` |

Regressions: `BuildTools/Scripts/audit_concurrency_inventory.sh` compares live count to the total in this file's first paragraph.