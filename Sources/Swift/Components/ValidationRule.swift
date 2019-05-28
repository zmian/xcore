//
// ValidationRule.swift
//
// Copyright © 2019 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

public struct ValidationRule<Input> {
    private let block: (Input) -> Bool

    public init(_ block: @escaping (Input) -> Bool) {
        self.block = block
    }

    /// Returns a boolean value indicating whether the given `input` matches the
    /// conditions specified by `self`.
    ///
    /// ```swift
    /// email.validate("help@example.com") // valid
    /// email.validate("help.example.com") // invalid
    /// ```
    ///
    /// - Parameter input: The input against which to evaluate `self`.
    /// - Returns: `true` if given `input` matches the conditions specified by `self`,
    ///            otherwise `false`.
    public func validate(_ input: Input) -> Bool {
        return block(input)
    }
}

extension ValidationRule {
    public enum LogicalType {
        case and
        case or
        case not
    }
}

// MARK: - Conditional Conformance

extension ValidationRule where Input == String {
    public init(pattern: String, transform: ((Input) -> Input)? = nil) {
        self.init { input in
            let input = transform?(input) ?? input
            return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: input)
        }
    }
}

extension ValidationRule: ExpressibleByStringLiteral where Input == String {
    public init(stringLiteral value: StringLiteralType) {
        self.init(pattern: value)
    }
}

extension ValidationRule: ExpressibleByExtendedGraphemeClusterLiteral where Input == String {
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(pattern: value)
    }
}

extension ValidationRule: ExpressibleByUnicodeScalarLiteral where Input == String {
    public init(unicodeScalarLiteral value: String) {
        self.init(pattern: value)
    }
}

// MARK: - Convenience Extension

extension String {
    /// Returns a boolean value indicating whether the `self` matches the conditions
    /// specified by the `rule`.
    ///
    /// ```swift
    /// "help@example.com".validate(rule: .email) // valid
    /// "help.example.com".validate(rule: .email) // invalid
    /// ```
    ///
    /// - Parameter rule: The rule against which to evaluate `self`.
    /// - Returns: `true` if `self` matches the conditions specified by the given
    ///            `rule`, otherwise `false`.
    public func validate(rule: ValidationRule<String>) -> Bool {
        return rule.validate(self)
    }

    /// Returns a boolean value indicating whether the `self` matches the conditions
    /// specified by the `rules` using `join` predicate.
    ///
    /// ```swift
    /// "help@example.com".validate(rules: [.email, .whitelistedDomain], join: .and) // valid
    /// "help.example.com".validate(rules: [.email, .whitelistedDomain], join: .and) // invalid
    /// ```
    ///
    /// - Parameters:
    ///   - join: The predicate to use when evaluating the list of given rules.
    ///   - rules: The list of rules against which to evaluate `self`.
    /// - Returns: `true` if `self` matches the conditions specified by the given
    ///            `rule` and `join` predicate, otherwise `false`.
    public func validate(rules: [ValidationRule<String>], join: ValidationRule<String>.LogicalType) -> Bool {
        return rules.validate(self, as: join)
    }
}

extension Array where Element == ValidationRule<String> {
    /// Returns a boolean value indicating whether the `input` matches the
    /// conditions specified by the `self` using `join` predicate.
    ///
    /// ```swift
    /// [.email, .whitelistedDomain].validate("help@example.com", as: .and) // valid
    /// [.email, .whitelistedDomain].validate("help.example.com", as: .and) // invalid
    /// [.email, .whitelistedDomain].validate("help.example.com", as: .or)  // valid
    /// ```
    ///
    /// - Parameters:
    ///   - input: The input against which to evaluate `self`.
    ///   - join: The predicate to use when evaluating the given `input` against
    ///           `self`.
    /// - Returns: `true` if given `input` matches the conditions specified by
    ///            `self` and `join` predicate, otherwise `false`.
    public func validate(_ input: String, as join: ValidationRule<String>.LogicalType) -> Bool {
        let initalValue = first?.validate(input) ?? true

        return reduce(initalValue) { accumulator, rule -> Bool in
            switch join {
                case .and:
                    return accumulator && rule.validate(input)
                case .or:
                    return accumulator || rule.validate(input)
                case .not:
                    return !accumulator && !rule.validate(input)
            }
        }
    }
}

// MARK: - Built-in Rules

extension ValidationRule where Input == String {
    public static var name: ValidationRule {
        return ValidationRule { input in
            let range = 2...50
            return range.contains(input.count) && !input.isMatch("[0-9]")
        }
    }

    /// A validation rule that checks whether the input satisfy the given regex.
    ///
    /// - Parameter pattern: Regex pattern used to find matches in the input.
    /// - Returns: The validation rule.
    public static func regex(_ pattern: String) -> ValidationRule {
        return ValidationRule { input in
            return input.isMatch(pattern)
        }
    }

    /// A validation rule that checks whether the input is a subset of the given
    /// set.
    ///
    /// - Parameter other: The superset of the input.
    /// - Returns: The validation rule.
    public static func subset(of other: CharacterSet) -> ValidationRule {
        return ValidationRule { input in
            let input = CharacterSet(charactersIn: input)
            return other.isSuperset(of: input)
        }
    }

    /// A validation rule that checks whether the input length exceed the given
    /// minimum length.
    ///
    /// - Parameter length: The minimum length of the input.
    /// - Returns: The validation rule.
    public static func length(min length: Int) -> ValidationRule {
        return ValidationRule { input in
            return input.count >= length
        }
    }

    /// A validation rule that checks whether the input length exceed the given
    /// maximum length.
    ///
    /// - Parameter length: The maximum length of the input.
    /// - Returns: The validation rule.
    public static func length(max length: Int) -> ValidationRule {
        return ValidationRule { input in
            return input.count <= length
        }
    }

    /// A validation rule that checks whether the input is a valid email address.
    public static var email: ValidationRule {
        return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    }

    /// A validation rule that checks whether the input is a valid SSN.
    public static var ssn: ValidationRule {
        return ValidationRule(
            pattern: "^(?!000)(?!666)^([0-8]\\d{2})((?!00)(\\d{2}))((?!0000)(\\d{4}))",
            transform: { $0.replace("-", with: "") }
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
    public static var itin: ValidationRule {
        return ValidationRule(
            pattern: "^(9\\d{2})([ \\-]?)(7\\d|8[0-8]|9[0-2]|9[4-9])([ \\-]?)(\\d{4})$",
            transform: { $0.replace("-", with: "") }
        )
    }
}
