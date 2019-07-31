//
// CompositeFeatureFlagProvider.swift
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

final class CompositeFeatureFlagProvider: FeatureFlagProvider, ExpressibleByArrayLiteral {
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
    func add(_ provider: FeatureFlagProvider) {
        guard !providers.contains(where: { $0.id == provider.id }) else {
            return
        }

        providers.append(provider)
    }

    /// Add list of given providers if they are not already included in the
    /// collection.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    func add(_ providers: [FeatureFlagProvider]) {
        providers.forEach(add)
    }

    /// Removes the given provider.
    func remove(_ provider: FeatureFlagProvider) {
        let ids = providers.map { $0.id }

        guard let index = ids.firstIndex(of: provider.id) else {
            return
        }

        providers.remove(at: index)
    }
}

extension CompositeFeatureFlagProvider {
    var id: String {
        return providers.map { $0.id }.joined(separator: "_")
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
