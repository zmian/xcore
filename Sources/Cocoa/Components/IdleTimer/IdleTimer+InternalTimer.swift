//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension IdleTimer {
    final class InternalTimer {
        private var tokens: [NSObjectProtocol?] = []
        private var uptime = MonotonicClock.Uptime()
        private var timer: MonotonicClock.Timer?
        private let timeoutHandler: () -> Void

        /// The timeout duration in seconds, after which `timeoutHandler` is invoked.
        var timeoutDuration: TimeInterval {
            didSet {
                restart()
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
            restart()
            setupObservers()
        }

        private func setupObservers() {
            tokens.append(NotificationCenter.on.applicationDidEnterBackground { [weak self] in
                self?.uptime.saveValue()
            })

            tokens.append(NotificationCenter.on.applicationWillEnterForeground { [weak self] in
                self?.handleExpirationIfNeeded()
            })
        }

        private func handleExpirationIfNeeded() {
            guard uptime.elapsed(timeoutDuration) else {
                restart()
                return
            }

            timeoutHandler()
        }

        deinit {
            NotificationCenter.remove(tokens)
        }

        private func restart() {
            if let timer = timer {
                timer.invalidate()
            }

            guard timeoutDuration > 0 else {
                return
            }

            timer = MonotonicClock.Timer(interval: timeoutDuration) { [weak self] in
                self?.timeoutHandler()
            }
        }

        func wake() {
            guard timer != nil else {
                return
            }

            restart()
        }
    }
}
