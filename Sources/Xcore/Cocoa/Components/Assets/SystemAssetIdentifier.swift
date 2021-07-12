//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import SwiftUI

// MARK: - SystemAssetIdentifier

public struct SystemAssetIdentifier: RawRepresentable, CustomStringConvertible, Equatable {
    public let rawValue: String

    /// An initializer for system symbol image.
    ///
    /// - Parameter rawValue: The name of the system symbol.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }

    public var description: String {
        rawValue
    }
}

extension SystemAssetIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

extension SystemAssetIdentifier: ImageRepresentable {
    public var imageSource: ImageSourceType {
        .uiImage(UIImage(system: self))
    }
}

// MARK: - Image

extension Image {
    /// Creates a system symbol image.
    ///
    /// This initializer creates an image using a system-provided symbol. To create
    /// a custom symbol image from your app’s asset catalog, use `init(_:)` instead.
    ///
    /// - Parameter system: The name of the system symbol image. Use the SF Symbols
    ///   app to look up the names of system symbol images.
    public init(system: SystemAssetIdentifier) {
        self.init(systemName: system.rawValue)
    }
}

// MARK: - UIImage

extension UIImage {
    /// Creates an image object that contains a system symbol image.
    ///
    /// - Parameter system: The name of the system symbol image. Use the SF Symbols
    ///   app to look up the names of system symbol images.
    public convenience init(system: SystemAssetIdentifier) {
        self.init(systemName: system.rawValue)!
    }

    /// Creates an image object that contains a system symbol image with the
    /// specified configuration.
    ///
    /// Use this method only to retrieve system-defined symbol images. To retrieve a
    /// custom symbol image stored in your app's asset catalog, use the
    /// [init(named:in:with:)] method instead.
    ///
    /// This method checks the system caches for an image with the specified name
    /// and returns the variant of that image that is best suited for the specified
    /// configuration. If a matching image object is not already in the cache, this
    /// method creates the image from the specified system symbol image. The system
    /// may purge cached image data at any time to free up memory. Purging occurs
    /// only for images that are in the cache but are not currently being used.
    ///
    /// - Parameters:
    ///   - system: The name of the system symbol image. Use the SF Symbols app to
    ///     look up the names of system symbol images.
    ///   - configuration: The image configuration that you want. Use this parameter
    ///     to specify traits and other details that define which variant of the
    ///     image you want. For example, you can request a symbol image with a
    ///     specified weight.
    ///
    /// [init(named:in:with:)]: https://developer.apple.com/documentation/uikit/uiimage/3294226-init
    public convenience init?(system: SystemAssetIdentifier, with configuration: Configuration) {
        self.init(systemName: system.rawValue, withConfiguration: configuration)
    }
}

// MARK: - UIImageView

extension UIImageView {
    public convenience init(system: SystemAssetIdentifier) {
        self.init(image: UIImage(system: system))
    }
}

// MARK: - UIBarButtonItem

extension TargetActionBlockRepresentable where Self: UIBarButtonItem {
    public init(
        system: SystemAssetIdentifier,
        accessibilityIdentifier: String? = nil,
        action: ((_ sender: Self) -> Void)? = nil
    ) {
        self.init(image: UIImage(system: system), action)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - UIButton

extension ControlTargetActionBlockRepresentable where Self: UIButton {
    public init(
        system: SystemAssetIdentifier,
        accessibilityIdentifier: String? = nil,
        action: ((_ sender: Self) -> Void)? = nil
    ) {
        self.init(image: UIImage(system: system), action)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

/// A convenience function to get resource.
public func r(_ system: SystemAssetIdentifier) -> SystemAssetIdentifier {
    system
}
