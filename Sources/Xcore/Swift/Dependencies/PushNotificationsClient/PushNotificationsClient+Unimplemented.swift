//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UserNotifications)
import Foundation

extension PushNotificationsClient {
    /// Returns the unimplemented variant of `PushNotificationsClient`.
    public static var unimplemented: Self {
        .init(
            authorizationStatus: {
                reportIssue("\(Self.self).authorizationStatus is unimplemented")
                return .notDetermined
            },
            events: {
                .unimplemented("\(Self.self).events")
            },
            register: {
                reportIssue("\(Self.self).register is unimplemented")
            },
            unregister: {
                reportIssue("\(Self.self).unregister is unimplemented")
            },
            openAppSettings: {
                reportIssue("\(Self.self).openAppSettings is unimplemented")
            }
        )
    }
}
#endif
