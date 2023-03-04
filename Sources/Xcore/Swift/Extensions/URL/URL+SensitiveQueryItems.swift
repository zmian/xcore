//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension URL {
    /// Masks sensitive query parameters from the `URL`.
    ///
    /// This method is useful where you want to hide sensitive query parameters
    /// (e.g., magiclink token) for being tracked with any marketing tools.
    ///
    /// For example, by default the list returns:
    ///
    /// ```
    /// "token": Redeem Magic link token.
    /// // "https://app.example.com/magiclink?token=xxxx"
    /// ```
    ///
    /// - Note: The list of sensitive parameters can be configured using
    ///   `FeatureFlag` provider.
    public func maskingSensitiveQueryItems() -> Self {
        replacingQueryItems(FeatureFlag.sensitiveUrlQueryParameters, with: "xxxx")
    }
}

// MARK: - Sensitive URL Query Parameters

extension FeatureFlag {
    /// Returns a list of sensitive query parameters.
    ///
    /// This list can be used to mask the query parameters before sending them to
    /// marketing tools for tracking purpose.
    ///
    /// For example, by default the list returns:
    ///
    /// ```
    /// "token": Redeem Magic link token.
    /// // "https://app.example.com/magiclink?token=Jn3yk..."
    /// ```
    fileprivate static var sensitiveUrlQueryParameters: [String] {
        key(#function).value(default: [
            "token",
            "code",
            "referral_code"
        ])
    }
}
