//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension PostalAddress {
    /// Returns the list of state codes sorted by their name.
    ///
    /// For instance, "Alabama" (AL) will appear before "Armed Forces America" (AA).
    public static var stateCodes: [String] {
        states
            .sorted { $0.value < $1.value }
            .map(\.key)
    }

    /// Returns a locale-aware string representation of the given state name.
    public static func stateCode(from name: String) -> String? {
        /// The `state` can either be a code (`NY`) or a name (`New York`) so we need to
        /// check if it's either (and if it is the latter convert to code); otherwise,
        /// default to empty string.
        if states.keys.contains(name) {
            return name
        } else {
            return states.first { $0.value == name }?.key
        }
    }

    /// Returns a locale-aware string representation of the given state code.
    public static func stateName(code: String) -> String? {
        states[code]
    }
}

// MARK: - Dictionary

extension PostalAddress {
    private static var states: [String: String] = [
        "AL": "Alabama",
        "AK": "Alaska",
        "AS": "American Samoa",
        "AZ": "Arizona",
        "AR": "Arkansas",
        "AA": "Armed Forces Americas",
        "AE": "Armed Forces Europe",
        "AP": "Armed Forces Pacific",
        "CA": "California",
        "CO": "Colorado",
        "CT": "Connecticut",
        "DE": "Delaware",
        "DC": "District of Columbia",
        "FL": "Florida",
        "GA": "Georgia",
        "GU": "Guam",
        "HI": "Hawaii",
        "ID": "Idaho",
        "IL": "Illinois",
        "IN": "Indiana",
        "IA": "Iowa",
        "KS": "Kansas",
        "KY": "Kentucky",
        "LA": "Louisiana",
        "ME": "Maine",
        "MD": "Maryland",
        "MA": "Massachusetts",
        "MI": "Michigan",
        "MN": "Minnesota",
        "MS": "Mississippi",
        "MO": "Missouri",
        "MT": "Montana",
        "NE": "Nebraska",
        "NV": "Nevada",
        "NH": "New Hampshire",
        "NJ": "New Jersey",
        "NM": "New Mexico",
        "NY": "New York",
        "NC": "North Carolina",
        "ND": "North Dakota",
        "MP": "Northern Mariana Islands",
        "OH": "Ohio",
        "OK": "Oklahoma",
        "OR": "Oregon",
        "PA": "Pennsylvania",
        "PR": "Puerto Rico",
        "RI": "Rhode Island",
        "SC": "South Carolina",
        "SD": "South Dakota",
        "TN": "Tennessee",
        "TX": "Texas",
        "UT": "Utah",
        "VT": "Vermont",
        "VI": "U.S. Virgin Islands",
        "VA": "Virginia",
        "WA": "Washington",
        "WV": "West Virginia",
        "WI": "Wisconsin",
        "WY": "Wyoming"
    ]
}
