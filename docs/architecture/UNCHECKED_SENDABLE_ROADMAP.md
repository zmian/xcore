# `@unchecked Sendable` reduction roadmap

Agent queue for lowering the budget in [UNCHECKED_SENDABLE_INVENTORY.md](./UNCHECKED_SENDABLE_INVENTORY.md) (ADR 0007).  
**Open annotations: 21** (must match `make audit-architecture`).

## Primitives (keep conditional `@unchecked`)

| File | Site |
| --- | --- |
| `ReferenceBox.swift` | `ReferenceBox` / `MutableReferenceBox` extensions |
| `Weak.swift` | `Weak` extension |
| `ValuePublisher.swift` | `ValuePublisher` extension (`CurrentValueSubject`) |
| `ExtensibleByAssociatedObject.swift` | `AssociatedObjectKey` (`UnsafeRawPointer`; plain `Sendable` reverted T-118) |

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
| `Publisher+Extensions.swift` | `DoneSubscriberCancellables` | `AnyCancellable` set (`LockIsolated` reverted T-122) |
| `ValidationRule+Rules.swift` | `RegexValidationPattern` | `Regex` holder (direct capture reverted T-121) |
| `Popup.swift` | `TransitionStorage` | `AnyTransition` (plain `Sendable` reverted T-088) |
| `CodingFormatStyle+Formatter.swift` | `FormatterCodingFormatStyle` | `Formatter` bridge |
| `PondKey.swift` | `Storage` | `AuthenticationPolicy` |
| `Pond+UserDefaults.swift` | `UserDefaultsPond` | `UserDefaults` not `Sendable` on macOS CI (T-115 reverted) |

## Resolved in this PR

- `AddressSearchResult.swift` (T-113) — struct `Sendable`

Update this file whenever the live count changes.