//
// IdleTimer+Gesture.swift
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

// MARK: - Notification

extension UIApplication {
    /// Posted after the user interaction timeout.
    ///
    /// - See: `IdleTimer.setUserInteractionTimeout(duration:for:)`
    public static var didTimeOutUserInteractionNotification: Notification.Name {
        .init(#function)
    }
}

extension NotificationCenter.Event {
    /// Posted after the user interaction timeout.
    ///
    /// - See: `IdleTimer.setUserInteractionTimeout(duration:for:)`
    @discardableResult
    public func applicationDidTimeOutUserInteraction(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        observe(UIApplication.didTimeOutUserInteractionNotification, callback)
    }
}

// MARK: - Gesture

extension IdleTimer {
    final class Gesture: UIGestureRecognizer {
        private let timer: InternalTimer

        /// The timeout duration in seconds, after which idle timer notification is
        /// posted.
        var timeoutDuration: TimeInterval {
            get { timer.timeoutDuration }
            set { timer.timeoutDuration = newValue }
        }

        init(timeoutAfter duration: TimeInterval) {
            timer = .init(timeoutAfter: duration) {
                NotificationCenter.default.post(name: UIApplication.didTimeOutUserInteractionNotification, object: nil)
            }

            super.init(target: nil, action: nil)
            cancelsTouchesInView = false
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
            timer.wake()
            state = .failed
            super.touchesEnded(touches, with: event)
        }
    }
}
