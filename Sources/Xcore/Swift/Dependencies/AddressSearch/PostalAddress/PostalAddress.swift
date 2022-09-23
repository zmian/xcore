//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
@_implementationOnly import Contacts

/// A structure representing a postal address.
public struct PostalAddress: Sendable, Hashable, Identifiable, CustomStringConvertible {
    /// The unique identifier of the address.
    public var id: String

    /// The street name of the address.
    public var street1: String

    /// The address line 2 is for the apartment, suite, unit number, or other
    /// address designation that is not part of the address.
    public var street2: String

    /// The city name of the address.
    public var city: String

    /// The state code or name of the address (e.g., "NY").
    public var state: String

    /// The postal code of the address.
    public var postalCode: String

    /// The ISO country code of the address (e.g., "US" or "GB").
    public var countryCode: String

    /// Creates an instance of a postal address from the given information.
    ///
    /// - Parameters:
    ///   - id: The unique identifier of the address.
    ///   - street1: The street name of the address.
    ///   - street2: The address line 2 is for the apartment, suite, unit number, or
    ///     other address designation that is not part of the address.
    ///   - city: The city name of the address.
    ///   - state: The state code or name of the address (e.g., "NY").
    ///   - postalCode: The postal code of the address.
    ///   - countryCode: The ISO country code of the address (e.g., "US" or "GB").
    public init(
        id: String = "",
        street1: String = "",
        street2: String = "",
        city: String = "",
        state: String = "",
        postalCode: String = "",
        countryCode: String = ""
    ) {
        self.id = id
        self.street1 = street1
        self.street2 = street2
        self.city = city
        self.state = Self.stateCode(from: state) ?? state
        self.postalCode = postalCode
        self.countryCode = countryCode
    }
}

// MARK: - Helpers

extension PostalAddress {
    /// Returns a locale-aware string representation by combining the postal address
    /// components into a multi-line mailing address.
    public var description: String {
        let address = CNMutablePostalAddress().apply {
            $0.street = [street1, street2].filter { !$0.isBlank }.joined(separator: "\n")
            $0.city = city
            $0.state = state
            $0.postalCode = postalCode
            $0.country = country
        }

        return CNPostalAddressFormatter()
            .string(from: address)
    }

    /// A Boolean property indicating whether all of the required address fields are
    /// not blank.
    public var isComplete: Bool {
        [street1, city, state, postalCode, country].allSatisfy {
            $0.validate(rule: .notBlank)
        }
    }

    /// A Boolean property indicating whether all of the required address fields are
    /// blank.
    public var isEmpty: Bool {
        [street1, city, state, postalCode, country].allSatisfy(\.isBlank)
    }
}

#if DEBUG

// MARK: - Sample

extension PostalAddress {
    /// Returns an address suitable to display in the previews and tests.
    public static var sample: Self {
        .init(
            street1: "One Apple Park Way",
            street2: "A",
            city: "Cupertino",
            state: "CA",
            postalCode: "95014",
            countryCode: "US"
        )
    }
}
#endif
