//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration {
    /// An enumeration representing the postal address components.
    public enum AddressComponent: String, Sendable, Hashable {
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

extension TextFieldConfiguration<PassthroughTextFieldFormatter> {
    /// Creates a text field configuration for a specified address component.
    ///
    /// - Parameter component: The address component for the text field.
    /// - Returns: A configured `TextFieldConfiguration` instance for the specified
    ///   address component.
    public static func address(component: AddressComponent) -> Self {
        switch component {
            case .street: fullStreetAddress
            case .street1: streetAddressLine1
            case .street2: streetAddressLine2
            case .city: addressCity
            case .state: addressState
            case .postalCode: .postalCode
            case .country: .country
        }
    }

    /// Address
    private static var fullStreetAddress: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .fullStreetAddress
        )
    }

    /// Address
    private static var streetAddressLine1: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .streetAddressLine1
        )
    }

    /// Apt
    private static var streetAddressLine2: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .streetAddressLine2
        )
    }

    /// City
    private static var addressCity: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .addressCity
        )
    }

    /// State
    private static var addressState: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .addressState
        )
    }

    /// Postal Code
    private static var postalCode: Self {
        .init(
            id: #function,
            autocapitalization: .never,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: .postalCode,
            validation: .postalCode
        )
    }

    /// Country
    private static var country: Self {
        .init(
            id: #function,
            autocapitalization: .words,
            textContentType: .countryName
        )
    }
}
