//
// Xcore
// Based on https://github.com/WorldDownTown/ZoomTransitioning
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

final class ZoomAnimatorInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var navigationController: UINavigationController?
    weak var zoomPopGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private weak var viewController: UIViewController?
    private var interactive = false

    var interactionController: ZoomAnimatorInteractiveTransition? {
        interactive ? self : nil
    }

    @objc func handle(recognizer: UIScreenEdgePanGestureRecognizer) {
        switch recognizer.state {
            case .changed:
                guard let view = recognizer.view else { return }
                let progress = recognizer.translation(in: view).x / view.bounds.width
                update(progress)
            case .cancelled, .ended:
                guard let view = recognizer.view else { return }
                let progress = recognizer.translation(in: view).x / view.bounds.width
                let velocity = recognizer.velocity(in: view).x
                if progress > 0.33 || velocity > 1000.0 {
                    finish()
                } else {
                    if let viewController = viewController {
                        navigationController?.viewControllers.append(viewController)
                        update(0)
                    }
                    cancel()

                    if let viewController = viewController as? ZoomAnimatorDestination {
                        viewController.zoomAnimatorDestinationStateChanged(state: .cancelled)
                    }
                    if let viewController = navigationController?.viewControllers.last as? ZoomAnimatorSource {
                        viewController.zoomAnimatorSourceStateChanged(state: .cancelled)
                    }
                }
                interactive = false
            default:
                break
        }
    }
}

// MARK: UIGestureRecognizerDelegate

extension ZoomAnimatorInteractiveTransition: UIGestureRecognizerDelegate {
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let navigationController = navigationController, navigationController.viewControllers.count > 1 else {
            return false
        }

        let count = navigationController.viewControllers.count
        let fromVC = navigationController.viewControllers[count - 1]
        let toVC = navigationController.viewControllers[count - 2]
        let zoomVCs1 = fromVC is ZoomAnimatorSource && toVC is ZoomAnimatorDestination
        let zoomVCs2 = fromVC is ZoomAnimatorDestination && toVC is ZoomAnimatorSource
        let zoomVCs = zoomVCs1 || zoomVCs2

        if gestureRecognizer === navigationController.interactivePopGestureRecognizer {
            return !zoomVCs
        } else if gestureRecognizer === zoomPopGestureRecognizer {
            if zoomVCs {
                interactive = true
                viewController = navigationController.popViewController(animated: true)
                return true
            }
        }
        return false
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        otherGestureRecognizer === navigationController?.interactivePopGestureRecognizer
    }
}
