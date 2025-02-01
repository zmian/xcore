//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Common Character Sets

extension CharacterSet {
    /// A character set containing English letters (uppercase and lowercase) and space.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let text = "Hello World"
    /// let isValid = text.unicodeScalars.allSatisfy { CharacterSet.lettersAndSpaces.contains($0) }
    /// print(isValid) // true
    /// ```
    public static let lettersAndSpaces = CharacterSet(
        charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    )

    /// A character set containing only decimal numbers (`0-9`).
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let text = "12345"
    /// let isValid = text.unicodeScalars.allSatisfy { CharacterSet.numbers.contains($0) }
    /// print(isValid) // true
    /// ```
    public static let numbers = CharacterSet(charactersIn: "0123456789")

    /// A character set containing decimal numbers (`0-9`) and a decimal point
    /// (`.`).
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let text = "123.45"
    /// let isValid = text.unicodeScalars.allSatisfy { CharacterSet.numbersWithDecimal.contains($0) }
    /// print(isValid) // true
    /// ```
    public static let numbersWithDecimal = CharacterSet(charactersIn: ".0123456789")
}

// MARK: - Character Set Utilities

extension CharacterSet {
    /// Returns a random string of a given length using characters from the
    /// `CharacterSet`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let randomString = CharacterSet.lettersAndSpaces.randomString(length: 8)
    /// print(randomString) // Example: "dTpZBgXr"
    /// ```
    ///
    /// - Parameter length: The length of the random string to generate.
    /// - Returns: A randomly generated string containing characters from the
    ///   `CharacterSet`.
    public func randomString(length: Int) -> String {
        let seed = characters()
        return String((0..<length).compactMap { _ in seed.randomElement() })
    }

    /// Returns the characters in the `CharacterSet` as an array.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let characters = CharacterSet.uppercaseLetters.characters()
    /// print(characters.count) // 1822
    /// print(characters) // ["A", "B", "C", ... "]
    /// ```
    ///
    /// - Returns: An array of `Character` values representing all characters in the
    ///   `CharacterSet`.
    /// - SeeAlso: https://stackoverflow.com/a/42895178
    public func characters() -> [Character] {
        // A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF
        // inclusive or U+E000 to U+10FFFF inclusive.
        codePoints().compactMap { UnicodeScalar($0) }.map { Character($0) }
    }

    /// Extracts the Unicode code points that belong to the `CharacterSet`.
    ///
    /// **Reference**
    /// - Apple Documentation: [NSCharacterSet.bitmapRepresentation](https://developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation)
    ///
    /// - Returns: An array of Unicode code points present in the `CharacterSet`.
    private func codePoints() -> [Int] {
        var result: [Int] = []
        var plane = 0

        // Loop through bitmap representation to extract valid Unicode scalars.
        for (i, byte) in bitmapRepresentation.enumerated() {
            let k = i % 0x2001
            if k == 0x2000 {
                // Plane index byte
                plane = Int(byte) << 13
                continue
            }
            let base = (plane + k) << 3
            for j in 0..<8 where byte & (1 << j) != 0 {
                result.append(base + j)
            }
        }
        return result
    }
}
