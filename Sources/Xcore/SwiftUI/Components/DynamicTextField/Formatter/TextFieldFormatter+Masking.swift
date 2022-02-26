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

    public func string(from value: String) -> String {
        value
    }

    public func value(from string: String) -> String {
        string
    }

    public func format(_ string: String) -> String? {
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

    public func unformat(_ string: String) -> String {
        string.replacing(formattingCharacters, with: "")
    }
}
