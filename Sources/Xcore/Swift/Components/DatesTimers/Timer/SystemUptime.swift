//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A class representing the number of nanoseconds since the system boot,
/// excluding any time the system spent asleep.
///
/// `SystemUptime` provides functionality to track and compare elapsed time
/// with precision, relying on a monotonic clock source to ensure consistency
/// across system clock changes.
public final class SystemUptime: Sendable, Hashable, Identifiable {
    /// A unique identifier for the instance.
    public let id: UUID

    /// Stores the last saved uptime in nanoseconds.
    private let value = LockIsolated(DispatchTime.now().uptimeNanoseconds)

    /// Initializes a new `SystemUptime` instance with an optional unique ID.
    ///
    /// - Parameter id: A unique identifier for the instance.
    public init(id: UUID = UUID()) {
        self.id = id
    }

    /// Updates to the current system uptime.
    ///
    /// This method updates the stored value with the current monotonic uptime in
    /// nanoseconds, ensuring accurate tracking of time intervals.
    public func updateValue() {
        value.setValue(DispatchTime.now().uptimeNanoseconds)
    }

    /// Checks whether the elapsed time exceeds the given duration.
    ///
    /// This method calculates the time difference between the current system uptime
    /// and the last saved uptime. If the difference is negative (indicating a
    /// system restart), it returns `true`.
    ///
    /// - Parameter duration: The time interval in seconds to compare against.
    /// - Returns: A boolean indicating whether the elapsed time exceeds the given
    ///   duration.
    public func elapsed(_ duration: TimeInterval) -> Bool {
        let diff = diffInSeconds

        // System was restarted.
        if diff < 0 {
            return true
        }

        return diff >= duration
    }

    /// Returns the number of seconds that have elapsed since the last saved uptime.
    ///
    /// - Returns: The elapsed time in seconds, rounded to the nearest integer. If
    ///   a system restart is detected, it returns `0`.
    public func secondsElapsed() -> Int {
        let diff = lround(diffInSeconds)

        // System was restarted.
        if diff < 0 {
            return 0
        }

        return diff
    }

    /// Computes the time difference in seconds between the current uptime
    /// and the last saved uptime.
    private var diffInSeconds: TimeInterval {
        DispatchTime.elapsedSeconds(since: value.value)
    }

    public static func ==(lhs: SystemUptime, rhs: SystemUptime) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
