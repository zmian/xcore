//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

/// A namespace for flags that serve as feature flags.
///
/// The various feature flags defined as extensions on ``FeatureFlag`` implement
/// their functionality as classes or structures that extend this enumeration.
/// For example, the **System Alert** flag returns a `SystemAlertConfiguration`
/// instance.
public enum FeatureFlag {
    /// **Usage**
    ///
    /// ```swift
    /// if FeatureFlag.someFeatureEnabled {
    ///     // turn on feature
    /// }
    /// ```
    ///
    /// - Note: The `rawValue` is automatically transformed to snakecased.
    public static func key(_ rawValue: String) -> Key {
        .init(rawValue: rawValue.snakecased())
    }

    #if DEBUG
    public static func setDebug<T>(_ key: String, value: T) {
        ProcessInfo.Argument(rawValue: key).set(value)
    }
    #endif
}
