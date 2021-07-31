//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - BlockFormatStyle

extension String {
    /// A structure representing formatting of a string using a closure.
    public struct BlockFormatStyle {
        public let format: (String) -> String

        /// An initializer to format given input string.
        ///
        /// - Parameter format: A closure to format the input string.
        public init(_ format: @escaping (String) -> String) {
            self.format = format
        }
    }

    /// Returns the result of given formatting style applied to `self`.
    ///
    /// - Parameter style: The string formatting style.
    public func formatted(_ style: BlockFormatStyle) -> String {
        style.format(self)
    }
}

// MARK: - Masked

extension String.BlockFormatStyle {
    /// Automatically detects a valid email address and apply email masking.
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
    public static var masked: Self {
        masked()
    }

    /// Automatically detects a valid email address and apply email masking.
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

    /// Mask all except the first `n` characters.
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
    public static func maskedAllExcept(first maxLength: Int, count: MaskCharacterCount = .same, separator: String = "") -> Self {
        .init {
            $0.prefix(maxLength) + count.string(count: $0.count - maxLength, separator: separator, suffix: false)
        }
    }

    /// Mask all except the last `n` characters.
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
    public static func maskedAllExcept(last maxLength: Int, count: MaskCharacterCount = .same, separator: String = "") -> Self {
        .init {
            count.string(count: $0.count - maxLength, separator: separator, suffix: true) + $0.suffix(maxLength)
        }
    }

    /// Masked with account number formatting.
    ///
    /// ```swift
    /// print("0123456789".formatted(.maskedAccountNumber))
    /// // Prints "•••• 6789"
    /// ```
    public static var maskedAccountNumber: Self {
        maskedAllExcept(last: 4, count: .equal(4), separator: " ")
    }
}

// MARK: - MaskCharacterCount

extension String.BlockFormatStyle {
    public enum MaskCharacterCount {
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

            if suffix {
                return String(repeating: .mask, count: length) + separator
            } else {
                return separator + String(repeating: .mask, count: length)
            }
        }
    }
}
