//
// IdleTimer+InternalTimer.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension IdleTimer {
    final class InternalTimer {
        private var timer: Timer?
        private let timeoutHandler: () -> Void

        /// The timeout duration in seconds, after which `timeoutHandler` is invoked.
        var timeoutDuration: TimeInterval {
            didSet {
                reset()
            }
        }

        /// Creates a new instance of `IdleTimer`.
        ///
        /// - Parameters:
        ///   - duration: The timeout duration in seconds, after which `timeoutHandler`
        ///               is invoked.
        ///   - timeoutHandler: The closure to invoke after timeout duration has passed.
        init(timeoutAfter duration: TimeInterval, handler timeoutHandler: @escaping () -> Void) {
            self.timeoutDuration = duration
            self.timeoutHandler = timeoutHandler
            reset()
        }

        private func reset() {
            if let timer = timer {
                timer.invalidate()
            }

            guard timeoutDuration > 0 else {
                return
            }

            timer = Timer.scheduledTimer(withTimeInterval: timeoutDuration, repeats: false) { [weak self] _ in
                self?.timeoutHandler()
            }
        }

        func wake() {
            guard timer != nil else {
                return
            }

            reset()
        }
    }
}
