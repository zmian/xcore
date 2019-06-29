//
// ValidationRule.swift
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
}
