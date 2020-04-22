//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
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
            UIImage(assetIdentifier: assetIdentifier)
        }

        public var selectedImage: UIImage {
            let selectedImage = ImageAssetIdentifier(
                rawValue: assetIdentifier.rawValue + "Selected",
                bundle: assetIdentifier.bundle
            )

            return UIImage(assetIdentifier: selectedImage).withRenderingMode(selectedImageRenderingMode)
        }

        public func viewController() -> UIViewController {
            _viewController()
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
        allCases.first { viewController.isKind(of: $0.viewControllerType) }
    }
}

// MARK: - Equatable

extension UITabBarController.TabItem: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

// MARK: - Hashable

extension UITabBarController.TabItem: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
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
