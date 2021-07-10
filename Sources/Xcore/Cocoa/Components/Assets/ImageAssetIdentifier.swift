//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import SwiftUI

// MARK: - ImageAssetIdentifier

public struct ImageAssetIdentifier: RawRepresentable, CustomStringConvertible, Equatable {
    public let rawValue: String
    public let bundle: Bundle
    public var accessibilityLabel: String?

    /// A convenience initializer for `.xcassets` resource in the `.main` bundle.
    ///
    /// - Parameter rawValue: The name of the resource in `.xcassets`.
    public init(rawValue: String) {
        self.rawValue = rawValue
        self.bundle = .main
        self.accessibilityLabel = nil
    }

    /// An initializer for `.xcassets` resource in the given `bundle`.
    ///
    /// - Parameters:
    ///   - rawValue: The name of the resource in `.xcassets`.
    ///   - bundle: The bundle for the `.xcassets`.
    ///   - accessibilityLabel: A succinct label that identifies the accessibility
    ///                         element, in a localized string.
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
        self.init(named: assetIdentifier.rawValue, in: assetIdentifier.bundle, compatibleWith: nil)!
    }

    public static func tinted(assetIdentifier: ImageAssetIdentifier, tintColor: UIColor, renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage {
        UIImage(assetIdentifier: assetIdentifier).tintColor(tintColor).withRenderingMode(renderingMode)
    }
}

// MARK: - UIImageView

extension UIImageView {
    public convenience init(assetIdentifier: ImageAssetIdentifier?) {
        self.init()
        setImage(assetIdentifier) { [weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.image = image
        }
    }
}

// MARK: - UIBarButtonItem

extension TargetActionBlockRepresentable where Self: UIBarButtonItem {
    public init(assetIdentifier: ImageAssetIdentifier, accessibilityIdentifier: String? = nil, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(image: UIImage(assetIdentifier: assetIdentifier), handler)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

// MARK: - UIButton

extension ControlTargetActionBlockRepresentable where Self: UIButton {
    public init(assetIdentifier: ImageAssetIdentifier, accessibilityIdentifier: String? = nil, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(image: UIImage(assetIdentifier: assetIdentifier), handler)
        self.accessibilityIdentifier = accessibilityIdentifier
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

    // MARK: - Shared UI Elements
    public static var disclosureIndicator: Self { propertyName() }
    public static var disclosureIndicatorFilled: Self { propertyName() }

    /// Launch screen view uses this to automatically display the launch screen
    /// icon. This must be present in `.main` bundle before using the
    /// `LaunchScreenView`.
    public static var launchScreenIcon: Self { #function }

    // MARK: - Navigation

    /// Icon used to replace navigation bar back arrow
    public static var navigationBarBackArrow: Self { propertyName() }
    public static var navigationBackArrow: Self { propertyName() }
    public static var navigationForwardArrow: Self { propertyName() }

    // MARK: - Arrows
    public static var arrowRightIcon: Self { propertyName() }
    public static var arrowLeftIcon: Self { propertyName() }

    public static var filterSelectionIndicatorArrowIcon: Self { propertyName() }
}
