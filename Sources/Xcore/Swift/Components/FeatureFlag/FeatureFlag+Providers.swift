//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Registration

extension FeatureFlag {
    /// The registered list of providers.
    private static var provider = CompositeFeatureFlagProvider([
        ProcessInfoEnvironmentVariablesFeatureFlagProvider()
    ])

    /// Register the given provider if it's not already registered.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    public static func register(_ provider: FeatureFlagProvider) {
        self.provider.add(provider)
    }
}

// MARK: - FeatureFlag.Key Convenience

extension FeatureFlag.Key {
    private var currentValue: FeatureFlag.Value? {
        FeatureFlag.provider.value(forKey: self)
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Returns: The value for the key.
    public func value() -> Bool {
        currentValue?.get() ?? false
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Returns: The value for the key.
    public func value<T>() -> T? {
        currentValue?.get()
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Parameter defaultValue: The value returned if the providers list doesn't
    ///   contain value.
    /// - Returns: The value for the key.
    public func value<T>(default defaultValue: @autoclosure () -> T) -> T {
        currentValue?.get() ?? defaultValue()
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Parameter defaultValue: The value returned if the providers list doesn't
    ///   contain value.
    /// - Returns: The value for the key.
    public func value<T>(default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        currentValue?.get() ?? defaultValue()
    }
}
