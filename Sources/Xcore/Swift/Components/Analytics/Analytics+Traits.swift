//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Analytics {
    /// A list of traits such as locale and abtest properties.
    public static var commonTraits: [String: String] {
        var info = [
            "locale": Locale.current.identifier
        ]

        info += FeatureFlag.abtestAnalyticsProperties
        return info
    }
}

// MARK: - A/B Test

extension FeatureFlag {
    /// Returns list of currently active abtests for the given user.
    ///
    /// ```json
    /// // Sample output in the Analytics platform
    /// { "Mandatory KYC - Feb 2022": "control" }
    /// { "Mandatory KYC - Feb 2022": "mandatory_kyc_plaid" }
    /// { "Mandatory KYC - Feb 2022": "mandatory_kyc" }
    /// ```
    ///
    /// How to set up A/B Test values for proper analysis?
    ///
    /// ```json
    /// // 1. Set up main "abtest_analytics" dictionary:
    /// "abtest_analytics": {
    ///     "kyc": "Mandatory KYC - Feb 2022",
    ///     "onb_carousel": "Onboarding Carousel - May 2022",
    ///     "plaid": "Plaid Balances Refresh - Apr 2022",
    ///     "onb_wizard": "Onboarding V4 - May 2022",
    ///     "other": "..."
    /// }
    ///
    /// // 2. Set up A/B Test with variants:
    ///
    /// // Baseline
    /// "abtest_kyc": "control" // 20%
    /// // Variant A
    /// "abtest_kyc": "mandatory_kyc_plaid" // 40%
    /// // Variant B
    /// "abtest_kyc": "mandatory_kyc" // 40%
    /// ```
    fileprivate static var abtestAnalyticsProperties: [String: String] {
        // {
        //     "abtest_analytics": {
        //         "kyc": "Mandatory KYC - Feb 2022"
        //     }
        // }
        //
        // "key" represents "category" of the a/b test (e.g., "kyc")
        // "value" represents "experiment name" of the a/b test (e.g., "Mandatory KYC - Feb 2022")
        guard let abtestDictionary: [String: String] = Key(rawValue: "abtest_analytics").value() else {
            return [:]
        }

        var currentActiveVariants: [String: String] = [:]

        // Search for the active tests the current user is currently enrolled in and
        // construct the dictionary for analytics.
        //
        // { "Mandatory KYC - Feb 2022": "control" }
        // { "Mandatory KYC - Feb 2022": "mandatory_kyc_plaid" }
        // { "Mandatory KYC - Feb 2022": "mandatory_kyc" }
        for abtest in abtestDictionary {
            guard let variant: String = Key(rawValue: "abtest_" + abtest.key).value() else {
                continue
            }

            currentActiveVariants[abtest.value] = variant
        }

        return currentActiveVariants
    }
}
