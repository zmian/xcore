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

    public init(mask: String, countryCode: Int, length: Int) {
        self.mask = mask
        self.countryCode = countryCode
        self.length = length
    }
}

extension PhoneNumberStyle {
    /// `".us"`
    ///
    /// 🇺🇸 +1 (800) 692-7753
    public static var us: Self {
        .init(mask: ("🇺🇸 +# (###) ###-####"), countryCode: 1, length: 11)
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

    public func transformToString(_ value: String) -> String {
        // Remove the country code from the output.
        value.droppingPrefix(countryCode)
    }

    public func transformToValue(_ string: String) -> String {
        // Remove the country code from the output.
        string.droppingPrefix(countryCode)
    }

    public func displayValue(from string: String) -> String? {
        var string = string

        // Remove country code that maybe have been added via iOS autocomplete
        string = string.count > style.length && string.hasPrefix(countryCode) ? string.droppingPrefix(countryCode) : string

        // Add country code
        if !string.isEmpty, !string.starts(with: countryCode) {
            string = countryCode + string
        }

        return mask.displayValue(from: string)
    }

    public func sanitizeDisplayValue(from string: String) -> String {
        mask.sanitizeDisplayValue(from: string)
    }

    private var countryCode: String {
        String(describing: style.countryCode)
    }
}
