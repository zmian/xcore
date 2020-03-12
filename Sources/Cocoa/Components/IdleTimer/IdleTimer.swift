//
// IdleTimer.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

public enum IdleTimer { }

// MARK: - API

extension IdleTimer {
    /// Updates existing or creates a new timeout gesture for given `window` object.
    ///
    /// You can observe the timeout event using
    /// `UIApplication.didTimeOutUserInteractionNotification`.
    public static func setUserInteractionTimeout(duration: TimeInterval, for window: UIWindow?) {
        guard let existingGesture = window?.gestureRecognizers?.firstElement(type: IdleTimer.Gesture.self) else {
            let newGesture = IdleTimer.Gesture(timeoutAfter: duration)
            window?.addGestureRecognizer(newGesture)
            return
        }

        existingGesture.timeoutDuration = duration
    }
}
