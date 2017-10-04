//
// XCTextField.swift
//
// Copyright © 2016 Zeeshan Mian
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

open class XCTextField: UITextField {
    /// The default value is `UIEdgeInsets.zero`.
    open var contentInset = UIEdgeInsets.zero
    /// The default value is `nil`. Uses `font`.
    open var placeholderFont: UIFont?
    /// The default value is `nil`. Uses `textColor`.
    open var placeholderTextColor: UIColor?

    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return super.textRect(forBounds: UIEdgeInsetsInsetRect(bounds, contentInset))
    }

    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return super.editingRect(forBounds: UIEdgeInsetsInsetRect(bounds, contentInset))
    }

    // Fixes text jumping
    open override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        layoutIfNeeded()
        return resigned
    }

    open override var placeholder: String? {
        get { return attributedPlaceholder?.string }
        set {
            guard let newValue = newValue else {
                attributedPlaceholder = nil
                return
            }

            attributedPlaceholder = NSAttributedString(string: newValue, attributes: [
                .foregroundColor: placeholderTextColor ?? textColor ?? UIColor.black,
                .font: placeholderFont ?? font ?? UIFont.systemFont(.body)
            ])
        }
    }
}
