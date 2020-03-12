//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Equatable

extension ValidationRule {
    /// Returns a compound validation rule indicating whether two validation rules
    /// are equal.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: The validation rule.
    public static func ==(lhs: Self, rhs: Self) -> Self {
        .init { lhs.validate($0) == rhs.validate($0) }
    }

    /// Returns a compound validation rule indicating whether two validation rules
    /// are not equal.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: The validation rule.
    public static func !=(lhs: Self, rhs: Self) -> Self {
        .init { lhs.validate($0) != rhs.validate($0) }
    }
}

// MARK: - Logical Operators

extension ValidationRule {
    /// Returns a compound validation rule indicating whether two validation rules
    /// are valid using logical operator `&&`.
    ///
    /// ```swift
    /// "help@example.com".validate(rule: .email && .whitelistedDomain) // valid
    /// "help.example.com".validate(rule: .email && .whitelistedDomain) // invalid
    /// "help.example.com".validate(rule: .email || .whitelistedDomain) // valid
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: The validation rule.
    public static func &&(lhs: Self, rhs: @autoclosure @escaping () -> Self) -> Self {
        .init { lhs.validate($0) && rhs().validate($0) }
    }

    /// Returns a compound validation rule indicating whether either of two
    /// validation rules are valid using logical operator `||`.
    ///
    /// ```swift
    /// "help@example.com".validate(rule: .email && .whitelistedDomain) // valid
    /// "help.example.com".validate(rule: .email && .whitelistedDomain) // invalid
    /// "help.example.com".validate(rule: .email || .whitelistedDomain) // valid
    /// ```
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: The validation rule.
    public static func ||(lhs: Self, rhs: @autoclosure @escaping () -> Self) -> Self {
        .init { lhs.validate($0) || rhs().validate($0) }
    }

    /// Returns a negation validation rule.
    ///
    /// ```swift
    /// "help@example.com".validate(rule: !.email) // invalid
    /// ```
    ///
    /// - Parameter validation: The validation rule to negate.
    /// - Returns: The validation rule.
    public static prefix func !(_ rule: Self) -> Self {
        .init { !rule.validate($0) }
    }
}
