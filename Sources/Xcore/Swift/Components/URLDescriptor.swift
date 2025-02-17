//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing URL with additional details.
///
/// `URLDescriptor` encapsulates a URL along with a title and additional
/// metadata. It serves as a high-level representation of a URL that can be
/// displayed or processed in different contexts (for example, when generating
/// Markdown output).
///
/// **Usage**
///
/// ```swift
/// let privacyPolicy = URLDescriptor(
///     title: "Privacy Policy",
///     url: URL(string: "https://example.com/legal/privacy")!
/// )
/// ```
public struct URLDescriptor: UserInfoContainer, MutableAppliable, Sendable {
    /// The title of the URL.
    public var title: String

    /// The underlying URL.
    public var url: URL

    /// Additional info which may be used to describe the URL further.
    public var userInfo: UserInfo

    /// Creates an instance of `URLDescriptor`.
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

// MARK: - Equatable

extension URLDescriptor: Equatable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        String(reflecting: lhs) == String(reflecting: rhs)
    }
}

// MARK: - Hashable

extension URLDescriptor: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(reflecting: self))
    }
}

// MARK: - Markdown

extension URLDescriptor {
    /// Returns a Markdown representation of the `URLDescriptor`.
    ///
    /// If the title is blank, the URL itself is used as the link text; otherwise,
    /// the title is used. The returned string follows the Markdown syntax:
    /// `[title](url)`.
    ///
    /// - Returns: A Markdown formatted string representing the URL.
    public var markdown: String {
        title.isBlank ? "[\(url)](\(url))" : "[\(title)](\(url))"
    }
}
