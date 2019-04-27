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

    public func validate(_ input: Input) -> Bool {
        return block(input)
    }
}

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

extension String {
    public func validate(rule: ValidationRule<String>) -> Bool {
        return rule.validate(self)
    }
}

// MARK: - Built-in Rules

extension ValidationRule where Input == String {
    public static var email: ValidationRule {
        return "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    }

    /// Individual Taxpayer Identification Number.
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

    public static var ssn: ValidationRule {
        return ValidationRule(
            pattern: "^(?!000)(?!666)^([0-8]\\d{2})((?!00)(\\d{2}))((?!0000)(\\d{4}))",
            transform: { $0.replace("-", with: "") }
        )
    }

    public static var name: ValidationRule {
        return ValidationRule { input in
            let range = 2...50
            return range.contains(input.count) && !input.isMatch("[0-9]")
        }
    }
}
