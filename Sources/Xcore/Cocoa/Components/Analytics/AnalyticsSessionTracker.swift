//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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
    private var observers = [NSObjectProtocol]()
    private var lastActiveTime = DispatchTime.now().uptimeNanoseconds
    private var values = Set<String>()
    private let sessionExpirationDuration: TimeInterval

    /// Initialize an instance of analytics session tracker.
    ///
    /// - Parameter sessionExpirationDuration: Allowed time in seconds for the user
    ///   to be considered in the same session when the app enters foreground. The
    ///   default value is `30` seconds.
    public init(sessionExpirationDuration: TimeInterval = 30) {
        self.sessionExpirationDuration = sessionExpirationDuration
        addNotificationObservers()
    }

    deinit {
        NotificationCenter.remove(observers)
        observers.removeAll()
    }

    /// A method to add observers for app lifecycle.
    ///
    /// `lastActiveTime` keeps track of the last time the app was active, to be
    /// updated on each `applicationWillResignActive` notification.
    /// `onApplicationWillResignActive` registers the current time as the
    /// `lastActiveTime` as the app is losing focus.
    ///
    /// `onApplicationWillEnterForeground` checks the current time against the last
    /// time the app was active, and invalidates the `values` cache if the time is
    /// greater than the longest allowed time for the user to be considered in the
    /// same session.
    private func addNotificationObservers() {
        observers.append(NotificationCenter.on.applicationWillResignActive { [weak self] in
            self?.lastActiveTime = DispatchTime.now().uptimeNanoseconds
        })

        observers.append(NotificationCenter.on.applicationWillEnterForeground { [weak self] in
            guard let strongSelf = self else { return }

            // `DispatchTime` was used here instead of `Date.timeIntervalSince(_:)` because
            // of an edge case that can happen with `Date` if the user changes their
            // timezone. `DispatchTime` is agnostic of any timezone changes, and it works
            // consistently.
            if DispatchTime.seconds(elapsedSince: strongSelf.lastActiveTime) > strongSelf.sessionExpirationDuration {
                // Invalidate cache
                strongSelf.values.removeAll()
            }
        })
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

    /// Returns a boolean value that indicates whether the given value exists in the
    /// set.
    ///
    /// - Parameter value: An value to look for in the set.
    public func contains(_ value: String) -> Bool {
        values.contains(value)
    }
}
