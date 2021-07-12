//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITextField {
    open var placeholderLabel: UILabel? {
        value(forKey: "_placeholderLabel") as? UILabel
    }
}

extension UITextField {
    // Fixes text jumping
    open override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        layoutIfNeeded()
        return resigned
    }
}

extension UITextField {
    private enum AssociatedKey {
        static var contentInset = "contentInset"
        static var isInsertionCursorEnabled = "isInsertionCursorEnabled"
    }

    /// The default value is `0`.
    open var contentInset: UIEdgeInsets {
        get { associatedObject(&AssociatedKey.contentInset, default: 0) }
        set { setAssociatedObject(&AssociatedKey.contentInset, value: newValue) }
    }

    /// The default value is `true`.
    open var isInsertionCursorEnabled: Bool {
        get { associatedObject(&AssociatedKey.isInsertionCursorEnabled, default: true) }
        set { setAssociatedObject(&AssociatedKey.isInsertionCursorEnabled, value: newValue) }
    }
}

// MARK: - Swizzle

extension UITextField {
    static func runOnceSwapSelectors() {
        swizzle(
            UITextField.self,
            originalSelector: #selector(UITextField.textRect(forBounds:)),
            swizzledSelector: #selector(UITextField.swizzled_textRect(forBounds:))
        )

        swizzle(
            UITextField.self,
            originalSelector: #selector(UITextField.editingRect(forBounds:)),
            swizzledSelector: #selector(UITextField.swizzled_editingRect(forBounds:))
        )

        swizzle(
            UITextField.self,
            originalSelector: #selector(UITextField.caretRect(for:)),
            swizzledSelector: #selector(UITextField.swizzled_caretRect(for:))
        )
    }

    //  Add support for content inset

    @objc
    private func swizzled_textRect(forBounds bounds: CGRect) -> CGRect {
        swizzled_textRect(forBounds: bounds.inset(by: contentInset))
    }

    @objc
    private func swizzled_editingRect(forBounds bounds: CGRect) -> CGRect {
        swizzled_editingRect(forBounds: bounds.inset(by: contentInset))
    }

    // Add support for disabling insertion cursor

    @objc
    private func swizzled_caretRect(for position: UITextPosition) -> CGRect {
        guard isInsertionCursorEnabled else {
            return .zero
        }

        return swizzled_caretRect(for: position)
    }
}
