//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct AppAnalyticsEvent: AnalyticsEventProtocol, UserInfoContainer {
    public let name: String
    public let properties: [String: Any]
    public let additionalProviders: [AnalyticsProvider]
    /// Additional info which may be used to describe the analytics event further.
    public var userInfo: UserInfo

    public init(
        name: String,
        properties: [String: Any] = [:],
        additionalProviders: [AnalyticsProvider] = [],
        userInfo: UserInfo = [:]
    ) {
        self.name = name
        self.properties = properties
        self.additionalProviders = additionalProviders
        self.userInfo = userInfo
    }
}

// MARK: - ExpressibleByStringLiteral

extension AppAnalyticsEvent: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}

// MARK: - Equatable

extension AppAnalyticsEvent: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.name == rhs.name &&
            lhs.properties == rhs.properties &&
            isEqual(lhs.additionalProviders, rhs.additionalProviders) &&
            lhs.userInfo == rhs.userInfo
    }

    private static func isEqual(_ lhs: [AnalyticsProvider], _ rhs: [AnalyticsProvider]) -> Bool {
        lhs.map(\.id) == rhs.map(\.id)
    }
}

// MARK: - Hashable

extension AppAnalyticsEvent: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(additionalProviders.map(\.id))
        hasher.combine(String(reflecting: self))
    }
}

// MARK: - Helpers

extension AppAnalyticsEvent {
    public func mergingProperties(_ otherProperties: [String: Any]) -> Self {
        .init(
            name: name,
            properties: properties.merging(otherProperties),
            additionalProviders: additionalProviders,
            userInfo: userInfo
        )
    }

    public func mergingProperties(_ otherProperties: [String: Any?]) -> Self {
        mergingProperties(otherProperties.flatten())
    }
}

// MARK: - UserInfo

extension UserInfoKey where Type == AppAnalyticsEvent {
    /// An optional property indicating whether the event should be throttled and
    /// only fired once in the given session.
    ///
    /// - SeeAlso: `Analytics.session` for session information.
    public static var sessionId: Self { #function }
}

extension AppAnalyticsEvent {
    /// An optional property indicating whether the event should be throttled and
    /// only fired once in the given session.
    ///
    /// The default value is `nil`, which means to not throttle.
    ///
    /// - SeeAlso: `Analytics.session` for session information.
    public var sessionId: String? {
        get { self[userInfoKey: .sessionId] }
        set { self[userInfoKey: .sessionId] = newValue }
    }
}
