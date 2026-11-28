# `@unchecked Sendable` reduction roadmap

Agent queue for lowering the budget in [UNCHECKED_SENDABLE_INVENTORY.md](./UNCHECKED_SENDABLE_INVENTORY.md) (ADR 0007).  
**Open annotations: 18** (must match `make audit-architecture`).

## Primitives (keep conditional `@unchecked`)

| File | Site |
| --- | --- |
| `ReferenceBox.swift` | `ReferenceBox` / `MutableReferenceBox` extensions |
| `Weak.swift` | `Weak` extension |
| `ValuePublisher.swift` | `ValuePublisher` extension |

## Dependency / live clients

| File | Site | Next lever |
| --- | --- | --- |
| `AddressSearchClient+Live.swift` | `LiveAddressSearchClient`, `Delegate` | NSObject / MapKit; struct client wired |
| `AudioPlayerClient+Live.swift` | `LiveAudioClient` | `AVAudioPlayer` + `NSLock` |
| `SessionCounterClient+Live.swift` | `LiveSessionCounterClient` | `@Dependency` observation holder |
| `PushNotificationsClient+Live.swift` | `LivePushNotificationsClient` | `UNUserNotificationCenterDelegate` |
| `PushNotificationsClient.swift` | `NotificationReceivedHandler` | UIKit completion closures |
| `AppPhaseClient.swift` | `AppPhase` enum | UIKit payload types (**P-003**) |

## Components

| File | Site | Next lever |
| --- | --- | --- |
| `Cache.swift` | `Cache`, `DelegateWrapper` | `NSCache` / delegate |
| `SessionAwareCache.swift` | main class | observation `Task` |
| `Popup.swift` | `TransitionStorage` | `AnyTransition` (plain `Sendable` reverted T-088) |
| `CodingFormatStyle+Formatter.swift` | `FormatterCodingFormatStyle` | `Formatter` bridge |
| `PondKey.swift` | `Storage` | `AuthenticationPolicy` |
| `Pond+UserDefaults.swift` | `UserDefaultsPond` | `UserDefaults` not `Sendable` on macOS CI (T-115 reverted) |

## Resolved in this PR

- `ExtensibleByAssociatedObject.swift` (T-118) — `AssociatedObjectKey` plain `Sendable`
- `Publisher+Extensions.swift` (T-117) — `LockIsolated` cancellable set
- `ValidationRule+Rules.swift` (T-116) — `regex(Regex<Output>)` + `Output: Sendable`
- `AddressSearchResult.swift` (T-113) — struct `Sendable`

Update this file whenever the live count changes.