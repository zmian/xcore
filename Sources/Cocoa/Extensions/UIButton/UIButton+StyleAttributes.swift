//
// UIButton+StyleAttributes.swift
//
// Copyright © 2018 Xcore
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

    public func style(_ style: Style) -> Style {
        return style
    }
}

extension NSAttributedString.Key {
    static var cornerRadius: NSAttributedString.Key {
        return NSAttributedString.Key(rawValue: "xcore.corner.radius")
    }

    static var borderColor: NSAttributedString.Key {
        return NSAttributedString.Key(rawValue: "xcore.border.color")
    }

    static var selectedColor: NSAttributedString.Key {
        return NSAttributedString.Key(rawValue: "xcore.selected.color")
    }

    static var tintColor: NSAttributedString.Key {
        return NSAttributedString.Key(rawValue: "xcore.tint.color")
    }

    static var disabledBackgroundColor: NSAttributedString.Key {
        return NSAttributedString.Key(rawValue: "xcore.background.disabled.color")
    }
}

extension UIButton {
    func style(_ style: Identifier<UIButton>) -> Identifier<UIButton> {
        return style
    }
}

// MARK: - Identifier<UIButton>

extension Identifier where Type: UIButton {
    private var attributesDictionary: [NSAttributedString.Key: Any] {
        let id = Identifier<UIButton>(rawValue: rawValue)
        return UIButton.defaultAppearance.styleAttributes.attributes(for: id)
    }

    private func setAttribute(key: NSAttributedString.Key, value: Any) {
        let id = Identifier<UIButton>(rawValue: rawValue)
        return UIButton.defaultAppearance.styleAttributes.setAttribute(style: id, key: key, value: value)
    }

    private func attributes(_ key: NSAttributedString.Key) -> Any? {
        guard let value = attributesDictionary[key] else {
            guard self != .base else {
                return nil
            }

            // Search base to see if we have anything set for given key.
            return UIButton.defaultAppearance.styleAttributes.attributes(for: .base)[key]
        }

        return value
    }

    private var base: Identifier<UIButton> {
        return .base
    }

    public var cornerRadius: CGFloat {
        get { return attributes(.cornerRadius) as? CGFloat ?? AppConstants.cornerRadius }
        set { setAttribute(key: .cornerRadius, value: newValue) }
    }

    public func font(button: UIButton) -> UIFont {
        return attributes(.font) as? UIFont ?? button.titleLabel?.font ?? .app(style: .body)
    }

    public func tintColor(button: UIButton) -> UIColor {
        guard let color = attributes(.tintColor) as? UIColor else {
            return button.tintColor ?? UIColor.appTint
        }

        return color
    }

    public func textColor(button: UIButton) -> UIColor {
        guard let color = attributes(.foregroundColor) as? UIColor else {
            return tintColor(button: button)
        }

        return color
    }

    public func backgroundColor(button: UIButton) -> UIColor {
        guard let color = attributes(.backgroundColor) as? UIColor else {
            return tintColor(button: button)
        }

        return color
    }

    public func disabledBackgroundColor(button: UIButton) -> UIColor {
        guard let color = attributes(.disabledBackgroundColor) as? UIColor else {
            return .appBackgroundDisabled
        }

        return color
    }

    public func selectedColor(button: UIButton) -> UIColor {
        guard let color = attributes(.selectedColor) as? UIColor else {
            return tintColor(button: button)
        }

        return color
    }

    public func borderColor(button: UIButton) -> UIColor {
        guard let color = attributes(.borderColor) as? UIColor else {
            return tintColor(button: button)
        }

        return color
    }

    // MARK: Lookup

    /// Returns whether the background color is explicitly set for this identifier.
    public var hasBackgroundColor: Bool {
        return (attributesDictionary[.backgroundColor] as? UIColor) != nil
    }

    /// Returns the background color if explicitly set for this identifier,
    /// otherwise, returns the `defaultValue`.
    public func backgroundColor(or defaultValue: @autoclosure () -> UIColor) -> UIColor {
        guard let color = attributesDictionary[.backgroundColor] as? UIColor else {
            return defaultValue()
        }

        return color
    }

    /// Returns the text color if it is explicitly set for this identifier.
    public var textColor: UIColor? {
        return attributesDictionary[.foregroundColor] as? UIColor
    }
}

extension Identifier where Type: UIButton {
    public func setFont(_ font: UIFont) {
        setAttribute(key: .font, value: font)
    }

    public func setTintColor(_ color: UIColor) {
        setAttribute(key: .tintColor, value: color)
    }

    public func setTextColor(_ color: UIColor) {
        setAttribute(key: .foregroundColor, value: color)
    }

    public func setBackgroundColor(_ color: UIColor) {
        setAttribute(key: .backgroundColor, value: color)
    }

    public func setBorderColor(_ color: UIColor) {
        setAttribute(key: .borderColor, value: color)
    }

    public func setSelectedColor(_ color: UIColor) {
        setAttribute(key: .selectedColor, value: color)
    }
}
