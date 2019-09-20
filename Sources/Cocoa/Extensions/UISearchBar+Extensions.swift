//
// UISearchBar+Extensions.swift
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

extension UISearchBar {
    open var textField: UITextField? {
        return firstSubview(withClass: UITextField.self)
    }

    @objc dynamic open var searchFieldBackgroundColor: UIColor? {
        get {
            switch searchBarStyle {
                case .minimal:
                    return textField?.layer.backgroundColor?.uiColor
                default:
                    return textField?.backgroundColor
            }
        }
        set {
            guard let newValue = newValue else { return }

            switch searchBarStyle {
                case .minimal:
                    textField?.layer.backgroundColor = newValue.cgColor
                    textField?.clipsToBounds = true
                    textField?.layer.cornerRadius = 8
                default:
                    textField?.backgroundColor = newValue
            }
        }
    }
}

extension UISearchBar {
    private struct AssociatedKey {
        static var placeholderTextColor = "placeholderTextColor"
        static var initialPlaceholderText = "initialPlaceholderText"
        static var didSetInitialPlaceholderText = "didSetInitialPlaceholderText"
    }

    /// The default value is `nil`. Uses `UISearchBar` default gray color.
    @objc dynamic open var placeholderTextColor: UIColor? {
        /// Unfortunately, when the `searchBarStyle == .minimal` then
        /// `textField?.placeholderLabel?.textColor` doesn't work. Hence, this workaround.
        get { return associatedObject(&AssociatedKey.placeholderTextColor) }
        set {
            setAssociatedObject(&AssociatedKey.placeholderTextColor, value: newValue)

            // Redraw placeholder text on color change
            let placeholderText = placeholder
            placeholder = placeholderText
        }
    }

    private var didSetInitialPlaceholderText: Bool {
        get { return associatedObject(&AssociatedKey.didSetInitialPlaceholderText, default: false) }
        set { setAssociatedObject(&AssociatedKey.didSetInitialPlaceholderText, value: newValue) }
    }

    private var initialPlaceholderText: String? {
        get { return associatedObject(&AssociatedKey.initialPlaceholderText) }
        set { setAssociatedObject(&AssociatedKey.initialPlaceholderText, value: newValue) }
    }

    @objc private var swizzled_placeholder: String? {
        get { return textField?.attributedPlaceholder?.string }
        set {
            if superview == nil, let newValue = newValue {
                initialPlaceholderText = newValue
                return
            }

            guard let textField = textField else {
                return
            }

            guard let newValue = newValue else {
                textField.attributedPlaceholder = nil
                return
            }

            if let placeholderTextColor = placeholderTextColor {
                textField.attributedPlaceholder = NSAttributedString(string: newValue, attributes: [
                    .foregroundColor: placeholderTextColor
                ])
            } else {
                textField.attributedPlaceholder = NSAttributedString(string: newValue)
            }
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()
        guard superview != nil, !didSetInitialPlaceholderText else { return }

        if let placeholderText = initialPlaceholderText {
            placeholder = placeholderText
            initialPlaceholderText = nil
        }

        didSetInitialPlaceholderText = true
    }
}

// MARK: Swizzle

extension UISearchBar {
    static func runOnceSwapSelectors() {
        swizzle(
            UISearchBar.self,
            originalSelector: #selector(getter: UISearchBar.placeholder),
            swizzledSelector: #selector(getter: UISearchBar.swizzled_placeholder)
        )

        swizzle(
            UISearchBar.self,
            originalSelector: #selector(setter: UISearchBar.placeholder),
            swizzledSelector: #selector(setter: UISearchBar.swizzled_placeholder)
        )
    }
}
