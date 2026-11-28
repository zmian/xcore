# `@unchecked Sendable` inventory

Living snapshot of deliberate Sendable erasure in `Sources/Xcore`. **Total: 21 annotations** (regenerate with `make audit-architecture`).

Agents: prefer `LockIsolated`, frozen `static let`, or `ReferenceBox` before adding new `@unchecked Sendable`. Never combine with `nonisolated(unsafe)` (ADR 0006). Reduction queue: [UNCHECKED_SENDABLE_ROADMAP.md](./UNCHECKED_SENDABLE_ROADMAP.md).

## Canonical primitives (conditional conformance)

| Location | Role |
| --- | --- |
| `ExtensibleByAssociatedObject.swift` | `AssociatedObjectKey` (stable `UnsafeRawPointer` token) |
| `ReferenceBox.swift` | `ReferenceBox` / `MutableReferenceBox` when `Value: Sendable` |
| `Weak.swift` | `Weak` when `Value: Sendable` |
| `ValuePublisher.swift` | `ValuePublisher` when `Output: Sendable` (`CurrentValueSubject` holder) |

## Dependency clients (live + handlers)

| Location | Role |
| --- | --- |
| `AddressSearchClient+Live.swift` | `LiveAddressSearchClient` (`@Sendable` `.live` capture); `Delegate` (`NSObject` + `MKLocalSearchCompleter`) |
| `AudioPlayerClient+Live.swift` | `LiveAudioClient` (`AVAudioPlayer` behind `NSLock`) |
| `SessionCounterClient+Live.swift` | `LiveSessionCounterClient` (`@Dependency` + observation task) |
| `PushNotificationsClient+Live.swift` | `NSObject` live client |
| `PushNotificationsClient.swift` | `NotificationReceivedHandler` (non-Sendable closure storage) |
| `AppPhaseClient.swift` | `AppPhase` enum payloads |

## Components (shared mutable or UIKit bridges)

| Location | Role |
| --- | --- |
| `Popup.swift` | `TransitionStorage` (`AnyTransition`) |
| `CodingFormatStyle+Formatter.swift` | `FormatterCodingFormatStyle` bridges `Formatter` |
| `Cache.swift` | `Cache` + `DelegateWrapper` (`NSCache`) |
| `SessionAwareCache.swift` | observation `Task` + `@Dependency` |
| `Publisher+Extensions.swift` | `DoneSubscriberCancellables` (`AnyCancellable` set; `LockIsolated` reverted T-122) |
| `ValidationRule+Rules.swift` | `RegexValidationPattern` (`Regex` holder; direct capture reverted T-121) |
| `PondKey.swift` / `Pond+UserDefaults.swift` | Pond storage variants |

**Resolved (Round 86):** `AddressSearchClient` is a struct client; live engine marked `@unchecked Sendable` for closure wiring (T-107). Deletes public protocol + conformer types.

**Resolved (Round 91):** `AddressSearchResult` is a `Sendable` struct; resolve uses natural-language `MKLocalSearch.Request` (T-113).

**Attempted (Round 93):** `UserDefaultsPond` plain `Sendable` reverted — `UserDefaults` not `Sendable` on macOS CI (T-115).

**Attempted (Round 94):** Delete `RegexValidationPattern`; reverted — `Regex<Output>` not `Sendable` in `@Sendable` closure on CI (T-116/T-121).

**Attempted (Round 95):** `Publisher.done` `LockIsolated` set; reverted — `AnyCancellable` not `Sendable` in `@Sendable` closures on CI (T-117/T-122).

**Attempted (Round 96):** `AssociatedObjectKey` plain `Sendable` reverted — `UnsafeRawPointer` not `Sendable` on CI (T-118).

**Attempted (Round 97):** `ValuePublisher` plain conditional `Sendable` reverted — `CurrentValueSubject` not `Sendable` (T-119).

**Resolved (Round 68):** `ImageDownloaderCancelToken` uses `@Sendable` closure; `CompositeImageFetcher` and `MockAnalyticsProvider` are `Sendable` via `LockIsolated` (T-083).

**Resolved (Round 69):** `CAMediaTimingFunction` presets use frozen `static let`; `SessionAwareCache` is `Sendable` via `LockIsolated` session state (T-084).

**Resolved (Round 70):** `Analytics` hub state behind `LockIsolated` (T-085).

**Resolved (Round 71):** `LiveSessionCounterClient` observation task in `LockIsolated` (T-086).

**Resolved (Round 72):** `Money.Appearance` global styling via `LockIsolated` (T-087).

**Attempted (Round 73):** `Popup.TransitionStorage` plain `Sendable` reverted — `AnyTransition` is not `Sendable` on macOS CI (T-088).

Regressions: `BuildTools/Scripts/audit_unchecked_sendable_inventory.sh` compares live count to the total above.