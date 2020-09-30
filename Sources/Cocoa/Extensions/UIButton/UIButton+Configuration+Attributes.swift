//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
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

        init() { }

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
        attributes(\.font) ?? button.titleLabel?.font ?? .app(.body)
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
        attributes.backgroundColor != nil
    }

    /// Returns the background color if explicitly set for this identifier,
    /// otherwise, returns the `defaultValue`.
    public func backgroundColor(or defaultValue: @autoclosure () -> UIColor) -> UIColor {
        attributes.backgroundColor ?? defaultValue()
    }

    /// Returns the text color if it is explicitly set for this identifier.
    public var textColor: UIColor? {
        attributes.textColor
    }
}
