//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension ValidationRule {
    /// No validation rule is applied.
    public static var none: Self {
        .init { _ in true }
    }
}

// MARK: - Input: Collection

extension ValidationRule where Input: Collection {
    /// A validation rule that checks whether the input length is contained within
    /// the range expression.
    ///
    /// This validation rule can be used guard minimum or maximum length:
    ///
    /// ```swift
    /// let name = "Sam Swift"
    /// name.validate(rule: .length(1...)) // length >= 1
    ///
    /// let password = "***"
    /// password.validate(rule: .length(8...50)) // length between 8 - 50
    /// ```
    ///
    /// - Parameter length: The range expression to check against input length.
    /// - Returns: The validation rule.
    public static func length(_ length: some RangeExpression<Int> & Sendable) -> Self{
        .init { length.contains($0.count) }
    }

    /// A validation rule that checks whether the input length matches given length.
    ///
    /// ```swift
    /// let accountLastFour = 1234
    /// accountLastFour.validate(rule: .length(4))
    /// ```
    ///
    /// - Parameter length: The input length.
    /// - Returns: The validation rule.
    public static func length(_ length: Int) -> Self {
        .init { $0.count == length }
    }

    /// A validation rule that checks whether the input is not empty.
    ///
    /// - Returns: The validation rule.
    public static var notEmpty: Self {
        .init { !$0.isEmpty }
    }
}

// MARK: - Input: Equatable

extension ValidationRule where Input: Equatable & Sendable {
    /// A validation rule that checks whether the input is equal to the given
    /// value.
    ///
    /// - Parameter value: The value to compare against input.
    /// - Returns: The validation rule.
    public static func equals(_ value: Input) -> Self {
        .init { $0 == value }
    }
}

// MARK: - Input: Comparable

extension ValidationRule where Input: Comparable & Sendable {
    /// A validation rule that checks whether the input is less than the given
    /// value.
    ///
    /// - Parameter value: The value to compare against input.
    /// - Returns: The validation rule.
    public static func lessThan(_ value: Input) -> Self {
        .init { $0 < value }
    }

    /// A validation rule that checks whether the input is less than or equal to the
    /// given value.
    ///
    /// - Parameter value: The value to compare against input.
    /// - Returns: The validation rule.
    public static func lessThanOrEqual(_ value: Input) -> Self {
        .init { $0 <= value }
    }

    /// A validation rule that checks whether the input is greater than the given
    /// value.
    ///
    /// - Parameter value: The value to compare against input.
    /// - Returns: The validation rule.
    public static func greaterThan(_ value: Input) -> Self {
        .init { $0 > value }
    }

    /// A validation rule that checks whether the input is greater than or equal to
    /// the given value.
    ///
    /// - Parameter value: The value to compare against input.
    /// - Returns: The validation rule.
    public static func greaterThanOrEqual(_ value: Input) -> Self {
        .init { $0 >= value }
    }
}

// MARK: - Input: String

extension ValidationRule<String> {
    /// A validation rule that checks whether the input satisfy the given regex.
    ///
    /// - Parameter pattern: Regex pattern used to find matches in the input.
    /// - Returns: The validation rule.
    public static func regex(_ pattern: String) -> Self {
        .init { $0.isMatch(pattern) }
    }

    /// A validation rule using a regular expression to validate input.
    ///
    /// - Parameters:
    ///   - pattern: The regular expression pattern used to validate the input.
    /// - Returns: A `ValidationRule` instance.
    public static func regex<Output>(_ pattern: Regex<Output>) -> Self {
        nonisolated(unsafe) let pattern = pattern
        return .init { input in
            input.wholeMatch(of: pattern) != nil
        }
    }

    /// A validation rule that checks whether the input contains the given string.
    ///
    /// - Parameters:
    ///   - other: The other string to search for in the input string.
    ///   - options: The String `ComparisonOptions`. The default value `[]`.
    /// - Returns: The validation rule.
    public static func contains(_ other: some StringProtocol & Sendable, options: String.CompareOptions = []) -> Self {
        .init { $0.contains(other, options: options) }
    }

    /// A validation rule that checks whether the input begins with the specified
    /// prefix.
    ///
    /// - Parameter prefix: A possible prefix to test against this string.
    /// - Returns: The validation rule.
    static func hasPrefix(_ prefix: some StringProtocol & Sendable) -> Self {
        .init { $0.hasPrefix(prefix) }
    }

    /// A validation rule that checks whether the input ends with the specified
    /// suffix.
    ///
    /// - Parameter suffix: A possible suffix to test against this string.
    /// - Returns: The validation rule.
    static func hasSuffix(_ suffix: some StringProtocol & Sendable) -> Self {
        .init { $0.hasSuffix(suffix) }
    }

    /// A validation rule that checks whether the input is a subset of the given
    /// set.
    ///
    /// - Parameter other: The superset of the input.
    /// - Returns: The validation rule.
    public static func subset(of other: CharacterSet) -> Self {
        .init { input in
            let input = CharacterSet(charactersIn: input)
            return other.isSuperset(of: input)
        }
    }

    /// A validation rule that checks whether the input equals given set.
    ///
    /// - Parameter other: The character set of the input.
    /// - Returns: The validation rule.
    public static func equal(_ other: CharacterSet) -> Self {
        .init { other == CharacterSet(charactersIn: $0) }
    }
}

// MARK: - Regex Based Rules

extension ValidationRule<String> {
    /// A validation rule that checks whether the input is not blank.
    public static var notBlank: Self {
        .init { !$0.isBlank }
    }

    /// A validation rule that checks whether the input is a valid email address.
    public static var email: Self {
        "[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    }

    /// A validation rule that checks whether the input is a valid phone number with
    /// 11 character length.
    public static var phoneNumber: Self {
        .phoneNumber(length: PhoneNumberTextFieldFormatter.Style.us.length)
    }

    /// A validation rule that checks whether the input is a valid phone number.
    public static func phoneNumber(length: Int? = nil) -> Self {
        .init {
            let sanitizedNumber = $0.replacing("-", with: "")
            let isValidNumber = isValid(.phoneNumber).validate(sanitizedNumber)

            if let length {
                return isValidNumber && sanitizedNumber.count == length
            }

            return isValidNumber
        }
    }

    /// A validation rule that checks whether the input is a valid postal code.
    public static var postalCode: Self {
        .init(
            pattern: "(^\\d{5}$)|(^\\d{9}$)|(^\\d{5}-\\d{4}$)",
            transform: { $0.replacing("-", with: "") }
        )
    }

    /// A validation rule that checks whether the input contains "P.O. Box".
    public static var containsPoBox: Self {
        "(?i)^((.*)(((p|post)[-.\\s]*(o|off|office)[-.\\s]*(box|bin))|((p |post)[-.\\s]*(box|bin)))(.*))"
    }

    /// A validation rule that checks whether the input is a valid one-time code.
    public static var oneTimeCode: Self {
        number(length: FeatureFlag.oneTimeCodeCharacterLimit)
    }

    /// A validation rule for validating a person's name.
    ///
    /// Ensures the name is between `1` and `50` characters, excluding numeric
    /// characters.
    ///
    /// ```swift
    /// ValidationRule.name.validate("Sam Swift") // true
    /// ValidationRule.name.validate("Sam123")  // false
    /// ```
    public static var name: Self {
        alphabetic(length: 1...50)
    }

    /// A validation rule ensuring the input contains only alphabetic and non-digit
    /// characters, within a specified length.
    ///
    /// Use this rule to validate strings composed of letters and allowed non-digit
    /// characters, explicitly excluding numbers.
    ///
    /// ```swift
    /// ValidationRule.alphabetic(length: 1...50).validate("Sam Swift") // true
    /// ValidationRule.alphabetic(length: 1...50).validate("Sam123")  // false
    /// ```
    ///
    /// - Parameter length: The acceptable length range for the input string.
    /// - Returns: A validation rule checking that the input is within the specified
    ///   length and does not contain numeric characters.
    public static func alphabetic(length: some RangeExpression<Int> & Sendable) -> Self {
        self.length(length) && subset(of: .numbers.inverted)
    }

    /// A validation rule that checks whether the input is equal to the given range.
    ///
    /// - Parameter range: The range of the input.
    /// - Returns: A validation rule checking that the input is within the specified
    ///   length and only contain numeric characters.
    public static func number(length: some RangeExpression<Int> & Sendable) -> Self {
        self.length(length) && subset(of: .numbers)
    }

    /// A validation rule that checks whether the input is equal to the given
    /// length.
    ///
    /// - Parameter length: The input length.
    /// - Returns: A validation rule checking that the input equal the specified
    ///   length and only contain numeric characters.
    public static func number(length: Int) -> Self {
        self.length(length) && subset(of: .numbers)
    }
}

// MARK: - SSN & ITIN

extension ValidationRule<String> {
    /// A validation rule that checks whether the input is a valid SSN.
    public static var ssn: Self {
        .init(
            pattern: "^(?!000)(?!666)^([0-8]\\d{2})((?!00)(\\d{2}))((?!0000)(\\d{4}))",
            transform: { $0.replacing("-", with: "") }
        )
    }

    /// A validation rule that checks whether the input is a valid ITIN.
    ///
    /// **Individual Taxpayer Identification Number**
    ///
    /// Format: `9XX-7X-XXXX`
    ///
    /// **What is an ITIN?**
    ///
    /// An Individual Taxpayer Identification Number (ITIN) is a tax processing
    /// number issued by the Internal Revenue Service. The IRS issues ITINs to
    /// individuals who are required to have a U.S. taxpayer identification number
    /// but who do not have, and are not eligible to obtain, a Social Security
    /// number (SSN) from the Social Security Administration (SSA).
    public static var itin: Self {
        .init(
            pattern: "^(9\\d{2})([ \\-]?)(7\\d|8[0-8]|9[0-2]|9[4-9])([ \\-]?)(\\d{4})$",
            transform: { $0.replacing("-", with: "") }
        )
    }

    /// A validation rule that checks whether the input is a valid SSN or ITIN.
    public static var ssnOrItin: Self {
        .ssn || .itin
    }
}

// MARK: - Data Detector

extension ValidationRule<String> {
    /// A validation rule that checks whether the input is equal to the given data
    /// detector type.
    ///
    /// - Parameter value: The value to compare against input.
    /// - Returns: The validation rule.
    public static func isValid(_ type: NSTextCheckingResult.CheckingType) -> Self {
        .init { input in
            guard let detector = try? NSDataDetector(types: type.rawValue) else {
                return false
            }

            if let match = detector.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
                return match.range.length == input.count
            }

            return false
        }
    }
}
