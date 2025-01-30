//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Combine

/// A session-aware caching mechanism for tracking values during app activity.
///
/// This cache retains values only during an active session. If the app remains
/// in the background for longer than the specified `inactivityDuration`, the
/// cache is cleared, marking the start of a new session.
///
/// It is useful for tracking events that have already been sent to prevent
/// over-firing, such as avoiding duplicate "auto-scrolling carousel display"
/// events.
///
/// **What defines a session?**
///
/// A session is defined as the period during which the app stays in the
/// foreground. If the app is sent to the background for longer than the
/// specified `inactivityDuration`, it is considered a new session, and all
/// cached values are cleared.
///
/// **Usage**
///
/// ```swift
/// let analyticsSessionCache = SessionAwareCache<String>(inactivityDuration: .seconds(30))
/// let event = AppAnalyticsEvent(name: "example_event")
/// if !analyticsSessionCache.insert(event.name) {
///     // Send to the analytics service
///     analytics.track(event)
/// }
/// ```
public final class SessionAwareCache<Value: Sendable & Hashable>: @unchecked Sendable {
    @Dependency(\.appPhase) private var appPhase
    private let lastActiveTime = SystemUptime()
    private let inactivityDuration: TimeInterval
    private let storage = LockIsolated<Set<Value>>([])
    nonisolated(unsafe) private var cancellable: AnyCancellable?

    /// Creates an instance of `SessionAwareCache`.
    ///
    /// - Parameter inactivityDuration: The duration after which the session expires
    ///   if the app remains in the background.
    public init(inactivityDuration: Duration = .seconds(30)) {
        self.inactivityDuration = TimeInterval(inactivityDuration.components.seconds)

        withDelay(.seconds(0.3)) { [weak self] in
            // Delay to avoid:
            // Thread 1: Simultaneous accesses to 0x1107dbc18, but modification requires
            // exclusive access. This class can be used inside analytics client that invokes
            // other clients.
            self?.addAppPhaseObserver()
        }
    }

    /// Observes app lifecycle events to manage session activity.
    ///
    /// When the app enters the background, the `lastActiveTime` is recorded. When
    /// the app returns to the foreground, the last active time is checked. If the
    /// session has expired, the cached values are cleared.
    private func addAppPhaseObserver() {
        cancellable = appPhase.receive.sink { [weak self] appPhase in
            guard let self else { return }

            switch appPhase {
                case .background:
                    lastActiveTime.updateValue()
                case .willEnterForeground:
                    if lastActiveTime.elapsed(inactivityDuration) {
                        // Reset the cache for a new session
                        storage.withValue { $0.removeAll() }
                    }
                default:
                    break
            }
        }
    }

    /// Inserts the given value in the cache if it is not already present.
    ///
    /// - Parameter value: The value to insert into the cache.
    /// - Returns: `true` if the value is inserted in the cache; otherwise, `false`.
    public func insert(_ value: Value) -> Bool {
        storage.withValue {
            $0.insert(value).inserted
        }
    }

    /// Removes the specified value from the cache.
    ///
    /// - Parameter value: The value to remove from the cache.
    /// - Returns: `true` if the value was removed from the cache; otherwise,
    ///  `false`.
    @discardableResult
    public func remove(_ value: Value) -> Bool {
        storage.withValue {
            $0.remove(value) != nil
        }
    }

    /// Returns a Boolean value that indicates whether the given value exists in the
    /// cache.
    ///
    /// - Parameter value: A value to look for in the cache.
    /// - Returns: `true` if the value exists in the cache; otherwise, `false`.
    public func contains(_ value: Value) -> Bool {
        storage.value.contains(value)
    }
}
