//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UITabBarController {
    public struct TabItem: CustomAnalyticsValueConvertible {
        public typealias Identifier = Xcore.Identifier<Self>

        /// A unique id for the tab.
        public let id: Identifier

        /// The asset identifier used for the tab icon.
        public let assetIdentifier: ImageAssetIdentifier

        /// The analytics value for the tab.
        public let analyticsValue: String

        /// The accessibility label for the tab.
        public let accessibilityLabel: String

        /// The type of view controller associated with this tab.
        public let viewControllerType: UIViewController.Type

        /// The view controller associated with this tab.
        public let viewController: () -> UIViewController

        private let selectedImageRenderingMode: UIImage.RenderingMode

        public init(
            id: Identifier,
            image: ImageAssetIdentifier,
            selectedImageRenderingMode: UIImage.RenderingMode = .alwaysTemplate,
            analyticsValue: String? = nil,
            accessibilityLabel: String,
            viewControllerType: UIViewController.Type,
            viewController: @autoclosure @escaping () -> UIViewController
        ) {
            self.id = id
            self.assetIdentifier = image
            self.selectedImageRenderingMode = selectedImageRenderingMode
            self.analyticsValue = analyticsValue ?? id.rawValue.snakecased()
            self.accessibilityLabel = accessibilityLabel
            self.viewControllerType = viewControllerType
            self.viewController = {
                let vc = viewController()
                vc.isTabBarHidden = false
                return vc
            }
        }

        /// The tab icon image derived from the asset identifier.
        public var image: UIImage {
            UIImage(assetIdentifier: assetIdentifier)
        }

        /// The tab icon selected image derived from the asset identifier.
        public var selectedImage: UIImage {
            let selectedImage = ImageAssetIdentifier(
                rawValue: assetIdentifier.rawValue + "Selected",
                bundle: assetIdentifier.bundle
            )

            return UIImage(assetIdentifier: selectedImage).withRenderingMode(selectedImageRenderingMode)
        }

        /// Configures the given item properties from `self`.
        ///
        /// - Parameter item: The item to configure.
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
