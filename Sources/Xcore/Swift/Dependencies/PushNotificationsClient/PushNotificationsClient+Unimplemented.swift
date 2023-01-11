//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UserNotifications)
import Foundation

extension PushNotificationsClient {
    /// Returns unimplemented variant of `PushNotificationsClient`.
    public static var unimplemented: Self {
        .init(
            authorizationStatus: {
                XCTFail("\(Self.self).authorizationStatus is unimplemented")
                return .notDetermined
            },
            events: {
                .unimplemented("\(Self.self).events")
            },
            register: {
                XCTFail("\(Self.self).register is unimplemented")
            },
            unregister: {
                XCTFail("\(Self.self).unregister is unimplemented")
            },
            openAppSettings: {
                XCTFail("\(Self.self).openAppSettings is unimplemented")
            }
        )
    }
}
#endif
