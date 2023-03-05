//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing adaptive URL.
public struct AdaptiveURL: UserInfoContainer, MutableAppliable, Sendable {
    /// The title of the URL.
    public var title: String

    /// The underlying URL.
    public var url: URL

    /// Additional info which may be used to describe the url further.
    public var userInfo: UserInfo

    /// Creates an instance of adaptive URL.
    ///
    /// - Parameters:
    ///   - title: The title of the URL.
    ///   - url: The underlying url.
    ///   - userInfo: Additional info associated with the url.
    public init(title: String, url: URL, userInfo: UserInfo = [:]) {
        self.title = title
        self.url = url
        self.userInfo = userInfo
    }
}

// MARK: - UserInfo

extension UserInfoKey<AdaptiveURL> {
    /// A Boolean property indicating whether the URL content should adapt app
    /// appearance.
    public static var shouldAdaptAppearance: Self { #function }
}

extension AdaptiveURL {
    /// A Boolean property indicating whether the URL content should adapt app
    /// appearance.
    public var shouldAdaptAppearance: Bool {
        get { self[userInfoKey: .shouldAdaptAppearance, default: false] }
        set { self[userInfoKey: .shouldAdaptAppearance] = newValue }
    }
}

// MARK: - Equatable

extension AdaptiveURL: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        String(reflecting: lhs) == String(reflecting: rhs)
    }
}

// MARK: - Hashable

extension AdaptiveURL: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(reflecting: self))
    }
}

// MARK: - Markdown

extension AdaptiveURL {
    /// Returns mardown representation of the adaptive URL.
    public var markdown: String {
        title.isBlank ? "[\(url)](\(url))" : "[\(title)](\(url))"
    }
}
