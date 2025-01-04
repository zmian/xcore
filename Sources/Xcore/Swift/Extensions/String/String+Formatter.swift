//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - BlockFormatStyle

extension String {
    /// A structure representing formatting of a string using a closure.
    ///
    /// This structure encapsulates a closure that applies a specific format to an
    /// input string, enabling custom formatting logic to be reused conveniently.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let uppercaseStyle = String.BlockFormatStyle { $0.uppercased() }
    /// print("hello".formatted(uppercaseStyle))
    /// // Prints "HELLO"
    /// ```
    public struct BlockFormatStyle {
        fileprivate let format: (String) -> String

        /// Creates an instance to format a given input string.
        ///
        /// - Parameter format: A closure defining how to format the input string.
        public init(_ format: @escaping (String) -> String) {
            self.format = format
        }
    }

    /// Applies the given formatting style to the string.
    ///
    /// - Parameter style: The string formatting style.
    /// - Returns: A new string with the formatting applied.
    public func formatted(_ style: BlockFormatStyle) -> String {
        style.format(self)
    }
}

// MARK: - Masked

extension String.BlockFormatStyle {
    /// Masks an email address or string with a default masking style.
    ///
    /// For email addresses:
    /// - Masks all but the first character of the local part and retains the domain.
    ///
    /// For non-email strings:
    /// - Replaces all characters with mask symbols.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// print("hello@example.com".formatted(.masked))
    /// // Prints "h•••@example.com"
    ///
    /// print("hello@example.com".formatted(.masked(count: .same)))
    /// // Prints "h••••@example.com"
    ///
    /// print("Hello World".formatted(.masked))
    /// // Prints "•••••••••••"
    /// ```
    ///
    /// - Returns: A `BlockFormatStyle` instance configured to apply email or string
    ///   masking.
    public static var masked: Self {
        masked()
    }

    /// Masks an email address or string with a customizable masking style.
    ///
    /// If the input string is a valid email address, it masks all but the first
    /// character of the local part and retains the domain. For non-email strings,
    /// it replaces all characters with mask symbols.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// print("hello@example.com".formatted(.masked))
    /// // Prints "h•••@example.com"
    ///
    /// print("hello@example.com".formatted(.masked(count: .same)))
    /// // Prints "h••••@example.com"
    ///
    /// print("Hello World".formatted(.masked))
    /// // Prints "•••••••••••"
    /// ```
    ///
    /// - Parameter count: The `MaskCharacterCount` determining the number of mask
    ///   symbols to apply.
    /// - Returns: A `BlockFormatStyle` instance configured to apply email or string
    ///   masking.
    public static func masked(count: MaskCharacterCount? = nil) -> Self {
        .init {
            guard
                $0.validate(rule: .email),
                let firstIndex = $0.index(from: 1),
                let lastIndex = $0.lastIndex(of: "@")
            else {
                let length = (count ?? .same).length(basedOn: $0.count)
                return String(repeating: .mask, count: length)
            }

            var string = $0
            let range = firstIndex..<lastIndex
            let count = (count ?? .equal(3)).length(basedOn: $0.distance(from: range.lowerBound, to: range.upperBound))
            string.replaceSubrange(range, with: String(repeating: .mask, count: count))
            return string
        }
    }

    /// Masks all characters except the first `n` characters in the string.
    ///
    /// This method keeps the first `n` characters of the input string visible and
    /// replaces the remaining characters with a specified number of mask symbols.
    /// You can optionally add a separator between the visible and masked parts.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// print("0123456789".formatted(.maskedAllExcept(first: 4))
    /// // Prints "0123••••••"
    ///
    /// print("0123456789".formatted(.maskedAllExcept(first: 4, separator: " ")))
    /// // Prints "0123 ••••••"
    ///
    /// print("0123456789".formatted(.maskedAllExcept(first: 4, count: .equal(4), separator: " ")))
    /// // Prints "0123 ••••"
    /// ```
    ///
    /// - Parameters:
    ///   - maxLength: The number of characters to leave unmasked at the start of the
    ///     string.
    ///   - count: The `MaskCharacterCount` specifying the length of the mask.
    ///   - separator: A string to insert between the visible and masked parts.
    /// - Returns: A `BlockFormatStyle` instance configured to mask the string
    ///   accordingly.
    public static func maskedAllExcept(first maxLength: Int, count: MaskCharacterCount = .same, separator: String = "") -> Self {
        .init { input in
            let visible = input.prefix(maxLength)
            let masked = count.string(count: input.count - maxLength, separator: separator, suffix: false)
            return visible + masked
        }
    }

    /// Masks all characters except the last `n` characters in the string.
    ///
    /// This method hides all but the last `n` characters in the string by replacing
    /// them with a specified number of mask symbols. You can optionally add a
    /// separator between the masked and visible parts.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// print("0123456789".formatted(.maskedAllExcept(last: 4))
    /// // Prints "••••••6789"
    ///
    /// print("0123456789".formatted(.maskedAllExcept(last: 4, separator: " ")))
    /// // Prints "•••••• 6789"
    ///
    /// print("0123456789".formatted(.maskedAllExcept(last: 4, count: .equal(4), separator: " ")))
    /// // Prints "•••• 6789"
    ///
    /// print("0123456789".formatted(.maskedAccountNumber))
    /// // Prints "•••• 6789"
    /// ```
    ///
    /// - Parameters:
    ///   - maxLength: The number of characters to leave unmasked at the end of the
    ///     string.
    ///   - count: The `MaskCharacterCount` specifying the length of the mask.
    ///   - separator: A string to insert between the masked and visible parts.
    /// - Returns: A `BlockFormatStyle` instance configured to mask the string
    ///   accordingly.
    public static func maskedAllExcept(last maxLength: Int, count: MaskCharacterCount = .same, separator: String = "") -> Self {
        .init { input in
            let masked = count.string(count: input.count - maxLength, separator: separator, suffix: true)
            let visible = input.suffix(maxLength)
            return masked + visible
        }
    }

    /// Masks all but the last four characters of the string in account number
    /// format.
    ///
    /// This method is specifically designed for formatting account numbers. It
    /// masks all but the last four characters and inserts a space separator between
    /// the masked and visible parts.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// print("0123456789".formatted(.maskedAccountNumber))
    /// // Prints "•••• 6789"
    /// ```
    ///
    /// - Returns: A `BlockFormatStyle` instance configured to mask the string as an
    ///   account number.
    public static var maskedAccountNumber: Self {
        maskedAllExcept(last: 4, count: .equal(4), separator: " ")
    }
}

// MARK: - MaskCharacterCount

extension String.BlockFormatStyle {
    /// An enumeration representing length of mask characters relative to the input
    /// string.
    public enum MaskCharacterCount: Sendable, Hashable {
        /// Mask characters length is same as the input string length.
        case same

        /// Mask characters length is greater than or equal to `n`.
        case min(Int)

        /// Mask characters length is less than or equal to `n`.
        case max(Int)

        /// Mask characters length is equal to `n`.
        case equal(Int)

        fileprivate func length(basedOn count: Int) -> Int {
            switch self {
                case .same:
                    return Swift.max(0, count)
                case let .min(value):
                    return Swift.max(value, count)
                case let .max(value):
                    return Swift.min(value, Swift.max(0, count))
                case let .equal(value):
                    return value
            }
        }

        fileprivate func string(count: Int, separator: String, suffix: Bool) -> String {
            let length = self.length(basedOn: count)

            if case .equal = self {} else if length == 0 {
                return ""
            }

            let mask = String(repeating: .mask, count: length)
            return suffix ? mask + separator : separator + mask
        }
    }
}
