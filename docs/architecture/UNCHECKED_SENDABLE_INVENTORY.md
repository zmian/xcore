# `@unchecked Sendable` inventory

Living snapshot of deliberate Sendable erasure in `Sources/Xcore`. **Total: 16 annotations** (regenerate with `make audit-architecture`).

Agents: prefer `LockIsolated`, frozen `static let`, or `ReferenceBox` before adding new `@unchecked Sendable`. Never combine with `nonisolated(unsafe)` (ADR 0006).

## Canonical primitives (conditional conformance)

| Location | Role |
| --- | --- |
| `ExtensibleByAssociatedObject.swift` | `AssociatedObjectKey` (stable `UnsafeRawPointer` token) |
| `ReferenceBox.swift` | `ReferenceBox` / `MutableReferenceBox` when `Value: Sendable` |
| `Weak.swift` | `Weak` when `Value: Sendable` |
| `ValuePublisher.swift` | `ValuePublisher` when `Output: Sendable` |

## Dependency clients (live + handlers)

| Location | Role |
| --- | --- |
| `AddressSearchClient+Live.swift` | `Delegate` (`NSObject` + `MKLocalSearchCompleter`) |
| `AddressSearchResult.swift` | `MKLocalSearchCompletion` in `LockIsolated` |
| `AudioPlayerClient+Live.swift` | `LiveAudioClient` (`AVAudioPlayer` in `LockIsolated`) |
| `SessionCounterClient+Live.swift` | `LiveSessionCounterClient` (`@Dependency` + observation task) |
| `PushNotificationsClient+Live.swift` | `NSObject` live client |
| `PushNotificationsClient.swift` | `NotificationReceivedHandler` (non-Sendable closure storage) |
| `AppPhaseClient.swift` | `AppPhase` enum payloads |

## Components (shared mutable or UIKit bridges)

| Location | Role |
| --- | --- |
| `Popup.swift` | `TransitionStorage` (`AnyTransition`) |
| `CodingFormatStyle+Formatter.swift` | `FormatterCodingFormatStyle` bridges `Formatter` |
| `PondKey.swift` / `Pond+UserDefaults.swift` | Pond storage variants |

**Resolved (Round 68):** `ImageDownloaderCancelToken` uses `@Sendable` closure; `CompositeImageFetcher` and `MockAnalyticsProvider` are `Sendable` via `LockIsolated` (T-083).

**Resolved (Round 69):** `CAMediaTimingFunction` presets use frozen `static let`; `SessionAwareCache` is `Sendable` via `LockIsolated` session state (T-084).

**Resolved (Round 70):** `Analytics` hub state behind `LockIsolated` (T-085).

**Resolved (Round 71):** `LiveSessionCounterClient` observation task in `LockIsolated` (T-086).

**Resolved (Round 72):** `Money.Appearance` global styling via `LockIsolated` (T-087).

**Attempted (Round 73):** `Popup.TransitionStorage` plain `Sendable` reverted — `AnyTransition` is not `Sendable` on macOS CI (T-088).

Regressions: `BuildTools/Scripts/audit_unchecked_sendable_inventory.sh` compares live count to the total above.