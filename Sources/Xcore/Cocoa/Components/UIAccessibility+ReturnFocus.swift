//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIAccessibility {
    public struct ReturnFocus {
        private var element: Any?

        public var isEmpty: Bool {
            element == nil
        }

        /// A method to store the last focused element, so later we can ask voice-over
        /// to return focus to it.
        ///
        /// - Parameter tappedElement: An element to store as the last focused element.
        ///             If `element` value is `nil`, then element that is currently
        ///             focused by the specified assistive technology is used instead.
        public mutating func update(_ tappedElement: Any? = nil) {
            guard let tappedElement = tappedElement else {
                self.element = UIAccessibility.focusedElement(using: .notificationVoiceOver)
                return
            }

            self.element = tappedElement
        }

        public mutating func focus() {
            UIAccessibility.post(notification: .layoutChanged, argument: element)
            element = nil
        }

        public mutating func reset() {
            UIAccessibility.post(notification: .screenChanged, argument: nil)
            element = nil
        }
    }
}

extension UIAccessibility {
    /// A variable indicating the last focused accessibility element.
    public static var lastFocusedElement = ReturnFocus()
}
