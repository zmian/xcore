//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension PostalAddress {
    /// A dictionary containing every country code and its localized name.
    ///
    /// For Example:
    ///
    /// ```swift
    /// [
    ///     "PT": "Portugal",
    ///     "GB": "United Kingdom",
    ///     "US": "United States"
    /// ]
    /// ```
    private static var countries: [String: String] = {
        var result = [String: String]()
        Locale.isoRegionCodes.forEach { isoCode in
            result[isoCode] = Locale.usPosix.localizedString(forRegionCode: isoCode)
        }
        return result
    }()

    /// Returns the list of country codes sorted by their name.
    ///
    /// For instance, "Portugal" (PT) will appear before "United Kingdom" (GB).
    public static var countryCodes: [String] {
        countries
            .sorted { $0.value < $1.value }
            .map(\.key)
    }

    /// Returns a locale-aware string representation of the given country code.
    public static func countryName(isoCode: String) -> String? {
        countries[isoCode]
    }

    /// Returns a locale-aware string representation of the country code of the
    /// address (e.g., "United States").
    public var country: String {
        Self.countryName(isoCode: countryCode) ?? ""
    }
}
