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
    public static func seconds(_ interval: TimeInterval) -> DispatchTime {
        .now() + (interval * nanosecondsPerSecond) / nanosecondsPerSecond
    }

    /// Calculates the time interval in seconds elapsed since the specified
    /// `DispatchTime`.
    ///
    /// - Parameter lastTime: The `DispatchTime` value representing a reference
    ///   point in time.
    /// - Returns: The time interval, in seconds, between the current time and the
    ///   specified `lastTime`.
    public static func seconds(elapsedSince lastTime: UInt64) -> TimeInterval {
        let currentTime = DispatchTime.now().uptimeNanoseconds
        // Using Int64 instead of UInt64 to avoid Swift runtime failure: arithmetic
        // overflow due to arithmetic returning signed (-) value for UInt64 type.
        let diffInNanoseconds = Int64(currentTime) - Int64(lastTime)
        let secondsElapsed = TimeInterval(diffInNanoseconds) / nanosecondsPerSecond
        return secondsElapsed
    }

    /// The number of nanoseconds in one second.
    private static var nanosecondsPerSecond: TimeInterval {
        TimeInterval(NSEC_PER_SEC)
    }
}

extension DispatchTimeInterval {
    fileprivate var isImmediate: Bool {
        switch self {
            case let .seconds(int),
                 let .milliseconds(int),
                 let .microseconds(int),
                 let .nanoseconds(int):
                return int <= 0
            case .never:
                return true
            @unknown default:
                return false
        }
    }
}

/// Schedules a block for execution using the specified attributes, and returns
/// immediately.
public func withDelay(_ interval: TimeInterval, perform work: @escaping () -> Void) {
    interval > 0 ? withDelay(.now() + interval, perform: work) : work()
}

/// Schedules a block for execution using the specified attributes, and returns
/// immediately.
public func withDelay(_ interval: DispatchTimeInterval, perform work: @escaping () -> Void) {
    !interval.isImmediate ? withDelay(.now() + interval, perform: work) : work()
}

/// Schedules a block for execution using the specified attributes, and returns
/// immediately.
public func withDelay(_ deadline: DispatchTime, perform work: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: deadline, execute: work)
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
