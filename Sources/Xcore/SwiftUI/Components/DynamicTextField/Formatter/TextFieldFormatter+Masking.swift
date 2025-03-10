//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Formats an input string by applying the mask, replacing placeholder
/// characters with the input text.
///
/// This formatter can be applied to any type of string input using a
/// placeholder character (default `"X"`).
///
/// **Usage**
///
/// ```swift
/// // Number
/// let numberFormatter = MaskingTextFieldFormatter("###-##-####", placeholderCharacter: "#")
/// numberFormatter.format("123456789") // "123-45-6789"
///
/// // Alphabetic
/// let alphaFormatter = MaskingTextFieldFormatter("XX-XXXX")
/// alphaFormatter.format("ABCDEF") // "AB-CDEF"
///
/// // USA Phone Numbers
/// let usPhoneNumberFormatter = MaskingTextFieldFormatter("🇺🇸 +# (###) ###-####", placeholderCharacter: "#")
/// usPhoneNumberFormatter.format("18006927753") // "🇺🇸 +1 (800) 692-7753"
///
/// // Australian Phone Numbers
/// let auPhoneNumberFormatter = MaskingTextFieldFormatter("🇦🇺 +## ### ### ###", placeholderCharacter: "#")
/// auPhoneNumberFormatter.format("61423456789") // "🇦🇺 +61 423 456 789"
public struct MaskingTextFieldFormatter: TextFieldFormatter {
    private let maskFormat: String
    private let placeholderCharacter: Character
    private let formattingCharacters: String

    /// Creates a formatter with a given mask.
    ///
    /// - Parameters:
    ///   - maskFormat: The format mask string where the placeholder character
    ///     represents the position of input characters.
    ///   - placeholderCharacter: The character used as a placeholder in the mask
    ///     format.
    public init(_ maskFormat: String, placeholderCharacter: Character = "X") {
        self.maskFormat = maskFormat
        self.placeholderCharacter = placeholderCharacter
        let characters = String(maskFormat.replacing(String(placeholderCharacter), with: "").uniqued())
        self.formattingCharacters = "[\(characters)]+"
    }

    public func string(from value: String) -> String {
        value
    }

    public func value(from string: String) -> String {
        string
    }

    public func format(_ string: String) -> String? {
        let sanitizedValue = unformat(string)

        var result = ""
        var index = sanitizedValue.startIndex

        for character in maskFormat where index < sanitizedValue.endIndex {
            if character == placeholderCharacter {
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
