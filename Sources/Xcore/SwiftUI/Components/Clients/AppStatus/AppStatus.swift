//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// An enumeration representing app's status.
public enum AppStatus: Hashable, CustomStringConvertible {
    /// The app is preparing from cold launch. This is the initial state.
    case preparingLaunch

    /// The app is being forced refreshed by removing all cache.
    case systemForceRefresh

    /// The app is displaying system alert (e.g., **Unsupported App Version**).
    case systemAlert(SystemAlertConfiguration)

    /// The app is in provided session.
    case session(SessionState)
}

// MARK: - CustomStringConvertible

extension AppStatus: CustomAnalyticsValueConvertible {
    public var analyticsValue: String {
        switch self {
            case .preparingLaunch:
                return "preparing_launch"
            case .systemForceRefresh:
                return "system_force_refresh"
            case let .systemAlert(configuration):
                return "system_alert_\(configuration.id)"
            case .session(.signedOut):
                return "session_signed_out"
            case .session(.locked):
                return "session_locked"
            case .session(.unlocked):
                return "session_unlocked"
        }
    }

    public var description: String {
        analyticsValue.camelcased()
    }
}
