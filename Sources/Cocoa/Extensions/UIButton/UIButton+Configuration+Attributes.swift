//
// UIButton+Configuration+Attributes.swift
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

extension UIButton.Configuration {
    public struct Attributes {
        public var font: UIFont?
        public var tintColor: UIColor?
        public var textColor: UIColor?
        public var backgroundColor: UIColor?
        public var borderColor: UIColor?
        public var selectedColor: UIColor?
        public var disabledBackgroundColor: UIColor?
        public var cornerRadius: CGFloat?

        fileprivate static let empty = Attributes()
    }

    public struct AttributesStorage: MutableAppliable {
        private var storage: [Identifier: Attributes] = [:]

        init() {}

        /// Returns the attributes for the given identifier.
        ///
        /// - Parameter id: The identifier for which to return attributes.
        /// - Returns: The attributes for the identifier.
        public subscript(id: Identifier) -> Attributes {
            get { storage[id] ?? .empty }
            set { storage[id] = newValue }
        }
    }
}

// MARK: - Identifier<UIButton>

extension Identifier where Type: UIButton {
    private var base: Self {
        .base
    }

    private var attributes: UIButton.Configuration.Attributes {
        get { UIButton.defaultAppearance.configurationAttributes[.init(rawValue: rawValue)] }
        set { UIButton.defaultAppearance.configurationAttributes[.init(rawValue: rawValue)] = newValue }
    }

    private func attributes<Value>(_ keyPath: WritableKeyPath<UIButton.Configuration.Attributes, Value?>) -> Value? {
        guard let value = attributes[keyPath: keyPath] else {
            guard self != .base else {
                return nil
            }

            // Check base to see if we have anything set for given key path.
            return UIButton.defaultAppearance.configurationAttributes[.base][keyPath: keyPath]
        }

        return value
    }

    public var cornerRadius: CGFloat {
        get { attributes(\.cornerRadius) ?? AppConstants.cornerRadius }
        set { attributes.cornerRadius = newValue }
    }

    public func font(button: UIButton) -> UIFont {
        return attributes(\.font) ?? button.titleLabel?.font ?? .app(style: .body)
    }

    public func tintColor(button: UIButton) -> UIColor {
        guard let color = attributes(\.tintColor) else {
            return button.tintColor ?? .appTint
        }

        return color
    }

    public func textColor(button: UIButton) -> UIColor {
        guard let color = attributes(\.textColor) else {
            return tintColor(button: button)
        }

        return color
    }

    public func backgroundColor(button: UIButton) -> UIColor {
        guard let color = attributes(\.backgroundColor) else {
            return tintColor(button: button)
        }

        return color
    }

    public func disabledBackgroundColor(button: UIButton) -> UIColor {
        guard let color = attributes(\.disabledBackgroundColor) else {
            return .appBackgroundDisabled
        }

        return color
    }

    public func selectedColor(button: UIButton) -> UIColor {
        guard let color = attributes(\.selectedColor) else {
            return tintColor(button: button)
        }

        return color
    }

    public func borderColor(button: UIButton) -> UIColor {
        guard let color = attributes(\.borderColor) else {
            return tintColor(button: button)
        }

        return color
    }

    // MARK: - Lookup

    /// Returns whether the background color is explicitly set for this identifier.
    public var hasBackgroundColor: Bool {
        return attributes.backgroundColor != nil
    }

    /// Returns the background color if explicitly set for this identifier,
    /// otherwise, returns the `defaultValue`.
    public func backgroundColor(or defaultValue: @autoclosure () -> UIColor) -> UIColor {
        guard let color = attributes.backgroundColor else {
            return defaultValue()
        }

        return color
    }

    /// Returns the text color if it is explicitly set for this identifier.
    public var textColor: UIColor? {
        attributes.textColor
    }
}
