//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

enum MonotonicClock { }

// MARK: - MonotonicClock.Uptime

extension MonotonicClock {
    struct Uptime {
        private lazy var begin = DispatchTime.now().uptimeNanoseconds

        mutating func captureValue() {
            begin = DispatchTime.now().uptimeNanoseconds
        }

        mutating func elapsed(_ duration: TimeInterval) -> Bool {
            let diffInNanoseconds = DispatchTime.now().uptimeNanoseconds - begin
            let diff = TimeInterval(diffInNanoseconds) / 1_000_000_000

            // System was restarted.
            if diff < 0 {
                return true
            }

            return diff >= duration
        }
    }
}

// MARK: - MonotonicClock.Timer

extension MonotonicClock {
    final class Timer {
        private let queue: DispatchQueue
        private let workItem: DispatchWorkItem

        init(interval: TimeInterval, queue: DispatchQueue = .main, block: @escaping () -> Void) {
            self.queue = queue
            self.workItem = DispatchWorkItem {
                block()
            }

            queue.asyncAfter(deadline: .now() + .milliseconds(Int(interval * 1000)), execute: workItem)
        }

        func invalidate() {
            workItem.cancel()
        }
    }
}
