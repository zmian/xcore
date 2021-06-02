//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension IdleTimer {
    final class InternalTimer {
        private var tokens: [NSObjectProtocol?] = []
        private var uptime = MonotonicClock.Uptime()
        private var timer: MonotonicClock.Timer?
        private let onTimeout: () -> Void

        /// The timeout duration in seconds, after which `onTimeout` is invoked.
        var timeoutDuration: TimeInterval {
            didSet {
                guard oldValue != timeoutDuration else {
                    return
                }
                restart()
            }
        }

        /// Creates a new instance of `IdleTimer`.
        ///
        /// - Parameters:
        ///   - duration: The timeout duration in seconds, after which `onTimeout` is
        ///     invoked.
        ///   - onTimeout: The closure to invoke after timeout duration has passed.
        init(timeoutAfter duration: TimeInterval, onTimeout: @escaping () -> Void) {
            self.timeoutDuration = duration
            self.onTimeout = onTimeout
            restart()
            setupObservers()
        }

        private func setupObservers() {
            on(UIApplication.didEnterBackgroundNotification) {
                $0.uptime.saveValue()
            }

            on(UIApplication.willEnterForegroundNotification) {
                $0.handleExpirationIfNeeded()
            }
        }

        private func on(_ event: Notification.Name, work: @escaping (InternalTimer) -> Void) {
            tokens.append(NotificationCenter.on.observe(event) { [weak self] in
                guard
                    let strongSelf = self,
                    strongSelf.timeoutDuration > 0
                else {
                    return
                }

                work(strongSelf)
            })
        }

        private func handleExpirationIfNeeded() {
            if uptime.elapsed(timeoutDuration) {
                return onTimeout()
            }

            restart()
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
                self?.onTimeout()
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
