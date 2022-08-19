//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct PhoneNumberStyle: Hashable, Codable {
    public let mask: String
    public let countryCode: Int
    public let length: Int

    public init(mask: String, countryCode: Int) {
        self.mask = mask
        self.countryCode = countryCode
        self.length = mask.count { $0 == "#" }
    }
}

extension PhoneNumberStyle {
    /// United States Phone Numbers
    ///
    /// 🇺🇸 +1 (800) 692-7753
    public static var us: Self {
        .init(mask: "🇺🇸 +# (###) ###-####", countryCode: 1)
    }

    /// Australia Phone Numbers
    ///
    /// 🇦🇺 +61 423 456 789
    public static var au: Self {
        .init(mask: "🇦🇺 +## ### ### ###", countryCode: 61)
    }
}

/// A formatter that converts between phone number and the textual
/// representation of it.
public struct PhoneNumberTextFieldFormatter: TextFieldFormatter {
    private let mask: MaskingTextFieldFormatter
    private let style: PhoneNumberStyle

    public init(style: PhoneNumberStyle) {
        self.mask = .init(style.mask)
        self.style = style
    }

    public func string(from value: String) -> String {
        value
    }

    public func value(from string: String) -> String {
        string
    }

    public func format(_ string: String) -> String? {
        var string = string

        // Remove country code that maybe have been added via iOS autocomplete
        string = string.count > style.length && string.hasPrefix(countryCode) ? string.droppingPrefix(countryCode) : string

        // Add country code
        if !string.isEmpty, !string.starts(with: countryCode) {
            string = countryCode + string
        }

        return mask.format(string)
    }

    public func unformat(_ string: String) -> String {
        mask.unformat(string)
    }

    private var countryCode: String {
        String(describing: style.countryCode)
    }
}
