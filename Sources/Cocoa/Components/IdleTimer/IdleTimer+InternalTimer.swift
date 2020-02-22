//
// IdleTimer+InternalTimer.swift
//
// Copyright © 2019 Xcore
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
