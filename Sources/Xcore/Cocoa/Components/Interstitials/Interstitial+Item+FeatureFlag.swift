//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - FeatureFlag

extension Interstitial.Item.DisplayPolicy {
    func updateFromFeatureFlag(id interstitialId: Interstitial.Identifier) -> Self {
        guard let dictionary = featureFlagValue(id: interstitialId) else {
            return self
        }

        let isEnabled = dictionary["enabled"] as? Bool ?? true

        return .init(
            dismissable: dictionary["dismissable"] as? Bool ?? isDismissable,
            replayDelay: dictionary["replayDelay"] as? TimeInterval ?? replayDelay,
            precondition: isEnabled ? precondition : { false }
        )
    }

    private func featureFlagValue(id interstitialId: Interstitial.Identifier) -> [String: Any]? {
        // Check for full id.
        if let value = featureFlagValue(keySuffix: interstitialId.rawValue) {
            return value
        }

        // Check for `startsWith` id.
        if
            interstitialId.hasDifferentMatchValue,
            let value = featureFlagValue(keySuffix: interstitialId.matchValue)
        {
            return value
        }

        return nil
    }

    private func featureFlagValue(keySuffix key: String) -> [String: Any]? {
        let key = FeatureFlag.Key(rawValue: "interstitial_" + key)

        guard let dictionary: [String: Any] = key.value(), !dictionary.isEmpty else {
            return nil
        }

        return dictionary
    }
}

// MARK: - Identifier

extension Interstitial.Identifier {
    fileprivate static var startsWithSeparator: String { "*" }

    /// A convenience initializer for formatting interstitial id with `"startsWith"`
    /// predicate for FeatureFlag configuration.
    ///
    /// For example, id with value of `"terms*123"` will match with any interstitial
    /// item that starts with `"terms"`.
    ///
    /// - Parameters:
    ///   - suffix: The string that is ignored for `FeatureFlag` configuration
    ///     lookup.
    ///   - startsWith: The string that is used for `FeatureFlag` configuration
    ///     lookup.
    public init(_ suffix: String, startsWith: String) {
        self.init(rawValue: "\(startsWith)\(Self.startsWithSeparator)\(suffix)")
    }

    fileprivate var matchValue: String {
        guard let startsWith = rawValue.components(separatedBy: Self.startsWithSeparator).first else {
            return rawValue
        }

        return startsWith
    }

    fileprivate var hasDifferentMatchValue: Bool {
        rawValue.contains(Self.startsWithSeparator)
    }
}
