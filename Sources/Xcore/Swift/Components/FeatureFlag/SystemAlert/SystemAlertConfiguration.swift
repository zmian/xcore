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
public struct SystemAlertConfiguration: Sendable, Hashable, Codable, Identifiable {
    /// A unique id for the system alert.
    public let id: String

    /// The title of the system alert.
    public let title: String

    /// A message describing the purpose of the system alert.
    public let message: String

    /// A Boolean value indicating whether the system alert can be dismissed by the
    /// user.
    public let isDismissable: Bool

    /// An optional URL pointing to an image associated with the system alert.
    public let imageUrl: URL?

    /// An optional title for the call-to-action button.
    public let ctaTitle: String?

    /// An optional URL to open when the call-to-action is tapped.
    public let ctaUrl: URL?

    /// Creates a new `SystemAlertConfiguration`.
    ///
    /// - Parameters:
    ///   - id: A unique id for the system alert.
    ///   - title: The title of the system alert.
    ///   - message: A message describing the purpose of the system alert.
    ///   - isDismissable: A Boolean value indicating whether the system alert can
    ///     be dismissed by the user.
    ///   - imageUrl: An optional URL to an image associated with the system alert.
    ///   - ctaTitle: An optional title for the call-to-action button.
    ///   - ctaUrl: An optional URL to open when the call-to-action is tapped.
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
    private static let dismissedIds = LockIsolated(Set<String>())

    /// A Boolean property indicating whether the system alert is dismissed.
    public var isDismissed: Bool {
        guard isDismissable else {
            return false
        }

        return Self.dismissedIds.withValue {
            $0.contains(id)
        }
    }

    /// A method to dismiss the system alert for this session
    public func dismiss() {
        guard isDismissable else {
            return
        }

        Self.dismissedIds.withValue {
            _ = $0.insert(id)
        }
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
    /// Returns a sample maintenance mode system alert suitable for use in previews
    /// and tests.
    public static var sampleMaintenance: Self {
        .init(
            id: "maintenance_mode",
            title: "Undergoing Maintenance",
            message: "We are undergoing maintenance. Thank you for your patience.",
            isDismissable: true
        )
    }

    /// Returns a sample unsupported app version alert suitable for use in previews
    /// and tests.
    public static func sampleUnsupportedAppVersion(longMessage: Bool = false) -> Self {
        .init(
            id: "unsupported_app_version",
            title: "Unsupported App Version",
            message: longMessage
                ? "This version of the app is no longer supported. Please update to the latest version. This version of the app is no longer supported. Please update to the latest version. This version of the app is no longer supported. Please update to the latest version. This version of the app is no longer supported. Please update to the latest version. This version of the app is no longer supported. Please update to the latest version. This version of the app is no longer supported. Please update to the latest version. This version of the app is no longer supported. Please update to the latest version. This version of the app is no longer supported. Please update to the latest version."
                : "This version of the app is no longer supported. Please update to the latest version.",
            isDismissable: false,
            imageUrl: appIcon,
            ctaUrl: URL(string: "https://www.example.com")
        )
    }

    /// Returns a sample unsupported app version alert with inline links suitable
    /// for use in previews and tests.
    public static var sampleUnsupportedAppVersionWithLinks: Self {
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

    /// Returns a sample unsupported app version alert suitable for use in previews
    /// and tests.
    ///
    /// ```
    /// {
    ///     "id": "unsupported_app_version",
    ///     "title": "New Version Available",
    ///     "message": "Please update your app to enjoy the latest feature enhancements.",
    ///     "dismissable": true,
    ///     "image_url": "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/ce/9a/05/ce9a05d9-dec5-92c8-e6fa-3c4551a856b1/AppIcon-Release-0-2x_U007euniversal-0-4-0-0-85-220-0.png/460x0w.png",
    ///     "cta_title": "Update Now",
    ///     "cta_url": "https://apps.apple.com/us/app/apple-developer/id640199958"
    /// }
    /// ```
    public static var sampleNewVersionAvailable: Self {
        .init(
            id: "unsupported_app_version",
            title: "New Version Available",
            message: "Please update your app to enjoy the latest feature enhancements.",
            isDismissable: true,
            imageUrl: appIcon,
            ctaTitle: "Update Now",
            ctaUrl: URL(string: "https://apps.apple.com/us/app/apple-developer/id640199958")
        )
    }

    private static var appIcon: URL {
        URL(string: "https://is1-ssl.mzstatic.com/image/thumb/Purple221/v4/ce/9a/05/ce9a05d9-dec5-92c8-e6fa-3c4551a856b1/AppIcon-Release-0-2x_U007euniversal-0-4-0-0-85-220-0.png/460x0w.png")!
    }
}
#endif
