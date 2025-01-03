//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Registration

extension FeatureFlag {
    /// The registered list of providers.
    nonisolated(unsafe) private static var provider = CompositeFeatureFlagProvider([
        ProcessInfoEnvironmentVariablesFeatureFlagProvider()
    ])

    /// Register the given provider if it's not already registered.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    public static func register(_ provider: FeatureFlagProvider) {
        self.provider.add(provider)
    }

    /// Register the given provider at the specified index if it's not already
    /// registered.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    public static func register(_ provider: FeatureFlagProvider, at index: Int) {
        self.provider.insert(provider, at: index)
    }

    /// Unregister the provider with the given id.
    public static func unregister(id: String) {
        self.provider.remove(id: id)
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

    /// Returns the value of the key, decoded from a JSON object, from registered
    /// list of feature flag providers.
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode from the string.
    ///   - decoder: The decoder used to decode the data. If set to `nil`, it uses
    ///     ``JSONDecoder`` with `convertFromSnakeCase` key decoding strategy.
    /// - Returns: A value of the specified type, if the decoder can parse the data.
    public func decodedValue<T>(_ type: T.Type = T.self, decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        currentValue?.get(type, decoder: decoder)
    }
}
