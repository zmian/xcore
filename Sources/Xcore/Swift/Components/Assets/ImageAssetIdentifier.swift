//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - ImageAssetIdentifier

public struct ImageAssetIdentifier: RawRepresentable, CustomStringConvertible, Hashable {
    public let rawValue: String
    public let bundle: Bundle
    public var accessibilityLabel: String?

    /// Creates a reference to the `.xcassets` resource in the `.main` bundle.
    ///
    /// - Parameter rawValue: The name of the resource in `.xcassets`.
    public init(rawValue: String) {
        self.rawValue = rawValue
        self.bundle = .main
        self.accessibilityLabel = nil
    }

    /// Creates a reference to the `.xcassets` resource in the given `bundle`.
    ///
    /// - Parameters:
    ///   - rawValue: The name of the resource in `.xcassets`.
    ///   - bundle: The bundle for the `.xcassets`.
    ///   - accessibilityLabel: A succinct label that identifies the accessibility
    ///     element, in a localized string.
    public init(rawValue: String, bundle: Bundle, accessibilityLabel: String? = nil) {
        self.rawValue = rawValue
        self.bundle = bundle
        self.accessibilityLabel = accessibilityLabel
    }

    public var description: String {
        rawValue
    }
}

extension ImageAssetIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

extension ImageAssetIdentifier: ImageRepresentable {
    public var imageSource: ImageSourceType {
        .url(rawValue)
    }
}

// MARK: - Image

extension Image {
    public init(assetIdentifier: ImageAssetIdentifier) {
        guard let accessibilityLabel = assetIdentifier.accessibilityLabel else {
            self.init(
                assetIdentifier.rawValue,
                bundle: assetIdentifier.bundle
            )
            return
        }

        self.init(
            assetIdentifier.rawValue,
            bundle: assetIdentifier.bundle,
            label: Text(accessibilityLabel)
        )
    }
}

// MARK: - UIImage

extension UIImage {
    public convenience init(assetIdentifier: ImageAssetIdentifier) {
        self.init(
            named: assetIdentifier.rawValue,
            in: assetIdentifier.bundle,
            compatibleWith: nil
        )!
    }
}

// MARK: - UIImageView

extension UIImageView {
    public convenience init(assetIdentifier: ImageAssetIdentifier?) {
        self.init()
        setImage(assetIdentifier) { [weak self] image in
            guard let self else { return }
            self.image = image
        }
    }
}

/// A convenience function to get resource.
public func r(_ assetIdentifier: ImageAssetIdentifier) -> ImageAssetIdentifier {
    assetIdentifier
}

// MARK: - Buit-in Assets

extension ImageAssetIdentifier {
    private static func propertyName(_ name: String = #function) -> Self {
        .init(rawValue: name, bundle: .xcore)
    }

    public static var filterIcon: Self { propertyName() }
}
