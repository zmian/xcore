//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

struct CompositeFeatureFlagProvider: FeatureFlagProvider, ExpressibleByArrayLiteral {
    /// The registered list of providers.
    private var providers: [FeatureFlagProvider] = []

    init(_ providers: [FeatureFlagProvider]) {
        self.providers = providers
    }

    init(arrayLiteral elements: FeatureFlagProvider...) {
        self.providers = elements
    }

    /// Add given provider if it's not already included in the collection.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    mutating func add(_ provider: FeatureFlagProvider) {
        guard !providers.contains(where: { $0.id == provider.id }) else {
            return
        }

        providers.append(provider)
    }

    /// Add list of given providers if they are not already included in the
    /// collection.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    mutating func add(_ providers: [FeatureFlagProvider]) {
        providers.forEach {
            add($0)
        }
    }

    /// Removes the given provider.
    mutating func remove(_ provider: FeatureFlagProvider) {
        let ids = providers.map(\.id)

        guard let index = ids.firstIndex(of: provider.id) else {
            return
        }

        providers.remove(at: index)
    }
}

extension CompositeFeatureFlagProvider {
    var id: String {
        providers.map(\.id).joined(separator: "_")
    }

    func value(forKey key: FeatureFlag.Key) -> FeatureFlag.Value? {
        for provider in providers {
            guard let value = provider.value(forKey: key) else {
                continue
            }

            return value
        }

        return nil
    }
}
