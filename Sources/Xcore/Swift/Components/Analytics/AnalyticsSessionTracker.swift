//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Combine

/// This class provides a caching mechanism for tracking any given value. It can
/// be used to keep track of the events that have been sent to avoid over firing
/// (e.g., auto-scrolling carousel display event).
///
/// **What defines a session?**
///
/// A session is the duration for which the app is in the foreground. If the app
/// enters background for more then specified `sessionExpirationDuration` then
/// it's considered a new session and all the cached values are removed.
public final class AnalyticsSessionTracker {
    @Dependency(\.appPhase) private var appPhase
    private var cancellable: AnyCancellable?
    private var lastActiveTime = DispatchTime.now().uptimeNanoseconds
    private var values = Set<String>()
    private let sessionExpirationDuration: TimeInterval

    /// Creates an instance of analytics session tracker.
    ///
    /// - Parameter sessionExpirationDuration: Allowed time in seconds for the user
    ///   to be considered in the same session when the app enters foreground. The
    ///   default value is `30` seconds.
    public init(sessionExpirationDuration: TimeInterval = 30) {
        self.sessionExpirationDuration = sessionExpirationDuration

        withDelay(0.3) { [weak self] in
            // Delay to avoid:
            // Thread 1: Simultaneous accesses to 0x1107dbc18, but modification requires
            // exclusive access. This class can be used inside analytics client that invokes
            // other clients.
            self?.addAppPhaseObserver()
        }
    }

    /// Adds an observer for the app lifecycle.
    ///
    /// `lastActiveTime` value is updated to reflect the time app was backgrounded.
    ///
    /// When app enters foreground, the current time is compared to the last active
    /// time. If the time is greater than the longest allowed time for the user to
    /// be considered in the same session then `values` cache is invalidated.
    private func addAppPhaseObserver() {
        cancellable = appPhase.receive.sink { [weak self] appPhase in
            guard let self else { return }

            switch appPhase {
                case .background:
                    lastActiveTime = DispatchTime.now().uptimeNanoseconds
                case .willEnterForeground:
                    // `DispatchTime` was used here instead of `Date.timeIntervalSince(_:)` because
                    // of an edge case that can happen with `Date` if the user changes their
                    // timezone. `DispatchTime` is agnostic of any timezone changes, and it works
                    // consistently.
                    if DispatchTime.seconds(elapsedSince: lastActiveTime) > sessionExpirationDuration {
                        // Invalidate cache
                        values.removeAll()
                    }
                default:
                    break
            }
        }
    }

    /// Inserts the given value in the set if it is not already present.
    ///
    /// - Parameter value: A value to insert into the set.
    /// - Returns: `false` if the given `value` already present; otherwise, returns
    ///   `true`, and adds the `value` to the set.
    public func insert(_ value: String) -> Bool {
        values.insert(value).inserted
    }

    /// Removes the given value in the set.
    ///
    /// - Parameter value: The value to remove from the set.
    /// - Returns: `true` if the `value` was present; otherwise, returns `false`.
    @discardableResult
    public func remove(_ value: String) -> Bool {
        values.remove(value) != nil
    }

    /// Returns a Boolean value indicating whether the given value exists in the
    /// set.
    ///
    /// - Parameter value: An value to look for in the set.
    public func contains(_ value: String) -> Bool {
        values.contains(value)
    }
}
