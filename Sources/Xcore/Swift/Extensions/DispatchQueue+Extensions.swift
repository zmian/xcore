//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Dispatch
import Combine

extension DispatchQueue {
    private class var currentLabel: String? {
        OperationQueue.current?.underlyingQueue?.label
    }

    /// Submits a work item to a dispatch queue. If already on the dispatch queue
    /// then executes the work item right away.
    ///
    /// - Parameter work: The work item to be invoked on the queue.
    func asyncSafe(execute work: @escaping @convention(block) () -> Void) {
        if Self.currentLabel == label {
            work()
            return
        }

        async(execute: work)
    }

    /// Submits a work item to a dispatch queue. If already on the dispatch queue
    /// then executes the work item right away.
    ///
    /// - Parameter work: The work item to be invoked on the queue.
    func syncSafe(execute work: @escaping @convention(block) () -> Void) {
        if Self.currentLabel == label {
            work()
            return
        }

        sync(execute: work)
    }
}

extension DispatchTime {
    /// A convenience method to convert `TimeInterval` to `DispatchTime`.
    ///
    /// - Parameter interval: The time interval, in seconds.
    /// - Returns: A new `DispatchTime` from specified seconds.
    public static func seconds(_ interval: TimeInterval) -> DispatchTime {
        .now() + TimeInterval(Int64(interval * TimeInterval(NSEC_PER_SEC))) / TimeInterval(NSEC_PER_SEC)
    }
}

extension DispatchTime {
    public static func seconds(elapsedSince lastTime: UInt64) -> TimeInterval {
        let currentTime = DispatchTime.now().uptimeNanoseconds
        let oneSecondInNanoseconds = TimeInterval(1_000_000_000)
        let secondsElapsed = TimeInterval(Int64(currentTime) - Int64(lastTime)) / oneSecondInNanoseconds
        return secondsElapsed
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
    .eraseToAnyPublisher()
    .sink { _ in
        work()
    }
}
