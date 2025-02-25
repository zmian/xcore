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
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let futureTime = DispatchTime.seconds(2.5)
    /// print(futureTime)
    /// ```
    ///
    /// - Parameter interval: The time interval in seconds.
    /// - Returns: A new `DispatchTime` instance calculated from the given time
    ///  interval in seconds.
    public static func seconds(_ interval: TimeInterval) -> Self {
        .now() + .nanoseconds(Int(interval * nanosecondsPerSecond))
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
            try await Task.sleep(for: duration, tolerance: tolerance, clock: .continuous)
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
