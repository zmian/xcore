//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing a system alert configuration.
///
/// **Example Payload 1:**
///
/// ```swift
/// {
///     "id": "maintenance_mode",
///     "title": "Undergoing Maintenance",
///     "message": "We are undergoing maintenance. Thank you for your patience.",
///     "dismissable": true
/// }
/// ```
///
/// **Example Payload 2:**
///
/// ```swift
/// {
///     "id": "unsupported_app_version",
///     "title": "Unsupported App Version",
///     "message": "This version of the app is no longer supported. Please update to the latest version.",
///     "dismissable": false,
///     "image_url": "https://images.unsplash.com/photo-1604782206219-3b9576575203?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1394&q=80",
///     "cta_title": "Learn More",
///     "cta_url": "https://www.example.com"
/// }
/// ```
public struct SystemAlertConfiguration: Hashable, Sendable, Codable, Identifiable {
    /// A unique id for the system alert.
    public let id: String

    /// The title of the system alert.
    public let title: String

    /// The message describing the system alert.
    public let message: String

    /// A Boolean property indicating whether the system alert can be dismissed.
    public let isDismissable: Bool

    /// An optional image associated with the system alert.
    public let imageUrl: URL?

    /// An optional CTA title associated with the CTA URL property of the system
    /// alert.
    public let ctaTitle: String?

    /// An optional CTA URL to show more information about the system alert.
    public let ctaUrl: URL?

    public init(
        id: String,
        title: String,
        message: String,
        isDismissable: Bool,
        imageUrl: URL? = nil,
        ctaTitle: String? = nil,
        ctaUrl: URL? = nil
    ) {
        self.id = id
        self.title = title
        self.message = message
        self.isDismissable = isDismissable
        self.imageUrl = imageUrl
        self.ctaTitle = ctaTitle
        self.ctaUrl = ctaUrl
    }
}

// MARK: - Dismissal

extension SystemAlertConfiguration {
    private static var dismissedIds: Set<String> = []

    /// A Boolean property indicating whether the system alert is dismissed.
    public var isDismissed: Bool {
        guard isDismissable else {
            return false
        }

        return Self.dismissedIds.contains(id)
    }

    /// A method to dismiss the system alert for this session
    public func dismiss() {
        guard isDismissable else {
            return
        }

        Self.dismissedIds.insert(id)
    }
}

// MARK: - Codable

extension SystemAlertConfiguration {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case message
        case dismissable
        case imageUrl
        case ctaTitle
        case ctaUrl
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        id = try container.decode(.id)
        title = try container.decode(.title)
        message = try container.decode(.message)
        isDismissable = try container.decodeIfPresent(.dismissable, format: .bool) ?? false
        imageUrl = try container.decodeIfPresent(.imageUrl)
        ctaTitle = try container.decodeIfPresent(.ctaTitle)
        ctaUrl = try container.decodeIfPresent(.ctaUrl)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(message, forKey: .message)
        try container.encode(isDismissable, forKey: .dismissable)
        try container.encodeIfPresent(imageUrl, forKey: .imageUrl)
        try container.encodeIfPresent(ctaTitle, forKey: .ctaTitle)
        try container.encodeIfPresent(ctaUrl, forKey: .ctaUrl)
    }
}

#if DEBUG

// MARK: - Sample

extension SystemAlertConfiguration {
    /// Returns a sample maintenance mode system alert suitable to display in the
    /// previews and tests.
    public static var maintenance: Self {
        .init(
            id: "maintenance_mode",
            title: "Undergoing Maintenance",
            message: "We are undergoing maintenance. Thank you for your patience.",
            isDismissable: true
        )
    }

    /// Returns a sample unsupported app version alert suitable to display in the
    /// previews and tests.
    public static var unsupportedAppVersion: Self {
        .init(
            id: "unsupported_app_version",
            title: "Unsupported App Version",
            message: "This version of the app is no longer supported. Please update to the latest version.",
            isDismissable: false,
            ctaUrl: URL(string: "https://www.example.com")
        )
    }

    /// Returns a sample unsupported app version alert with inline links suitable to
    /// display in the previews and tests.
    public static var unsupportedAppVersionWithLinks: Self {
        .init(
            id: "unsupported_app_version",
            title: "Unsupported App Version",
            message: "This version of the app is no longer supported. Please update to the latest version. [Contact customer support](https://www.example.com) for more information.",
            isDismissable: true,
            imageUrl: URL(string: "https://images.unsplash.com/photo-1604782206219-3b9576575203?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1394&q=80"),
            ctaTitle: "Contact Customer Support",
            ctaUrl: URL(string: "https://www.example.com")
        )
    }
}
#endif
