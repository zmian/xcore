//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    /// An enumeration representing postal address components.
    public enum AddressComponent: String {
        /// The street address in a postal address.
        case street

        /// The street name in a postal address.
        case street1

        /// The street line 2 is for the apartment, suite, unit number, or other address
        /// designation that is not part of the postal address.
        case street2

        /// The city name in a postal address.
        case city

        /// The state name in a postal address.
        case state

        /// The postal code in a postal address.
        case postalCode

        /// The country or region name in a postal address.
        case country
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
            case .country:
                return .country
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

    /// Country
    private static var country: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            autocorrection: .default,
            spellChecking: .default,
            keyboard: .default,
            textContentType: .countryName
        )
    }
}
