//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    public enum PersonNameComponent: String, Sendable, Hashable {
        case fullName
        case givenName
        case middleName
        case familyName
    }
}

// MARK: - Person Components

extension TextFieldConfiguration<PassthroughTextFieldFormatter> {
    public static func person(component: PersonNameComponent) -> Self {
        switch component {
            case .fullName: fullName
            case .givenName: givenName
            case .middleName: middleName
            case .familyName: familyName
        }
    }

    /// A property that defines the content in a text input area as a full name.
    private static var fullName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .name
        )
    }

    /// A property that defines the content in a text input area as a given name,
    /// or first name.
    private static var givenName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .givenName
        )
    }

    /// A property that defines the content in a text input area as a middle name.
    private static var middleName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .middleName
        )
    }

    /// A property that defines the content in a text input area as a family name,
    /// or last name.
    private static var familyName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .familyName
        )
    }
}
