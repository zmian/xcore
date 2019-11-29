//
// Interstitial+Item+FeatureFlag.swift
//
// Copyright © 2018 Xcore
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
            precondition: isEnabled ? precondition : { _ in false }
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

extension Identifier where Type == Interstitial {
    fileprivate static var startsWithSeparator: String { "*" }

    /// A convenience initializer for formatting interstitial id with `"startsWith"`
    /// predicate for FeatureFlag configuration.
    ///
    /// For example, id with value of `"terms*123"` will match with any interstitial
    /// item that starts with `"terms"`.
    ///
    /// - Parameter suffix: The string that is ignored for FeatureFlag configuration
    ///                     lookup.
    /// - Parameter startsWith: The string that is used for FeatureFlag
    ///                         configuration lookup.
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
