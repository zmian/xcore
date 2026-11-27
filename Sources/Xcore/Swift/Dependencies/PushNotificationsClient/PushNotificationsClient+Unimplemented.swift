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
                reportIssue(#"Unimplemented: @Dependency(\.pushNotifications).authorizationStatus"#)
                return .notDetermined
            },
            events: {
                AsyncStream<Event>.unimplemented(#"Unimplemented: @Dependency(\.pushNotifications).events"#)
            },
            register: {
                reportIssue(#"Unimplemented: @Dependency(\.pushNotifications).register"#)
            },
            unregister: {
                reportIssue(#"Unimplemented: @Dependency(\.pushNotifications).unregister"#)
            },
            openAppSettings: {
                reportIssue(#"Unimplemented: @Dependency(\.pushNotifications).openAppSettings"#)
            }
        )
    }
}
#endif
