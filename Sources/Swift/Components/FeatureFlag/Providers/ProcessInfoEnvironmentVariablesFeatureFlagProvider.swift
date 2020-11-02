//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

struct ProcessInfoEnvironmentVariablesFeatureFlagProvider: FeatureFlagProvider {
    func value(forKey key: FeatureFlag.Key) -> FeatureFlag.Value? {
        let argument = ProcessInfo.Argument(rawValue: key.rawValue)

        guard argument.exists else {
            return nil
        }

        guard let value: String = argument.get() else {
            // ProcessInfo environment arguments can have value without being enabled.
            // Since, we are here it means the flag is enabled and it doesn't have any
            // value, thus we return `true` to indicate that the flag is enabled to the
            // caller.
            return .init(true)
        }

        // ProcessInfo environment arguments can have value without being enabled.
        // Since, we are here it means the flag is enabled and have value, thus we
        // return the value to the caller.
        return .init(value)
    }
}
