//
// AppAnalyticsEvent.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

public struct AppAnalyticsEvent: AnalyticsEvent, UserInfoContainer {
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
