//
// Xcore
// Based on https://github.com/WorldDownTown/ZoomTransitioning
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final public class ZoomAnimatorNavigationControllerDelegate: NSObject {
    private let zoomInteractiveTransition = ZoomAnimatorInteractiveTransition()
    private let zoomPopGestureRecognizer = UIScreenEdgePanGestureRecognizer()
}

// MARK: UINavigationControllerDelegate

extension ZoomAnimatorNavigationControllerDelegate: UINavigationControllerDelegate {
    public func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if zoomPopGestureRecognizer.delegate !== zoomInteractiveTransition {
            zoomPopGestureRecognizer.delegate = zoomInteractiveTransition
            zoomPopGestureRecognizer.addTarget(zoomInteractiveTransition, action: #selector(ZoomAnimatorInteractiveTransition.handle(recognizer:)))
            zoomPopGestureRecognizer.edges = .left
            navigationController.view.addGestureRecognizer(zoomPopGestureRecognizer)
            zoomInteractiveTransition.zoomPopGestureRecognizer = zoomPopGestureRecognizer
        }

        if let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer, interactivePopGestureRecognizer.delegate !== zoomInteractiveTransition {
            zoomInteractiveTransition.navigationController = navigationController
            interactivePopGestureRecognizer.delegate = zoomInteractiveTransition
        }
    }

    public func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        zoomInteractiveTransition.interactionController
    }

    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let source = fromVC as? ZoomAnimatorSource, let destination = toVC as? ZoomAnimatorDestination, operation == .push {
            return ZoomAnimator(source: source, destination: destination, direction: .in)
        } else if let source = toVC as? ZoomAnimatorSource, let destination = fromVC as? ZoomAnimatorDestination, operation == .pop {
            return ZoomAnimator(source: source, destination: destination, direction: .out)
        }
        return nil
    }
}
