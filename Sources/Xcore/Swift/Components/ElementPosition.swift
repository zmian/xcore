//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing the different element positions.
///
/// This option set can be used to define the relative positioning of elements,
/// such as **primary**, **secondary**, **tertiary**, or **quaternary**
/// positions.
public struct ElementPosition: OptionSet, Sendable {
    public let rawValue: Int

    /// Creates a new element position with the given raw value.
    ///
    /// - Parameter rawValue: The raw integer value representing the element
    ///   position.
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Represents the element is in primary position.
    public static let primary = Self(rawValue: 1 << 0)
    /// Represents the element is in secondary position.
    public static let secondary = Self(rawValue: 1 << 1)
    /// Represents the element is in tertiary position.
    public static let tertiary = Self(rawValue: 1 << 2)
    /// Represents the element is in quaternary position.
    public static let quaternary = Self(rawValue: 1 << 3)
}

// MARK: - ButtonIdentifier

/// A tag type used to differentiate button identifier types.
///
/// This empty enumeration acts as a unique namespace for creating type-safe
/// identifiers for buttons.
public enum ButtonIdentifierTag: Sendable {}

/// A type-safe identifier for buttons.
///
/// Use this identifier to uniquely tag and distinguish between buttons within
/// your application.
public typealias ButtonIdentifier = Identifier<ButtonIdentifierTag>

extension ButtonIdentifier {
    /// A default identifier for a plain button.
    public static var plain: Self { #function }
    /// A default identifier for a filled button.
    public static var fill: Self { #function }
    /// A default identifier for an outlined button.
    public static var outline: Self { #function }
}

// MARK: - ButtonState

/// An enumeration representing the state of a button.
///
/// Use this type to specify the visual and interaction state of a button,
/// such as whether it is in its normal state, pressed, or disabled.
public enum ButtonState: Sendable, Hashable {
    /// The default, enabled state.
    case normal
    /// The state when the button is pressed.
    case pressed
    /// The state when the button is disabled.
    case disabled
}

// MARK: - ButtonProminence

/// An enumeration representing the visual prominence style of a button.
///
/// This type indicates whether a button should be rendered with a filled or
/// outlined style.
public enum ButtonProminence: Sendable, Hashable {
    /// A button rendered with a filled background.
    case fill
    /// A button rendered with an outlined border.
    case outline
}
