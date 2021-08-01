//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Locale {
    /// Returns `en_US` locale.
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
    /// - SeeAlso: https://developer.apple.com/library/archive/qa/qa1480/_index.html
    public static let us = Locale(identifier: "en_US")

    /// Returns `en_US_POSIX` locale.
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
    /// - SeeAlso: https://developer.apple.com/library/archive/qa/qa1480/_index.html
    public static let usPosix = Locale(identifier: "en_US_POSIX")

    /// Returns `en_GB` (English, United Kingdom) locale.
    public static let uk = Locale(identifier: "en_GB")
}

extension Locale {
    /// Returns `tr` (Turkish, Turkey) locale.
    public static let tr = Locale(identifier: "tr")

    /// Returns `es` (Spanish) locale.
    public static let es = Locale(identifier: "es")
}

extension Locale {
    public static func printAvailableIdentifiers() {
        print("Identifier,Description")
        availableIdentifiers.forEach {
            print("\"\($0)\",\"\(current.localizedString(forIdentifier: $0) ?? "")\"")
        }
    }
}
