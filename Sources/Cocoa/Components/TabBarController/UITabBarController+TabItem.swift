//
// UITabBarController+TabItem.swift
//
// Copyright © 2018 Xcore
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

extension UITabBarController {
    public struct TabItem {
        public let id: Identifier<TabItem>
        public let assetIdentifier: ImageAssetIdentifier
        public let accessibilityLabel: String
        public let viewControllerType: UIViewController.Type
        private var _viewController: (() -> UIViewController)!
        private let selectedImageRenderingMode: UIImage.RenderingMode

        public init(
            id: Identifier<TabItem>,
            image: ImageAssetIdentifier,
            selectedImageRenderingMode: UIImage.RenderingMode = .alwaysTemplate,
            accessibilityLabel: String,
            viewControllerType: UIViewController.Type,
            viewController: @autoclosure @escaping () -> UIViewController
        ) {
            self.id = id
            self.assetIdentifier = image
            self.selectedImageRenderingMode = selectedImageRenderingMode
            self.accessibilityLabel = accessibilityLabel
            self.viewControllerType = viewControllerType
            self._viewController = {
                let vc = viewController()
                vc.isTabBarHidden = false
                return vc
            }
        }

        public var image: UIImage {
            return UIImage(assetIdentifier: assetIdentifier)
        }

        public var selectedImage: UIImage {
            let selectedImage = ImageAssetIdentifier(
                rawValue: assetIdentifier.rawValue + "Selected",
                bundle: assetIdentifier.bundle ?? .main
            )

            return UIImage(assetIdentifier: selectedImage).withRenderingMode(selectedImageRenderingMode)
        }

        public func viewController() -> UIViewController {
            return _viewController()
        }

        public func configure(item: UITabBarItem) {
            item.image = image
            item.selectedImage = selectedImage
            // Move the tabbar icon to the middle of tabbar
            item.imageInsets = UIEdgeInsets(top: 6, left: 0, bottom: -6, right: 0)
            item.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 100)
            item.accessibilityLabel = accessibilityLabel
        }
    }
}

// MARK: - CaseIterable

extension UITabBarController.TabItem: CaseIterable {
    public static var allCases: [UITabBarController.TabItem] = []

    public static func item(for viewController: UIViewController) -> UITabBarController.TabItem? {
        return allCases.first { viewController.isKind(of: $0.viewControllerType) }
    }
}

// MARK: - Equatable

extension UITabBarController.TabItem: Equatable {
    public static func == (lhs: UITabBarController.TabItem, rhs: UITabBarController.TabItem) -> Bool {
        return lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension UITabBarController.TabItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
}

// MARK: - UITabBar

extension UITabBar {
    open func configure(_ tabs: [UITabBarController.TabItem]) {
        items?.enumerated().forEach { index, item in
            tabs[index].configure(item: item)
        }
    }
}
