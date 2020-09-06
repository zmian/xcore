//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Locale {
    public struct CurrencyCode: RawRepresentable, Hashable, CustomStringConvertible {
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public var description: String {
            rawValue
        }
    }
}

extension Locale.CurrencyCode: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

// MARK: - Built-in

extension Locale.CurrencyCode {
    /// United States, US Dollar.
    public static let usd: Self = "USD"

    /// United Kingdom, Pound Sterling.
    public static let gbp: Self = "GBP"
}
