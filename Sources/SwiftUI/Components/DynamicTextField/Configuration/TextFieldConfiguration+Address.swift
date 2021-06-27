//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    public enum AddressComponent: String {
        case street
        case street1
        case street2
        case city
        case state
        case postalCode
    }
}

// MARK: - Address Components

extension TextFieldConfiguration where Formatter == PassthroughTextFieldFormatter {
    public static func address(component: AddressComponent) -> Self {
        switch component {
            case .street:
                return fullStreetAddress
            case .street1:
                return streetAddressLine1
            case .street2:
                return streetAddressLine2
            case .city:
                return addressCity
            case .state:
                return addressState
            case .postalCode:
                return .postalCode
        }
    }

    /// Address
    private static var fullStreetAddress: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            autocorrection: .default,
            spellChecking: .default,
            keyboard: .default,
            textContentType: .fullStreetAddress
        )
    }

    /// Address
    private static var streetAddressLine1: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            autocorrection: .default,
            spellChecking: .default,
            keyboard: .default,
            textContentType: .streetAddressLine1
        )
    }

    /// Apt
    private static var streetAddressLine2: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            autocorrection: .default,
            spellChecking: .default,
            keyboard: .default,
            textContentType: .streetAddressLine2
        )
    }

    /// City
    private static var addressCity: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            autocorrection: .default,
            spellChecking: .default,
            keyboard: .default,
            textContentType: .addressCity
        )
    }

    /// State
    private static var addressState: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            autocorrection: .default,
            spellChecking: .default,
            keyboard: .default,
            textContentType: .addressState
        )
    }

    /// Postal Code
    private static var postalCode: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: .postalCode
        )
    }
}
