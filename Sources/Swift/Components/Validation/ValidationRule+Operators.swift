//
// ValidationRule+Operators.swift
//
// Copyright © 2019 Xcore
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

// MARK: - Equatable

extension ValidationRule {
    /// Returns a compound validation rule indicating whether two validation rules
    /// are equal.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: The validation rule.
    public static func ==(lhs: ValidationRule, rhs: ValidationRule) -> ValidationRule {
        return .init { lhs.validate($0) == rhs.validate($0) }
    }

    /// Returns a compound validation rule indicating whether two validation rules
    /// are not equal.
    ///
    /// - Parameters:
    ///   - lhs: A value to compare.
    ///   - rhs: Another value to compare.
    /// - Returns: The validation rule.
    public static func !=(lhs: ValidationRule, rhs: ValidationRule) -> ValidationRule {
        return .init { lhs.validate($0) != rhs.validate($0) }
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
    public static func &&(lhs: ValidationRule, rhs: @autoclosure @escaping () -> ValidationRule) -> ValidationRule {
        return .init { lhs.validate($0) && rhs().validate($0) }
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
    public static func ||(lhs: ValidationRule, rhs: @autoclosure @escaping () -> ValidationRule) -> ValidationRule {
        return .init { lhs.validate($0) || rhs().validate($0) }
    }

    /// Returns a negation validation rule.
    ///
    /// ```swift
    /// "help@example.com".validate(rule: !.email) // invalid
    /// ```
    ///
    /// - Parameter validation: The validation rule to negate.
    /// - Returns: The validation rule.
    public static prefix func !(_ rule: ValidationRule) -> ValidationRule {
        return .init { !rule.validate($0) }
    }
}
