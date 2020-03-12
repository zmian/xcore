//
// IdleTimer+Gesture.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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
