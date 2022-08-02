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
