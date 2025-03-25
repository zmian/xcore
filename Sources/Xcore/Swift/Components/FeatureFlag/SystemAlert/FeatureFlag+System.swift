//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - System Alert

extension FeatureFlag {
    /// Returns the current system alert configuration, if available.
    ///
    /// This configuration is typically used to display critical alerts,
    /// such as unsupported app version notices.
    ///
    /// The alert is only returned if it has not already been dismissed
    /// during the current session.
    ///
    /// - Parameter key: The feature flag key used to fetch the alert configuration.
    /// - Returns: A `SystemAlertConfiguration` instance, or `nil` if none is
    ///   available or already dismissed.
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

// MARK: - System Force Refresh

extension FeatureFlag {
    /// Returns a system force refresh hash if it differs from the last saved hash.
    ///
    /// This value is used to force a refresh of the system state. If the hash has
    /// already been applied during this session, it will return `nil`.
    ///
    /// - Returns: A `String` hash representing the refresh trigger, or `nil` if no
    ///   new value exists.
    public static var systemForceRefreshHash: String? {
        guard
            let value: String = key(#function).value(),
            !value.isEmpty
        else {
            return nil
        }

        @Dependency(\.pond) var pond

        guard value != pond.lastSystemForceRefreshHash else {
            return nil
        }

        return value
    }
}
