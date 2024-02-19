//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    public enum PersonNameComponent: String, Sendable, Hashable {
        case fullName
        case firstName
        case middleName
        case lastName
    }
}

// MARK: - Person Components

extension TextFieldConfiguration<PassthroughTextFieldFormatter> {
    public static func person(component: PersonNameComponent) -> Self {
        switch component {
            case .fullName:
                return fullName
            case .firstName:
                return firstName
            case .middleName:
                return middleName
            case .lastName:
                return lastName
        }
    }

    /// Name
    private static var fullName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .name
        )
    }

    /// First Name
    private static var firstName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .givenName
        )
    }

    /// Last Name
    private static var lastName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .familyName
        )
    }

    /// Middle Name
    private static var middleName: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .middleName
        )
    }
}
