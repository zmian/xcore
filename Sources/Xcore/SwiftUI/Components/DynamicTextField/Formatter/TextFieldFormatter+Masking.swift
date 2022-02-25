//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that allows masking.
public struct MaskingTextFieldFormatter: TextFieldFormatter {
    private let maskFormat: String
    private let formattingCharacters: String

    public init(_ maskFormat: String) {
        self.maskFormat = maskFormat
        let characters = String(maskFormat.replacing("#", with: "").uniqued())
        self.formattingCharacters = "[\(characters)]+"
    }

    public func transformToString(_ value: String) -> String {
        value
    }

    public func transformToValue(_ string: String) -> String {
        string
    }

    public func displayValue(from string: String) -> String {
        let sanitizedValue = string.components(separatedBy: .decimalDigits.inverted).joined()
        let mask = maskFormat
        var index = sanitizedValue.startIndex
        var result = ""

        for character in mask where index < sanitizedValue.endIndex {
            if character == "#" {
                result.append(sanitizedValue[index])
                index = sanitizedValue.index(after: index)
            } else {
                result.append(character)
            }
        }

        return result
    }

    public func sanitizeDisplayValue(from string: String) -> String {
        string.replacing(formattingCharacters, with: "")
    }

    public func shouldChange(to string: String) -> Bool {
        // `displayValue` method enforces the correct length.
        true
    }
}
