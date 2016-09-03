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

public class XCTextField: UITextField {
    /// The default value is `UIEdgeInsets.zero`.
    public var edgeInsets = UIEdgeInsets.zero
    /// The default value is `nil`. Uses `font`.
    public var placeholderFont: UIFont?
    /// The default value is `nil`. Uses `textColor`.
    public var placeholderTextColor: UIColor?

    public override func textRectForBounds(bounds: CGRect) -> CGRect {
        return super.textRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets))
    }

    public override func editingRectForBounds(bounds: CGRect) -> CGRect {
        return super.editingRectForBounds(UIEdgeInsetsInsetRect(bounds, edgeInsets))
    }

    // Fixes text jumping
    public override func resignFirstResponder() -> Bool {
        let resigned = super.resignFirstResponder()
        layoutIfNeeded()
        return resigned
    }

    public override var placeholder: String? {
        get { return attributedPlaceholder?.string }
        set {
            guard let newValue = newValue else {
                attributedPlaceholder = nil
                return
            }

            attributedPlaceholder = NSAttributedString(string: newValue, attributes: [
                NSForegroundColorAttributeName: placeholderTextColor ?? textColor ?? UIColor.blackColor(),
                NSFontAttributeName: placeholderFont ?? font ?? UIFont.systemFont(.body)
            ])
        }
    }
}
