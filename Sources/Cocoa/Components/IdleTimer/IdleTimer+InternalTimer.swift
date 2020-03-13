//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension IdleTimer {
    final class InternalTimer {
        private var monotonicClock = MonotonicClock()
        private var tokens: [NSObjectProtocol?] = []
        private var timer: Timer?
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
                self?.monotonicClock.captureValue()
            })

            tokens.append(NotificationCenter.on.applicationWillEnterForeground { [weak self] in
                self?.handleExpirationIfNeeded()
            })
        }

        private func handleExpirationIfNeeded() {
            guard monotonicClock.elapsed(timeoutDuration) else {
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

            timer = Timer.scheduledTimer(withTimeInterval: timeoutDuration, repeats: false) { [weak self] _ in
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

// MARK: - MonotonicClock

private struct MonotonicClock {
    private let info = ProcessInfo.processInfo
    private lazy var begin = info.systemUptime

    mutating func captureValue() {
        begin = info.systemUptime
    }

    mutating func elapsed(_ duration: TimeInterval) -> Bool {
        let diff = info.systemUptime - begin

        // System was restarted.
        if diff < 0 {
            return true
        }

        return diff >= duration
    }
}
