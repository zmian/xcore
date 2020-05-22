//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// Presents a view controller modally.
public protocol ModallyPresentable {
    /// Returns a bar button item that dismisses `self`.
    func dismissBarButtonItem() -> UIBarButtonItem

    /// Returns the class used to create the `UINavigationController` instance
    /// for this view controller.
    ///
    /// The default value is `UINavigationController.self`.
    var navigationControllerClassWhenModallyPresented: UINavigationController.Type { get }
}

extension ModallyPresentable {
    public var navigationControllerClassWhenModallyPresented: UINavigationController.Type {
        NavigationController.self
    }
}

extension ModallyPresentable where Self: UIViewController {
    /// Returns a bar button item that dismisses `self`.
    public func dismissBarButtonItem() -> UIBarButtonItem {
        UIBarButtonItem(barButtonSystemItem: .cancel).apply {
            $0.accessibilityIdentifier = "dismissButton"
            $0.addAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
    }

    /// Embeds `self` in navigation controller and presents it as modally.
    public func present(presentingViewController: UIViewController? = nil) {
        guard
            let presentingViewController = presentingViewController ??
                UIApplication.sharedOrNil?.keyWindow?.topViewController ??
                UIApplication.sharedOrNil?.delegate?.window??.topViewController
        else {
            return
        }

        navigationItem.rightBarButtonItem = dismissBarButtonItem()
        let NavigationController = navigationControllerClassWhenModallyPresented
        let nvc = NavigationController.init(rootViewController: self)
        nvc.modalPresentationStyle = modalPresentationStyle
        presentingViewController.present(nvc, animated: true)
    }
}
