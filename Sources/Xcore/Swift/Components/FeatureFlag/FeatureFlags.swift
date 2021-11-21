//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

/// A namespace for types that serve as feature flags.
///
/// The various feature flags defined as extensions on ``FeatureFlag`` implement
/// their functionality as classes or structures that extend this enumeration.
/// For example, the **System Alert** flag returns a `SystemAlertConfiguration`
/// instance.
public enum FeatureFlags {
    public typealias Key = FeatureFlag.Key
}

// MARK: - Flags

extension FeatureFlags {
    /// Returns a system alert configuration (e.g., **Unsupported App Version**).
    public static func systemAlertConfiguration(key: Key = "system_alert_configuration") -> SystemAlertConfiguration? {
        guard let alert = key.decodedValue(SystemAlertConfiguration.self) else {
            return nil
        }

        // Supress the alert if we have already displayed it in this session.
        if alert.isDismissed {
            return nil
        }

        return alert
    }
}
