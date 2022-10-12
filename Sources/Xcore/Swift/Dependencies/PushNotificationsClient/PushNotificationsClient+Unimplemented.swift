//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if DEBUG && canImport(UserNotifications)
import Foundation

extension PushNotificationsClient {
    /// Returns unimplemented variant of `PushNotificationsClient`.
    public static var unimplemented: Self {
        .init(
            authorizationStatus: {
                internal_XCTFail("\(Self.self).authorizationStatus is unimplemented")
                return .notDetermined
            },
            events: {
                .unimplemented("\(Self.self).events")
            },
            register: {
                internal_XCTFail("\(Self.self).register is unimplemented")
            },
            unregister: {
                internal_XCTFail("\(Self.self).unregister is unimplemented")
            },
            openAppSettings: {
                internal_XCTFail("\(Self.self).openAppSettings is unimplemented")
            }
        )
    }
}
#endif
