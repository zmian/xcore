//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class XCTabBarController: UITabBarController {
    open var tabs: [TabItem] = []

    /// A boolean value that controls whether the scroll-to-top gesture is enabled.
    ///
    /// The scroll-to-top gesture is a tap on the tab bar. When a user makes this
    /// gesture, the system asks the scroll view closest to the status bar to scroll
    /// to the top. If that scroll view is already at the top, nothing happens.
    ///
    /// The default value of `tabBarItemScrollsToTop` is true.
    open var tabBarItemScrollsToTop = true

    open override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        setupTabs()
    }

    private func setupTabs() {
        tabBar.isTransparent = true
        tabBar.backgroundColor = .white
    }

    open func reloadTabs(_ tabs: [UITabBarController.TabItem]) {
        guard isViewLoaded else {
            return
        }

        self.tabs = tabs

        viewControllers = tabs.map {
            NavigationController(rootViewController: $0.viewController())
        }

        tabBar.configure(tabs)
    }

    open func didSelectTabBarItem(_ tabItem: UITabBarController.TabItem) { }
}

// MARK: - UITabBarControllerDelegate

extension XCTabBarController: UITabBarControllerDelegate {
    open func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        tabBarItemScrollsToTop(viewController)
        internalDidSelectTabBarItem(for: getRootViewController(viewController))
        return true
    }

    private func getRootViewController(_ viewController: UIViewController) -> UIViewController {
        guard
            let navigationController = viewController as? UINavigationController,
            let rootViewController = navigationController.rootViewController
        else {
            return viewController
        }

        return rootViewController
    }

    private func tabBarItemScrollsToTop(_ viewController: UIViewController) {
        guard
            tabBarItemScrollsToTop,
            let navigationController = viewController as? UINavigationController,
            let rootViewController = navigationController.rootViewController
        else {
            return
        }

        // Tapping the tab bar item should scroll to the top.
        if let previousViewController = viewControllers?.at(selectedIndex),
            let viewController = rootViewController as? XCComposedCollectionViewController,
            navigationController.viewControllers.count == 1,
            getRootViewController(previousViewController) == viewController
        {
            viewController.scrollToTop()
        }
    }

    private func internalDidSelectTabBarItem(for viewController: UIViewController) {
        guard let tabItem = TabItem.item(for: viewController) else {
            return
        }

        didSelectTabBarItem(tabItem)
    }
}
