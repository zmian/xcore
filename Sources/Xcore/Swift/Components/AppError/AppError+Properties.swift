//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension UserInfoKey where Type == AppError {
    /// A Boolean property indicating whether the error should show "Contact
    /// Support" option.
    public static var contactSupport: Self { #function }

    /// A Boolean property indicating whether the error should show "Open App
    /// Settings" option.
    public static var openAppSettings: Self { #function }
}

extension AppError {
    /// A Boolean property indicating whether the error should show "Contact
    /// Support" option.
    public var contactSupport: Bool {
        get { self[userInfoKey: .contactSupport, default: false] }
        set { self[userInfoKey: .contactSupport] = newValue }
    }

    /// A Boolean property indicating whether the error should show "Open App
    /// Settings" option.
    public var openAppSettings: Bool {
        get { self[userInfoKey: .openAppSettings, default: false] }
        set { self[userInfoKey: .openAppSettings] = newValue }
    }
}

extension Binding where Value == AppError? {
    /// A Boolean property indicating whether the error should show "Contact
    /// Support" option.
    public var contactSupport: Bool {
        wrappedValue?.contactSupport == true
    }

    /// A Boolean property indicating whether the error should show "Open App
    /// Settings" option.
    public var openAppSettings: Bool {
        wrappedValue?.openAppSettings == true
    }
}

extension AppError {
    public init(
        id: String,
        title: String,
        message: String,
        logLevel: LogLevel? = nil,
        contactSupport: Bool,
        openAppSettings: Bool = false
    ) {
        self.init(
            id: id,
            title: title,
            message: message,
            logLevel: logLevel,
            userInfo: [
                .contactSupport: contactSupport,
                .openAppSettings: openAppSettings
            ]
        )
    }
}
