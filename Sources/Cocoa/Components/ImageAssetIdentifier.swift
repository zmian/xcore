//
// ImageAssetIdentifier.swift
//
// Copyright © 2015 Zeeshan Mian
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

/// A convenience function to get resource name from `.xcassets`.
public func r(_ assetIdentifier: ImageAssetIdentifier) -> String {
    return assetIdentifier.rawValue
}

// MARK: - Xcore Buit-in Assets

private func propertyName(name: String = #function) -> ImageAssetIdentifier {
    return ImageAssetIdentifier(rawValue: name, bundle: .xcore)
}

extension ImageAssetIdentifier {
    static var disclosureIndicator: ImageAssetIdentifier { return propertyName() }
    static var collectionViewCellDeleteIcon: ImageAssetIdentifier { return propertyName() }
    static var reorderTableViewCellShadowTop: ImageAssetIdentifier { return propertyName() }
    static var reorderTableViewCellShadowBottom: ImageAssetIdentifier { return propertyName() }
    static var checkmarkIcon: ImageAssetIdentifier { return propertyName() }
    static var checkmarkIconFilled: ImageAssetIdentifier { return propertyName() }
    static var checkmarkIconUnfilled: ImageAssetIdentifier { return propertyName() }
    static var caretDirectionUp: ImageAssetIdentifier { return propertyName() }
    static var caretDirectionDown: ImageAssetIdentifier { return propertyName() }
    static var caretDirectionBack: ImageAssetIdentifier { return propertyName() }
    static var caretDirectionForward: ImageAssetIdentifier { return propertyName() }
}
