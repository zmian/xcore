//
// UIButton+StyleAttributes.swift
//
// Copyright © 2018 Zeeshan Mian
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

public struct StyleAttributes<Type> {
    public typealias Style = Identifier<Type>
    private var dictionary: [Style: [NSAttributedString.Key: Any]] = [:]

    init() {}

    /// Returns the attributes for the given style.
    ///
    /// - Parameter style: The style for which to return attributes.
    /// - Returns: The attributes for the styles.
    func attributes(for style: Style) -> [NSAttributedString.Key: Any] {
        return dictionary[style] ?? [:]
    }

    mutating func setAttribute(style: Style, key: NSAttributedString.Key, value: Any) {
        var attributes = self.attributes(for: style)
        attributes[key] = value
        dictionary[style] = attributes
    }
}

extension NSAttributedString.Key {
    public static let cornerRadius = NSAttributedString.Key(rawValue: "xcore.corner.radius")
}

// MARK: - Identifier<UIButton>

extension Identifier where Type: UIButton {
    private var attributes: [NSAttributedString.Key: Any] {
        let id = Identifier<UIButton>(rawValue: rawValue)
        return UIButton.defaultAppearance.styleAttributes.attributes(for: id)
    }

    private func setAttribute(key: NSAttributedString.Key, value: Any) {
        let id = Identifier<UIButton>(rawValue: rawValue)
        return UIButton.defaultAppearance.styleAttributes.setAttribute(style: id, key: key, value: value)
    }

    var cornerRadius: CGFloat {
        get { return attributes[.cornerRadius] as? CGFloat ?? AppConstants.cornerRadius }
        set { setAttribute(key: .cornerRadius, value: newValue) }
    }

    func font(button: UIButton) -> UIFont {
        return attributes[.font] as? UIFont ?? button.titleLabel?.font ?? .preferredFont(forTextStyle: .callout)
    }

    func textColor(button: UIButton) -> UIColor {
        guard let color = attributes[.foregroundColor] as? UIColor else {
            return button.tintColor ?? UIColor.systemTint
        }

        return color
    }

    func backgroundColor(button: UIButton) -> UIColor {
        guard let color = attributes[.backgroundColor] as? UIColor else {
            return button.tintColor ?? UIColor.systemTint
        }

        return color
    }
}

extension Identifier where Type: UIButton {
    func setFont(_ font: UIButton) {
        setAttribute(key: .font, value: font)
    }

    func textColor(_ textColor: UIColor) {
        setAttribute(key: .foregroundColor, value: textColor)
    }

    func backgroundColor(_ backgroundColor: UIColor) {
        setAttribute(key: .backgroundColor, value: backgroundColor)
    }
}
