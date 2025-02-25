//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing the nanosecond precision duration using a monotonic
/// clock.
///
/// `ElapsedTime` provides functionality to track and compare elapsed time with
/// precision, relying on a monotonic clock source to ensure consistency across
/// system clock changes.
public struct ElapsedTime: Sendable, Hashable {
    /// A unique identifier for the instance.
    ///
    /// Exclusively used to satisfy `Hashable` conformance; it simplifies using this
    /// property in models that require `Hashable`.
    private var id: UUID

    /// The last saved elapsed time.
    private var storage = LockIsolated(ContinuousClock.now)

    /// Creates a new instance of `ElapsedTime`.
    ///
    /// - Parameter id: A unique identifier for the instance.
    public init(id: UUID = UUID()) {
        self.id = id
    }

    /// Resets the stored value to the current system uptime.
    public mutating func reset() {
        if !isKnownUniquelyReferenced(&storage) {
            storage = .init(.now)
            id = UUID()
        } else {
            storage.setValue(.now)
        }
    }

    /// Checks whether the elapsed time exceeds the given duration.
    ///
    /// This method calculates the time difference between the current system uptime
    /// and the given duration. If the difference is negative (indicating a system
    /// restart), it returns `true`.
    ///
    /// - Parameter duration: The duration to compare against.
    /// - Returns: A boolean indicating whether the elapsed time exceeds the given
    ///   duration.
    public func hasElapsed(_ duration: Duration) -> Bool {
        let diff = diff

        // System was restarted.
        if diff < .zero {
            return true
        }

        return diff >= duration
    }

    /// Returns the duration that have elapsed since the last saved time.
    ///
    /// - Returns: The elapsed time. If a system restart is detected, it returns
    ///   `.zero`.
    public func elapsedDuration() -> Duration {
        let diff = diff

        // System was restarted.
        if diff < .zero {
            return .zero
        }

        return diff
    }

    /// Returns the number of seconds that have elapsed since the last saved uptime.
    ///
    /// - Returns: The elapsed time in seconds, rounded to the nearest integer. If a
    ///   system restart is detected, it returns `0`.
    public func elapsedSeconds() -> Int {
        Int(elapsedDuration().seconds.rounded())
    }

    /// Computes the time difference between the current uptime and the last saved
    /// uptime.
    private var diff: Duration {
        .now - storage.value
    }
}

// MARK: - Hashable

extension ElapsedTime {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Testing

extension ElapsedTime {
    /// NB: testing only.
    var _start: ContinuousClock.Instant {
        storage.value
    }
}
