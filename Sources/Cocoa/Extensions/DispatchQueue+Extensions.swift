//
// DispatchQueue+Extensions.swift
//
// Copyright © 2017 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation
import Dispatch

extension DispatchQueue {
    private class var currentLabel: String? {
        return OperationQueue.current?.underlyingQueue?.label
    }

    /// Submits a work item to a dispatch queue. If already on the dispatch queue then executes
    /// the work item right away.
    ///
    /// - Parameter work: The work item to be invoked on the queue.
    func asyncSafe(execute work: @escaping @convention(block) () -> Void) {
        if DispatchQueue.currentLabel == label {
            work()
            return
        }

        async(execute: work)
    }

    /// Submits a work item to a dispatch queue. If already on the dispatch queue then executes
    /// the work item right away.
    ///
    /// - Parameter work: The work item to be invoked on the queue.
    func syncSafe(execute work: @escaping @convention(block) () -> Void) {
        if DispatchQueue.currentLabel == label {
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
        return .now() + Double(Int64(interval * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
    }
}
