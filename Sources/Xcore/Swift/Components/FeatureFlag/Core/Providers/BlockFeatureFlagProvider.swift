//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct BlockFeatureFlagProvider: FeatureFlagProvider {
    public let id: String
    private let block: (FeatureFlag.Key) -> FeatureFlag.Value?

    public init(id: String, value: @escaping (FeatureFlag.Key) -> FeatureFlag.Value?) {
        self.id = id
        self.block = value
    }

    public func value(forKey key: FeatureFlag.Key) -> FeatureFlag.Value? {
        block(key)
    }
}
