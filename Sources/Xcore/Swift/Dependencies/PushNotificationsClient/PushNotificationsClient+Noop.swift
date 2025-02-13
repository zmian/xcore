//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UserNotifications)
import Foundation

extension PushNotificationsClient {
    /// Returns noop variant of `PushNotificationsClient`.
    public static var noop: Self {
        .init(
            authorizationStatus: { .notDetermined },
            events: { .never },
            register: {},
            unregister: {},
            openAppSettings: {}
        )
    }
}
#endif
