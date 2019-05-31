//
// KeyboardObservable.swift
//
// Copyright © 2016 Xcore
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

/// A protocol to observe keyboard frame changes.
///
/// # Example Usage:
///
/// ```swift
/// class MyViewController: UIViewController, KeyboardObservable {
///     func keyboardFrameDidChange(_ payload: KeyboardPayload) {
///         // handle keyboard frame changes
///         print(payload.height)
///     }
/// }
///
/// class MyView: UIView, KeyboardObservable {
///     func keyboardFrameDidChange(_ payload: KeyboardPayload) {
///         // handle keyboard frame changes
///         print(payload.height)
///     }
/// }
/// ```
public protocol KeyboardObservable {
    /// This method is invoked whenever keyboard is shown or hidden.
    ///
    /// Use this method to adjust your layout to accommodate keyboard frame changes.
    ///
    /// - Parameter payload: The payload associated with keyboard frame visibility
    ///                      changes notification.
    func keyboardFrameDidChange(_ payload: KeyboardPayload)
}

// MARK: KeyboardPayload

/// A struct to represent keyboard payload associated with keyboard frame
/// visibility changes notification.
public struct KeyboardPayload {
    /// The final height of the keyboard in the current orientation of the device.
    public var height: CGFloat {
        return frameEnd.origin.y == UIScreen.main.bounds.height ? 0 : frameEnd.height
    }

    /// The starting frame rectangle of the keyboard in screen coordinates. The
    /// frame rectangle reflects the current orientation of the device.
    public let frameBegin: CGRect

    /// The ending frame rectangle of the keyboard in screen coordinates. The frame
    /// rectangle reflects the current orientation of the device.
    public let frameEnd: CGRect

    /// The duration of the animation in seconds.
    public let animationDuration: Double

    /// The `UIView.AnimationCurve` that defines how the keyboard will be animated
    /// onto or off the screen.
    public let animationCurve: UIView.AnimationCurve

    /// A Boolean indicating whether the keyboard belongs to the current app.
    ///
    /// With multitasking on iPad, all visible apps are notified when the keyboard
    /// appears and disappears. The value of this key is true for the app that
    /// caused the keyboard to appear and false for any other apps.
    public let isLocal: Bool

    fileprivate init?(notification: Notification, willShow: Bool) {
        guard
            let userInfo = notification.userInfo,
            let frameBegin = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue,
            let frameEnd = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue,
            let animationCurveRawValue = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.intValue,
            let animationCurve = UIView.AnimationCurve(rawValue: animationCurveRawValue),
            let isLocal = (userInfo[UIResponder.keyboardIsLocalUserInfoKey] as? NSNumber)?.boolValue
        else {
            return nil
        }

        self.frameBegin = frameBegin
        self.frameEnd = frameEnd
        self.animationDuration = animationDuration
        self.animationCurve = animationCurve
        self.isLocal = isLocal
    }
}

extension KeyboardPayload: CustomDebugStringConvertible {
    public var debugDescription: String {
        return """
        frameBegin:        \(frameBegin)
        frameEnd:          \(frameEnd)
        animationDuration: \(animationDuration)
        animationCurve:    \(animationCurve.rawValue)
        isLocal:           \(isLocal)
        """
    }
}

// MARK: - UIViewController+Keyboard

extension UIViewController {
    /// This method automatically registers keyboard notification observers for any
    /// view controller that conforms to `KeyboardObservable` using `viewWillAppear`
    /// method swizzling. Registering notifications in `viewDidLoad` results in
    /// unexpected keyboard behavior: when leveraging
    /// `interactivePopGestureRecognizer` to swipe back while the keyboard is
    /// presented, keyboard will not dismiss in concurrent with the popping progress.
    func _addKeyboardNotificationObservers() {
        // Only add the keyboard notification observers if self conforms to `KeyboardObservable`.
        guard (self as? KeyboardObservable) != nil else {
            return
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    /// This method automatically deregisters keyboard notification observers for
    /// any view controller that conforms to `KeyboardObservable` using
    /// `viewWillDisappear` method swizzling.
    func _removeKeyboardNotificationObservers() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        internalKeyboardFrameDidChange(notification, willShow: true)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        internalKeyboardFrameDidChange(notification, willShow: false)
    }

    private func internalKeyboardFrameDidChange(_ notification: Notification, willShow: Bool) {
        // `firstResponder != nil` check ensures that we are not dispatching keyboard
        // frame change events to any previous screen on swipe back when the keyboard
        // is active.
        guard
            isViewLoaded,
            let observable = self as? KeyboardObservable,
            view.firstResponder != nil,
            let payload = KeyboardPayload(notification: notification, willShow: willShow)
        else {
            return
        }

        observable.keyboardFrameDidChange(payload)
        view.layoutIfNeeded()
    }
}

// MARK: - UIView+Keyboard

extension UIView {
    /// This method automatically registers keyboard notification observers for any
    /// view that conforms to `KeyboardObservable` using `layoutSubviews` method
    /// swizzling.
    func _addKeyboardNotificationObservers() {
        // Only add the keyboard notification observers if self conforms to `KeyboardObservable`.
        guard (self as? KeyboardObservable) != nil else {
            return
        }

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(_:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(_:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }

    @objc private func keyboardWillShow(_ notification: Notification) {
        internalKeyboardFrameDidChange(notification, willShow: true)
    }

    @objc private func keyboardWillHide(_ notification: Notification) {
        internalKeyboardFrameDidChange(notification, willShow: false)
    }

    private func internalKeyboardFrameDidChange(_ notification: Notification, willShow: Bool) {
        // `firstResponder != nil` check ensures that we are not dispatching keyboard
        // frame change events to any previous screen on swipe back when the keyboard
        // is active.
        guard
            let observable = self as? KeyboardObservable,
            firstResponder != nil,
            let payload = KeyboardPayload(notification: notification, willShow: willShow)
        else {
            return
        }

        observable.keyboardFrameDidChange(payload)
        layoutIfNeeded()
    }
}

extension UIView {
    fileprivate var firstResponder: UIView? {
        guard !isFirstResponder else {
            return self
        }

        for subview in subviews {
            if let firstResponder = subview.firstResponder {
                return firstResponder
            }
        }

        return nil
    }
}
