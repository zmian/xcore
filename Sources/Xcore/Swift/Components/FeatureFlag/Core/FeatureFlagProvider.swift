//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol FeatureFlagProvider {
    /// A unique id for the feature flag provider.
    var id: String { get }

    func value(forKey key: FeatureFlag.Key) -> FeatureFlag.Value?
}

extension FeatureFlagProvider {
    public var id: String {
        name(of: self)
    }
}
