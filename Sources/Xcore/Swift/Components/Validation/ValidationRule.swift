//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing a rule for validating input values.
///
/// Use a `ValidationRule` instance to determine whether a given input satisfies
/// specific criteria. Provide a closure that evaluates the input and returns a
/// Boolean indicating validity.
///
/// **Usage**
///
/// ```swift
/// let emailRule = ValidationRule<String> { input in
///     input.wholeMatch(of: /^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/) != nil
/// }
///
/// emailRule.validate("help@example.com") // valid
/// emailRule.validate("help.example.com") // invalid
/// ```
public struct ValidationRule<Input>: Sendable {
    /// Evaluates the given input against the validation conditions.
    ///
    /// ```swift
    /// email.validate("help@example.com") // valid
    /// email.validate("help.example.com") // invalid
    /// ```
    ///
    /// - Parameter input: The input value to validate.
    /// - Returns: `true` if the input is valid; otherwise, `false`.
    public let validate: @Sendable (Input) -> Bool

    /// Creates a validation rule with the given evaluation closure.
    ///
    /// - Parameter validate: A closure that takes input of type `Input` and
    ///   returns `true` if it meets the conditions; otherwise, `false`.
    public init(_ validate: @escaping @Sendable (Input) -> Bool) {
        self.validate = validate
    }
}

// MARK: - Regex Based Rules

extension ValidationRule<String> {
    /// Creates a validation rule based on a regular expression pattern.
    ///
    /// - Parameters:
    ///   - pattern: The regular expression pattern to match against.
    ///   - transform: An optional transformation applied to the input before
    ///     evaluation.
    public init(pattern: String, transform: (@Sendable (Input) -> Input)? = nil) {
        self.init { input in
            let input = transform?(input) ?? input
            return NSPredicate(format: "SELF MATCHES %@", pattern).evaluate(with: input)
        }
    }
}

// MARK: - Conditional Conformance

extension ValidationRule<String>: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(pattern: value)
    }
}

extension ValidationRule<String>: ExpressibleByExtendedGraphemeClusterLiteral {
    public init(extendedGraphemeClusterLiteral value: String) {
        self.init(pattern: value)
    }
}

extension ValidationRule<String>: ExpressibleByUnicodeScalarLiteral {
    public init(unicodeScalarLiteral value: String) {
        self.init(pattern: value)
    }
}

// MARK: - Convenience Extension

extension String {
    /// Evaluates `self` against the given validation rule.
    ///
    /// ```swift
    /// "help@example.com".validate(rule: .email) // valid
    /// "help.example.com".validate(rule: .email) // invalid
    /// ```
    ///
    /// - Parameter rule: The validation rule to evaluate `self` against.
    /// - Returns: `true` if `self` matches the conditions specified by the given
    ///   `rule`; otherwise, `false`.
    public func validate(rule: ValidationRule<String>) -> Bool {
        rule.validate(self)
    }
}
