//
// UITextField+Extensions.swift
//
// Copyright © 2017 Xcore
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

extension UITextField {
    open var placeholderLabel: UILabel? {
        return value(forKey: "_placeholderLabel") as? UILabel
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
    private struct AssociatedKey {
        static var contentInset = "contentInset"
        static var isInsertionCursorEnabled = "isInsertionCursorEnabled"
    }

    /// The default value is `0`.
    open var contentInset: UIEdgeInsets {
        get { return associatedObject(&AssociatedKey.contentInset, default: 0) }
        set { setAssociatedObject(&AssociatedKey.contentInset, value: newValue) }
    }

    /// The default value is `true`.
    open var isInsertionCursorEnabled: Bool {
        get { return associatedObject(&AssociatedKey.isInsertionCursorEnabled, default: true) }
        set { setAssociatedObject(&AssociatedKey.isInsertionCursorEnabled, value: newValue) }
    }
}

// MARK: Swizzle

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

    @objc private func swizzled_textRect(forBounds bounds: CGRect) -> CGRect {
        return swizzled_textRect(forBounds: bounds.inset(by: contentInset))
    }

    @objc private func swizzled_editingRect(forBounds bounds: CGRect) -> CGRect {
        return swizzled_editingRect(forBounds: bounds.inset(by: contentInset))
    }

    // Add support for disabling insertion cursor

    @objc private func swizzled_caretRect(for position: UITextPosition) -> CGRect {
        guard isInsertionCursorEnabled else {
            return .zero
        }

        return swizzled_caretRect(for: position)
    }
}
