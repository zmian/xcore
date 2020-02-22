//
// IdleTimer.swift
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
