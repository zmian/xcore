//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - System Alert

extension FeatureFlag {
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

// MARK: - System Force Refresh

extension FeatureFlag {
    /// Returns a system force refresh hash if it's different then the last saved
    /// hash.
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
