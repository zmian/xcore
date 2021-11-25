//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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
