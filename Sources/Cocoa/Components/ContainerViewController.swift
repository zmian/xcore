//
// ContainerViewController.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A container class to manage the lifecycle of the child view controllers
/// and ensure that the appropriate events are fired to keep the state in sync
/// with the parent view controller.
///
/// `UIViewController.shouldAutomaticallyForwardAppearanceMethods` automatically
/// handles most of the lifecycle events. However, there are few shortcoming to
/// that property. For example, it doesn't correctly update the value of
/// `isMovingFromParent` property to reflect it's proper state based
/// on the parent view controller.
open class ContainerViewController: UIViewController {
    /// The view controllers currently being managed the container view.
    open var viewControllers: [UIViewController] {
        []
    }

    open override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers.forEach {
            addViewController($0, enableConstraints: true)
        }
    }

    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewControllers.forEach {
            $0.beginAppearanceTransition(true, animated: animated)
        }
    }

    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewControllers.forEach {
            $0.endAppearanceTransition()
        }
    }

    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        if isBeingPopped {
            viewControllers.forEach {
                $0.willMove(toParent: nil)
            }
        }

        viewControllers.forEach {
            $0.beginAppearanceTransition(false, animated: animated)
        }
    }

    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if isBeingPopped {
            viewControllers.forEach {
                removeViewController($0, animated: animated)
            }
        }

        viewControllers.forEach {
            $0.endAppearanceTransition()
        }
    }

    open override var shouldAutomaticallyForwardAppearanceMethods: Bool {
        false
    }

    /// Removes the child view controller from its parent.
    private func removeViewController(_ childViewController: UIViewController, animated: Bool) {
        guard childViewController.parent != nil else {
            return
        }

        childViewController.removeFromParent()
        childViewController.view.removeFromSuperview()
    }
}
