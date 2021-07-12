//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UISearchBar {
    @objc open dynamic var searchTextFieldBackgroundColor: UIColor? {
        get {
            switch searchBarStyle {
                case .minimal:
                    return searchTextField.layer.backgroundColor?.uiColor
                default:
                    return searchTextField.backgroundColor
            }
        }
        set {
            guard let newValue = newValue else {
                return
            }

            switch searchBarStyle {
                case .minimal:
                    searchTextField.layer.backgroundColor = newValue.cgColor
                    searchTextField.clipsToBounds = true
                    searchTextField.layer.cornerRadius = 8
                default:
                    searchTextField.backgroundColor = newValue
            }
        }
    }
}

extension UISearchBar {
    private enum AssociatedKey {
        static var placeholderTextColor = "placeholderTextColor"
        static var initialPlaceholderText = "initialPlaceholderText"
        static var didSetInitialPlaceholderText = "didSetInitialPlaceholderText"
    }

    /// The default value is `nil`. Uses `UISearchBar` default gray color.
    @objc open dynamic var placeholderTextColor: UIColor? {
        /// Unfortunately, when the `searchBarStyle == .minimal` then
        /// `textField?.placeholderLabel?.textColor` doesn't work. Hence, this workaround.
        get { associatedObject(&AssociatedKey.placeholderTextColor) }
        set {
            setAssociatedObject(&AssociatedKey.placeholderTextColor, value: newValue)

            // Redraw placeholder text on color change
            let placeholderText = placeholder
            placeholder = placeholderText
        }
    }

    private var didSetInitialPlaceholderText: Bool {
        get { associatedObject(&AssociatedKey.didSetInitialPlaceholderText, default: false) }
        set { setAssociatedObject(&AssociatedKey.didSetInitialPlaceholderText, value: newValue) }
    }

    private var initialPlaceholderText: String? {
        get { associatedObject(&AssociatedKey.initialPlaceholderText) }
        set { setAssociatedObject(&AssociatedKey.initialPlaceholderText, value: newValue) }
    }

    @objc private var swizzled_placeholder: String? {
        get { searchTextField.attributedPlaceholder?.string }
        set {
            if superview == nil, let newValue = newValue {
                initialPlaceholderText = newValue
                return
            }

            guard let newValue = newValue else {
                searchTextField.attributedPlaceholder = nil
                return
            }

            if let placeholderTextColor = placeholderTextColor {
                searchTextField.attributedPlaceholder = NSAttributedString(string: newValue, attributes: [
                    .foregroundColor: placeholderTextColor
                ])
            } else {
                searchTextField.attributedPlaceholder = NSAttributedString(string: newValue)
            }
        }
    }

    open override func didMoveToSuperview() {
        super.didMoveToSuperview()

        guard superview != nil, !didSetInitialPlaceholderText else {
            return
        }

        if let placeholderText = initialPlaceholderText {
            placeholder = placeholderText
            initialPlaceholderText = nil
        }

        didSetInitialPlaceholderText = true
    }
}

// MARK: - Swizzle

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
