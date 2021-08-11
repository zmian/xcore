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

// MARK: - Equatable

extension AppAnalyticsEvent: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        let equalProperties: Bool

        if let lhsP = lhs.properties, let rhsP = rhs.properties {
            equalProperties = lhsP == rhsP
        } else {
            equalProperties = lhs.properties == nil && rhs.properties == nil
        }

        return
            lhs.name == rhs.name &&
            equalProperties &&
            isEqual(lhs.additionalProviders, rhs.additionalProviders) &&
            lhs.userInfo == rhs.userInfo
    }

    private static func isEqual(_ lhs: [AnalyticsProvider]?, _ rhs: [AnalyticsProvider]?) -> Bool {
        guard let lhs = lhs, let rhs = rhs else {
            return lhs == nil && rhs == nil
        }

        return lhs.map(\.id) == rhs.map(\.id)
    }
}

// MARK: - Hashable

extension AppAnalyticsEvent: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(name)

        if let ids = additionalProviders?.map(\.id) {
            hasher.combine(ids)
        }

        hasher.combine(String(reflecting: self))
    }
}
