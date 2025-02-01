//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Default Locale

extension Locale {
    /// The default locale used in ``CustomFloatingPointFormatStyle``.
    ///
    /// This locale determines the formatting behavior for custom number
    /// formatting styles. It defaults to `.current`, ensuring that numbers
    /// are formatted based on the user's active locale settings.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let locale = Locale.numbers
    /// print(locale.identifier) // Example: "en_US"
    /// ```
    nonisolated(unsafe) public static var numbers: Self = .current
}

// MARK: - Common Locales

extension Locale {
    /// Returns the `en_US` (English, United States) locale.
    ///
    /// **For DateFormatter:**
    ///
    /// In most cases the best locale to choose is `"en_US_POSIX"`, a locale that's
    /// specifically designed to yield US English results regardless of both user
    /// and system preferences. `"en_US_POSIX"` is also invariant in time (if the
    /// US, at some point in the future, changes the way it formats dates, `"en_US"`
    /// will change to reflect the new behaviour, but `"en_US_POSIX"` will not), and
    /// between machines (`"en_US_POSIX"` works the same on iOS as it does on
    /// mac OS, and as it it does on other platforms).
    ///
    /// **Summary:**
    ///
    /// - `"en_US"` adapts to US formatting standards and system updates.
    /// - Use `"en_US_POSIX"` for **fixed** formatting across platforms.
    ///
    /// - SeeAlso: [Apple's Locale Best Practices](https://developer.apple.com/library/archive/qa/qa1480/_index.html)
    public static let us = Locale(identifier: "en_US")

    /// Returns the `en_US_POSIX` (POSIX-compliant English, US) locale.
    ///
    /// This locale ensures consistent date and number formatting regardless of
    /// system or regional settings. Ideal for **parsing and serializing** dates
    /// where exact formatting is required.
    ///
    /// **For DateFormatter:**
    ///
    /// In most cases the best locale to choose is `"en_US_POSIX"`, a locale that's
    /// specifically designed to yield US English results regardless of both user
    /// and system preferences. `"en_US_POSIX"` is also invariant in time (if the
    /// US, at some point in the future, changes the way it formats dates, `"en_US"`
    /// will change to reflect the new behaviour, but `"en_US_POSIX"` will not), and
    /// between machines (`"en_US_POSIX"` works the same on iOS as it does on
    /// mac OS, and as it it does on other platforms).
    ///
    /// **Summary:**
    ///
    /// - `"en_US"` adapts to US formatting standards and system updates.
    /// - Use `"en_US_POSIX"` for **fixed** formatting across platforms.
    ///
    /// - SeeAlso: [Apple's Locale Best Practices](https://developer.apple.com/library/archive/qa/qa1480/_index.html)
    public static let usPosix = Locale(identifier: "en_US_POSIX")

    /// Returns the `en_GB` (English, United Kingdom) locale.
    public static let uk = Locale(identifier: "en_GB")

    /// Returns the `fr` (French) locale.
    public static let fr = Locale(identifier: "fr")

    /// Returns the `es` (Spanish) locale.
    public static let es = Locale(identifier: "es")

    /// Returns the `ar_SA` (Arabic, Saudi Arabia) locale.
    public static let ar = Locale(identifier: "ar_SA")

    /// Returns the `tr` (Turkish) locale.
    public static let tr = Locale(identifier: "tr")

    /// Returns the `de` (German) locale.
    public static let de = Locale(identifier: "de")

    /// Returns the `de_DE` (German, Germany) locale.
    public static let deDE = Locale(identifier: "de_DE")

    /// Returns the `pt_PT` (Portuguese, Portugal) locale.
    public static let ptPT = Locale(identifier: "pt_PT")
}

// MARK: - Currency Codes

extension Locale.Currency {
    /// United States Dollar (`USD`).
    public static let usd = Self("usd")

    /// British Pound Sterling (`GBP`).
    public static let gbp = Self("gbp")
}

// MARK: - Utility Methods

extension Locale {
    /// Prints all available locale identifiers along with their descriptions.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// Locale.printAvailableIdentifiers()
    /// ```
    ///
    /// Example Output:
    /// ```
    /// Identifier,Description
    /// "en_US","English (United States)"
    /// "fr_FR","French (France)"
    /// ```
    public static func printAvailableIdentifiers() {
        print("Identifier,Description")
        availableIdentifiers.forEach {
            print("\"\($0)\",\"\(current.localizedString(forIdentifier: $0) ?? "")\"")
        }
    }
}
