# Concurrency inventory (`nonisolated(unsafe)`)

Snapshot for reducing concurrency entropy. **Total: 30 annotations** (regenerate with `make audit-architecture`).

## Global / configurable state (high locality impact)

| Location | Role |
| --- | --- |
| `Constants.swift` | Spacing, layout, and formatting defaults |
| `Calendar+Extensions.swift` | Default calendar codable/current |
| `Locale+Extensions.swift` | Default locale for numbers |
| `Theme+Default.swift` | Default SwiftUI theme |
| `UIFont+App.swift` | Default app typeface |

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

**Resolved (Round 50):** `CompositeImageFetcher` uses `LockIsolated` for fetcher list (was `nonisolated(unsafe)`).

**Resolved (Round 51):** `FeatureFlag` global provider registry uses `LockIsolated` (was `nonisolated(unsafe)`).

**Resolved (Round 52):** `Publisher/done(_:)` retains one-shot subscribers via `LockIsolated` (dropped redundant `NSRecursiveLock` + `nonisolated(unsafe)` set).

**Resolved (Round 53):** `Device` and `Screen` singleton subscriptions use `LockIsolated<AnyCancellable?>` (was instance `nonisolated(unsafe)`).

**Resolved (Round 54):** `LiveAudioClient` retains `AVAudioPlayer` in `LockIsolated` (was `nonisolated(unsafe)`).

**Resolved (Round 55):** `AddressSearchResult` stores `MKLocalSearchCompletion` in `LockIsolated` (was `nonisolated(unsafe)`).

**Resolved (Round 56):** `LiveAddressSearchClient.Delegate` holds `MKLocalSearchCompleter` in `LockIsolated` (was `nonisolated(unsafe)`).

**Resolved (Round 57):** `LiveAddressSearchClient.supportedRegions` uses `LockIsolated` storage (was `nonisolated(unsafe)` static).

**Resolved (Round 58):** `ValidationRule.regex(Regex)` captures pattern in `LockIsolated` (was `nonisolated(unsafe)` local).

**Resolved (Round 59):** `Cache` `NSCache` storage behind `LockIsolated` (was `nonisolated(unsafe)`).

**Resolved (Round 60):** `CodingFormatStyleDefaults.defaultEncodeAsString` uses `LockIsolated`; coding audit enforces SSOT without `nonisolated(unsafe)`.

**Resolved (Round 61):** `Popup.Style` stores `AnyTransition` in `@unchecked Sendable` box (was `nonisolated(unsafe)` stored property).

## Animation / presentation

| Location |
| --- |
| `CoreAnimation+Extensions.swift` |

Regressions: `BuildTools/Scripts/audit_concurrency_inventory.sh` compares live count to the total in this file's first paragraph.