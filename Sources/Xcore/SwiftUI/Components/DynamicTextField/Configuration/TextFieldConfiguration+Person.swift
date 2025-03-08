//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    /// An enumeration representing the components of a person's name.
    public enum PersonNameComponent: String, Sendable, Hashable {
        /// Represents the full name component (e.g., "John Appleseed").
        case fullName

        /// Represents the given name component, typically the first name.
        case givenName

        /// Represents the middle name component.
        case middleName

        /// Represents the family name component, typically the last name.
        case familyName
    }
}

// MARK: - Person Components

extension TextFieldConfiguration<PassthroughTextFieldFormatter> {
    /// Creates a text field configuration tailored to a specific component of a
    /// person's name.
    ///
    /// - Parameter component: The person name component for the text field.
    /// - Returns: A configured `TextFieldConfiguration` instance for the specified
    ///   component.
    public static func person(component: PersonNameComponent) -> Self {
        switch component {
            case .fullName: fullName
            case .givenName: givenName
            case .middleName: middleName
            case .familyName: familyName
        }
    }

    /// A text field configuration for entering a person's full name.
    private static var fullName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .name
        )
    }

    /// A text field configuration for entering a person's given (first) name.
    private static var givenName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .givenName
        )
    }

    /// A text field configuration for entering a person's middle name.
    private static var middleName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .middleName
        )
    }

    /// A text field configuration for entering a person's family (last) name.
    private static var familyName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .familyName
        )
    }
}
