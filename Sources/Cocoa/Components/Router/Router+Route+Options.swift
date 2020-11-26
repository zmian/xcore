//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension Router.Route {
    public struct Options {
        public enum Transition {
            /// Use modal on iPad and push on iPhone.
            case automatic
            case push
            case modal
        }

        public let transition: Transition
        public let isAnimated: Bool

        public init(transition: Transition, animated: Bool = true) {
            self.transition = transition
            self.isAnimated = animated
        }
    }
}

// MARK: - Options: Convenience

extension Router.Route.Options {
    // Automatic

    public static var automatic: Self {
        .automatic(animated: true)
    }

    public static func automatic(animated: Bool) -> Self {
        .init(transition: .automatic, animated: animated)
    }

    // Push

    public static var push: Self {
        .push(animated: true)
    }

    public static func push(animated: Bool) -> Self {
        .init(transition: .push, animated: animated)
    }

    /// Push the given route without animation.
    public static var notAnimated: Self {
        .push(animated: false)
    }

    // Modal

    public static var modal: Self {
        .modal(animated: true)
    }

    public static func modal(animated: Bool) -> Self {
        .init(transition: .modal, animated: animated)
    }
}

// MARK: - Display

extension Router.Route.Options {
    private var isModal: Bool {
        switch transition {
            case .push:
                return false
            case .modal:
                return true
            case .automatic:
                return UIDevice.current.userInterfaceIdiom == .pad
        }
    }

    /// Show the view controller on the given navigation controller.
    func show(_ vc: UIViewController, navigationController: UINavigationController) {
        guard isModal else {
            navigationController.pushViewController(vc, animated: isAnimated)
            return
        }

        // Embed the view controller in navigation controller so the router instance when
        // presented modally can be used. Router requires navigation controller.
        let vc = vc.embedInNavigationControllerIfNeeded()
        navigationController.present(vc, animated: isAnimated)
    }

    /// Show the list of view controller on the given navigation controller.
    func show(_ vcs: [UIViewController], navigationController: UINavigationController) {
        guard isModal else {
            navigationController.pushViewController(vcs, animated: isAnimated)
            return
        }

        // Embed the view controllers in navigation controller so the router instance
        // when presented modally can be used. Router requires navigation controller.
        let nvc = NavigationController()
        nvc.setViewControllers(vcs, animated: isAnimated)
        navigationController.present(nvc, animated: isAnimated)
    }
}

// MARK: - Dismiss

extension Router.Route.Options {
    fileprivate func dismiss(navigationController: UINavigationController) {
        if isModal {
            navigationController.dismiss(animated: isAnimated, completion: nil)
        } else {
            navigationController.popViewController(animated: isAnimated)
        }
    }
}

extension Router.Route {
    /// Dismiss the current view controller.
    public static var dismiss: Self {
        .dismiss(options: .push)
    }

    /// Dismiss the current view controller.
    public static func dismiss(options: Options) -> Self {
        .init { _ in
            .custom(options.dismiss)
        }
    }
}
