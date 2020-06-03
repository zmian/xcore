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

    /// Reloads the tabs with an option to reusing existing view controllers.
    ///
    /// - Parameters:
    ///   - tabs: The list of new tabs.
    ///   - reuseExistingViewControllers: A boolean property indicating whether to
    ///     use any existing view controller if the `tabs` list contains any of the
    ///     same tab as before.
    open func reloadTabs(_ tabs: [UITabBarController.TabItem], reuse reuseExistingViewControllers: Bool = true) {
        guard isViewLoaded else {
            return
        }

        viewControllers = reusingViewControllers(for: tabs)
        self.tabs = tabs
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

// MARK: - Reusing

extension XCTabBarController {
    private func reusingViewControllers(for newTabs: [UITabBarController.TabItem]) -> [UIViewController] {
        newTabs.map { tab -> UIViewController in
            guard
                let existingTabIndex = tabs.firstIndex(of: tab),
                let existingVC = viewControllers?.at(existingTabIndex)
            else {
                return tab.viewController().embedInNavigationControllerIfNeeded()
            }

            return existingVC
        }
    }
}
