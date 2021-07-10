//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct AppAnalyticsEvent: AnalyticsEventProtocol, UserInfoContainer {
    public let name: String
    public let properties: [String: Any]?
    public let additionalProviders: [AnalyticsProvider]?
    /// Additional info which may be used to describe the analytics event further.
    public var userInfo: UserInfo

    public init(
        name: String,
        properties: [String: Any]? = nil,
        additionalProviders: [AnalyticsProvider]? = nil,
        userInfo: UserInfo = [:]
    ) {
        self.name = name
        self.properties = properties
        self.additionalProviders = additionalProviders
        self.userInfo = userInfo
    }
}

extension AppAnalyticsEvent: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}

// MARK: - UserInfo

extension UserInfoKey where Type == AppAnalyticsEvent {
    /// An optional property indicating whether the event should be throttled and
    /// only fired once in the given session.
    ///
    /// See: `Analytics.session` for session information.
    public static var sessionId: Self { #function }
}

extension AppAnalyticsEvent {
    /// An optional property indicating whether the event should be throttled and
    /// only fired once in the given session.
    ///
    /// The default value is `nil`, which means to not throttle.
    ///
    /// See: `Analytics.session` for session information.
    public var sessionId: String? {
        get { self[userInfoKey: .sessionId] }
        set { self[userInfoKey: .sessionId] = newValue }
    }
}
