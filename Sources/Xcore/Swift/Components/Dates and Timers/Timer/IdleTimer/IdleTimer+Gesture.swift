//
// Xcore
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
    private final class Gesture: UIGestureRecognizer {
        private let onTouchesEnded: () -> Void

        init(onTouchesEnded: @escaping () -> Void) {
            self.onTouchesEnded = onTouchesEnded
            super.init(target: nil, action: nil)
            cancelsTouchesInView = false
        }

        override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
            onTouchesEnded()
            state = .failed
            super.touchesEnded(touches, with: event)
        }
    }
}

// MARK: - Windows

extension IdleTimer {
    final class WindowContainer {
        private let timer: InternalTimer

        /// The timeout duration in seconds, after which idle timer notification is
        /// posted.
        var timeoutDuration: TimeInterval {
            get { timer.timeoutDuration }
            set { timer.timeoutDuration = newValue }
        }

        init() {
            timer = .init(timeoutAfter: 0) {
                NotificationCenter.default.post(name: UIApplication.didTimeOutUserInteractionNotification, object: nil)
            }
        }

        func add(_ window: UIWindow) {
            if window.gestureRecognizers?.firstElement(type: IdleTimer.Gesture.self) != nil {
                // Return we already have the gesture added to the given window.
                return
            }

            let newGesture = Gesture { [weak self] in
                self?.timer.wake()
            }
            window.addGestureRecognizer(newGesture)
        }
    }
}
