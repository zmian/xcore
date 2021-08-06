//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension CharacterSet {
    /// English letters (upper and lowercase) and space.
    public static let lettersAndSpaces = CharacterSet(
        charactersIn: " ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"
    )

    /// A character set containing the subset of characters from the category of
    /// Decimal Numbers.
    ///
    /// Informally, this set represent only the decimal values `0` through `9`.
    public static let numbers = CharacterSet(charactersIn: "0123456789")

    /// A character set containing the subset of characters from the category of
    /// Decimal Numbers.
    ///
    /// Informally, this set represent only the decimal values `0` through `9` and
    /// a decimal point.
    public static let numbersWithDecimal = CharacterSet(charactersIn: ".0123456789")
}

extension CharacterSet {
    /// Returns random string of given length using `CharacterSet` as the seed.
    public func randomString(length: Int) -> String {
        let seed = characters()
        return String((0..<length).map { _ in seed.randomElement()! })
    }

    /// Returns `CharacterSet` as an array of characters.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let characters = CharacterSet.uppercaseLetters.characters()
    /// print(characters.count) // 1822
    /// print(characters) // ["A", "B", "C", ... "]
    /// ```
    ///
    /// - SeeAlso: https://stackoverflow.com/a/42895178
    public func characters() -> [Character] {
        // A Unicode scalar is any Unicode code point in the range U+0000 to U+D7FF
        // inclusive or U+E000 to U+10FFFF inclusive.
        codePoints().compactMap { UnicodeScalar($0) }.map { Character($0) }
    }

    private func codePoints() -> [Int] {
        var result: [Int] = []
        var plane = 0
        // following documentation at https://developer.apple.com/documentation/foundation/nscharacterset/1417719-bitmaprepresentation
        for (i, w) in bitmapRepresentation.enumerated() {
            let k = i % 0x2001
            if k == 0x2000 {
                // Plane index byte
                plane = Int(w) << 13
                continue
            }
            let base = (plane + k) << 3
            for j in 0..<8 where w & 1 << j != 0 {
                result.append(base + j)
            }
        }
        return result
    }
}
