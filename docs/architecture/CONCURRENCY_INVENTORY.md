# Concurrency inventory (`nonisolated(unsafe)`)

Snapshot for reducing concurrency entropy. **Total: 0 annotations** (regenerate with `make audit-architecture`).

## Global / configurable state (high locality impact)

| Location | Role |
| --- | --- |
| `Constants.swift` | Spacing, layout, and formatting defaults (frozen `static let`) |

**Intent:** Single source of truth for app-wide defaults; changes here affect many call sites by design. Mutable globals use `LockIsolated` (see resolved rounds below).

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

**Resolved (Round 62):** Global defaults (`Theme.default`, `Calendar.default` / `defaultCodable`, `Locale.numbers`, `Color.RGBColorSpace.default`) use `LockIsolated` storage.

**Resolved (Round 63):** `UIFont.defaultAppTypeface` and `Font.preferredContentSizeCategory` use `LockIsolated`; `CAMediaTimingFunction` presets were a `@unchecked Sendable` cache (Round 69 → frozen `static let`).

**Resolved (Round 64):** Associated-object keys use `UInt8` token `static var` (stable `inout` address without `nonisolated(unsafe)`); `MockAnalyticsProvider` state behind `LockIsolated`.

**Enforcement (Round 65):** ADR 0006 documents the zero-`unsafe` budget, `LockIsolated` globals, and `UInt8` associated keys; `audit_associated_object_keys.sh` blocks regressions.

Regressions: `BuildTools/Scripts/audit_concurrency_inventory.sh` compares live count to the total in this file's first paragraph.