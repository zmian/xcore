# `@unchecked Sendable` inventory

Living snapshot of deliberate Sendable erasure in `Sources/Xcore`. **Total: 20 annotations** (regenerate with `make audit-architecture`).

Agents: prefer `LockIsolated`, frozen `static let`, or `ReferenceBox` before adding new `@unchecked Sendable`. Never combine with `nonisolated(unsafe)` (ADR 0006).

## Canonical primitives (conditional conformance)

| Location | Role |
| --- | --- |
| `ReferenceBox.swift` | `ReferenceBox` / `MutableReferenceBox` when `Value: Sendable` |
| `Weak.swift` | `Weak` when `Value: Sendable` |
| `ValuePublisher.swift` | `ValuePublisher` when `Output: Sendable` |

## Dependency clients (live + handlers)

| Location | Role |
| --- | --- |
| `PushNotificationsClient+Live.swift` | `NSObject` live client |
| `PushNotificationsClient.swift` | `NotificationReceivedHandler` (non-Sendable closure storage) |
| `SessionCounterClient+Live.swift` | Live client with locked storage |
| `AppPhaseClient.swift` | `AppPhase` enum payloads |

## Components (shared mutable or UIKit bridges)

| Location | Role |
| --- | --- |
| `Analytics.swift` | Open analytics hub |
| `AnalyticsProvider+Mock.swift` | Mock provider (`LockIsolated` state) |
| `AnalyticsProvider.swift` | Protocol doc example only |
| `SessionAwareCache.swift` | Session-scoped cache |
| `Money.swift` | `Appearance` styling box |
| `ImageFetcher+Composite.swift` | Composite fetcher (`LockIsolated` list) |
| `UIImage+Fetcher.swift` | `ImageDownloaderCancelToken` |
| `CoreAnimation+Extensions.swift` | Timing-function preset cache |
| `Popup.swift` | `TransitionStorage` (`AnyTransition`) |
| `CodingFormatStyle+Formatter.swift` | `FormatterCodingFormatStyle` bridges `Formatter` |
| `PondKey.swift` / `Pond+UserDefaults.swift` | Pond storage variants |

Regressions: `BuildTools/Scripts/audit_unchecked_sendable_inventory.sh` compares live count to the total above.