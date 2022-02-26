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

    private let numberFormatter = NumberFormatter().apply {
        $0.allowsFloats = false
        $0.numberStyle = .none
    }

    public func transformToString(_ value: Int?) -> String {
        guard let value = value else {
            return ""
        }

        // Remove the country code from the output.
        return numberFormatter.string(from: value)?.droppingPrefix(countryCode) ?? ""
    }

    public func transformToValue(_ string: String) -> Int? {
        // Remove the country code from the output.
        let string = string.droppingPrefix(countryCode)
        return numberFormatter.number(from: string)?.intValue
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
