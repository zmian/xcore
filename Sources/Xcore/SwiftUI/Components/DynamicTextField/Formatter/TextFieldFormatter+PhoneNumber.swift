//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that converts between phone number and the textual
/// representation of it.
public struct PhoneNumberTextFieldFormatter: TextFieldFormatter {
    private let mask: MaskingTextFieldFormatter
    private let countryCode: String
    private let length: Int?

    public init(countryCode: String, length: Int? = nil) {
        self.length = length
        self.countryCode = countryCode
        let digitsCount = String(repeating: "#", count: countryCode.count)
        self.mask = .init(("🇺🇸 +\(digitsCount) (###) ###-####"))
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

        if let length = length {
            // Remove country code
            string = string.count > length && string.hasPrefix(countryCode) ? string.droppingPrefix(countryCode) : string
        }

        // Add country code
        if !string.isEmpty, !string.starts(with: countryCode) {
            string = countryCode + string
        }

        return mask.displayValue(from: string)
    }

    public func sanitizeDisplayValue(from string: String) -> String {
        mask.sanitizeDisplayValue(from: string)
    }
}
