//
// ImageAssetIdentifier.swift
//
// Copyright © 2015 Xcore
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

import UIKit

extension Bundle {
    /// Method for creating or retrieving bundle instances.
    public static var xcore: Bundle {
        return Bundle(for: DynamicTableView.self)
    }
}

public struct ImageAssetIdentifier: RawRepresentable, CustomStringConvertible, Equatable {
    public let rawValue: String
    public let bundle: Bundle?

    /// A convenience initializer for `.xcassets` resource in the `.main` bundle.
    ///
    /// - Parameter rawValue: The name of the resource in `.xcassets`.
    public init(rawValue: String) {
        self.rawValue = rawValue
        self.bundle = .main
    }

    /// An initializer for `.xcassets` resource in the given `bundle`.
    ///
    /// - Parameters:
    ///   - rawValue: The name of the resource in `.xcassets`.
    ///   - bundle: The bundle for the `.xcassets`.
    public init(rawValue: String, bundle: Bundle) {
        self.rawValue = rawValue
        self.bundle = bundle
    }

    public var description: String {
        return rawValue
    }
}

extension ImageAssetIdentifier: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) {
        self.init(rawValue: value)
    }
}

extension ImageAssetIdentifier: ImageRepresentable {
    public var imageSource: ImageSourceType {
        return .url(rawValue)
    }
}

// MARK: - Convenience Extensions

extension UIImage {
    public convenience init(assetIdentifier: ImageAssetIdentifier) {
        self.init(named: assetIdentifier.rawValue, in: assetIdentifier.bundle, compatibleWith: nil)!
    }

    public static func tinted(assetIdentifier: ImageAssetIdentifier, tintColor: UIColor, renderingMode: UIImage.RenderingMode = .alwaysOriginal) -> UIImage {
        return UIImage(assetIdentifier: assetIdentifier).tintColor(tintColor).withRenderingMode(renderingMode)
    }
}

extension UIImageView {
    public convenience init(assetIdentifier: ImageAssetIdentifier) {
        self.init()
        setImage(assetIdentifier) { [weak self] image in
            guard let strongSelf = self else { return }
            strongSelf.image = image
        }
    }
}

extension TargetActionBlockRepresentable where Self: UIBarButtonItem {
    public init(assetIdentifier: ImageAssetIdentifier, accessibilityIdentifier: String? = nil, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(image: UIImage(assetIdentifier: assetIdentifier), handler)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

extension ControlTargetActionBlockRepresentable where Self: UIButton {
    public init(assetIdentifier: ImageAssetIdentifier, accessibilityIdentifier: String? = nil, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(image: UIImage(assetIdentifier: assetIdentifier), handler)
        self.accessibilityIdentifier = accessibilityIdentifier
    }
}

/// A convenience function to get resource.
public func r(_ assetIdentifier: ImageAssetIdentifier) -> ImageAssetIdentifier {
    return assetIdentifier
}

// MARK: - Xcore Buit-in Assets

extension ImageAssetIdentifier {
    private static func propertyName(name: String = #function) -> ImageAssetIdentifier {
        return ImageAssetIdentifier(rawValue: name, bundle: .xcore)
    }

    // MARK: Private
    static var collectionViewCellDeleteIcon: ImageAssetIdentifier { return propertyName() }
    static var reorderTableViewCellShadowTop: ImageAssetIdentifier { return propertyName() }
    static var reorderTableViewCellShadowBottom: ImageAssetIdentifier { return propertyName() }

    // MARK: Carets
    static var caretDirectionUp: ImageAssetIdentifier { return propertyName() }
    static var caretDirectionDown: ImageAssetIdentifier { return propertyName() }
    static var caretDirectionBack: ImageAssetIdentifier { return propertyName() }
    static var caretDirectionForward: ImageAssetIdentifier { return propertyName() }

    // MARK: Shared UI Elements
    public static var closeIcon: ImageAssetIdentifier { return propertyName() }
    public static var closeIconFilled: ImageAssetIdentifier { return propertyName() }

    public static var disclosureIndicator: ImageAssetIdentifier { return propertyName() }
    public static var disclosureIndicatorFilled: ImageAssetIdentifier { return propertyName() }

    /// Launch screen view uses this to automatically display the launch screen
    /// icon. This must be present in `.main` bundle before using the
    /// `LaunchScreenView`.
    public static var launchScreenIcon: ImageAssetIdentifier { return #function }

    // MARK: Navigation

    /// Icon used to replace navigation bar back arrow
    public static var navigationBarBackArrow: ImageAssetIdentifier { return propertyName() }
    public static var navigationBackArrow: ImageAssetIdentifier { return propertyName() }
    public static var navigationForwardArrow: ImageAssetIdentifier { return propertyName() }

    // MARK: Arrows
    public static var arrowRightIcon: ImageAssetIdentifier { return propertyName() }
    public static var arrowLeftIcon: ImageAssetIdentifier { return propertyName() }

    public static var filterSelectionIndicatorArrowIcon: ImageAssetIdentifier { return propertyName() }
    public static var info: ImageAssetIdentifier { return propertyName() }
    public static var locationIcon: ImageAssetIdentifier { return propertyName() }
    public static var searchIcon: ImageAssetIdentifier { return propertyName() }
    public static var validationErrorIcon: ImageAssetIdentifier { return propertyName() }

}

// MARK: - Xcore Buit-in Overridable Assets

extension ImageAssetIdentifier {
    // MARK: Checkmarks
    public static var checkmarkIcon = propertyName(name: "checkmarkIcon")
    public static var checkmarkIconFilled = propertyName(name: "checkmarkIconFilled")
    public static var checkmarkIconUnfilled = propertyName(name: "checkmarkIconUnfilled")

    public static var moreIcon = propertyName(name: "moreIcon")

    // MARK: Biometrics ID
    public static var biometricsFaceIDIcon = propertyName(name: "biometricsFaceIDIcon")
    public static var biometricsTouchIDIcon = propertyName(name: "biometricsTouchIDIcon")
}
