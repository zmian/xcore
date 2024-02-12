//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that retrieves a value for the given key.
///
/// Sample implementation for fetching value from Firebase Remote Config:
///
/// ```swift
/// @_implementationOnly import FirebaseRemoteConfig
///
/// struct FirebaseFeatureFlagProvider: FeatureFlagProvider {
///     func value(forKey key: FeatureFlag.Key) -> FeatureFlag.Value? {
///         let configValue = FirebaseRemoteConfig.RemoteConfig.remoteConfig()[key.rawValue]
///
///         // If `value` for `key` is not present in the remote configuration (default or
///         // remote), Firebase returns a static value (0, "", false). We return `nil` in
///         // this particular case.
///         guard configValue.source != .static else {
///             return nil
///         }
///
///         var string: String?
///
///         if let stringValue = configValue.stringValue {
///             string = stringValue
///         } else if configValue.boolValue {
///             // We don't care about `false` as that would be the default value for any absent
///             // value.
///             string = String(describing: true)
///         } else if !configValue.numberValue.stringValue.isEmpty {
///             string = configValue.numberValue.stringValue
///         }
///
///         if let string, !string.isEmpty {
///             return .init(string)
///         }
///
///         return nil
///     }
/// }
/// ```
public protocol FeatureFlagProvider {
    /// A unique id for the feature flag provider.
    var id: String { get }

    /// Returns value for the given key.
    func value(forKey key: FeatureFlag.Key) -> FeatureFlag.Value?
}

extension FeatureFlagProvider {
    public var id: String {
        name(of: self)
    }
}
