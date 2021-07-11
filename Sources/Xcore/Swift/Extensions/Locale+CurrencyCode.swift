//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Locale {
    public enum CurrencyCodeTag {}
    public typealias CurrencyCode = Identifier<CurrencyCodeTag>
}

// MARK: - Built-in

extension Locale.CurrencyCode {
    /// United States, US Dollar.
    public static let usd: Self = "USD"

    /// United Kingdom, Pound Sterling.
    public static let gbp: Self = "GBP"
}
