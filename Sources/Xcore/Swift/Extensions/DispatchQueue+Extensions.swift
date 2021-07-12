//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Dispatch

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
