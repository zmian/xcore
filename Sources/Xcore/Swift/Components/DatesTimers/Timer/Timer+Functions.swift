//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Dispatch
import Combine

extension DispatchTime {
    /// Returns a `DispatchTime` calculated from the given time interval in seconds.
    ///
    /// - Parameter interval: The time interval, in seconds.
    /// - Returns: A new `DispatchTime` instance calculated from the given time
    ///  interval in seconds.
    public static func seconds(_ interval: TimeInterval) -> Self {
        .now() + (interval * nanosecondsPerSecond) / nanosecondsPerSecond
    }

    /// Calculates the time interval in seconds elapsed since the specified
    /// `DispatchTime`.
    ///
    /// - Parameter lastUptime: The `DispatchTime` value representing a reference
    ///   point in time.
    /// - Returns: The time interval, in seconds, between the current time and the
    ///   specified `lastUptime`.
    public static func seconds(elapsedSince lastUptime: UInt64) -> TimeInterval {
        let currentTime = DispatchTime.now().uptimeNanoseconds
        // Using Int64 instead of UInt64 to avoid Swift runtime failure: arithmetic
        // overflow due to arithmetic returning signed (-) value for UInt64 type.
        let diffInNanoseconds = Int64(currentTime) - Int64(lastUptime)
        let secondsElapsed = TimeInterval(diffInNanoseconds) / nanosecondsPerSecond
        return secondsElapsed
    }

    /// The number of nanoseconds in one second.
    private static var nanosecondsPerSecond: TimeInterval {
        TimeInterval(NSEC_PER_SEC)
    }
}

/// Schedules given operation for execution using the specified attributes, and
/// returns immediately.
@discardableResult
public func withDelay(
    _ duration: ContinuousClock.Instant.Duration,
    tolerance: ContinuousClock.Instant.Duration? = nil,
    priority: TaskPriority? = nil,
    perform operation: sending @escaping @isolated(any) () -> Void
) -> Task<Void, Never> {
    Task(priority: priority) {
        do {
            try await Task.sleep(for: duration, tolerance: tolerance, clock: ContinuousClock())
            await operation()
        } catch {
            // If the task is cancelled before the time ends, this function throws
            // `CancellationError`. Thus, we just report it.
            reportIssue(error)
        }
    }
}

/// Schedules a block for execution for every given seconds.
public func withTimer(every interval: TimeInterval, perform work: @escaping () -> Void) -> AnyCancellable {
    Timer.publish(
        every: interval,
        on: .main,
        in: .common
    )
    .autoconnect()
    .merge(with: Just(Date()))
    .sink { _ in
        work()
    }
}
