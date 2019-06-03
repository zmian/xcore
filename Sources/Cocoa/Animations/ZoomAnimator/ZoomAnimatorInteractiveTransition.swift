//
// ZoomAnimatorInteractiveTransition.swift
// Based on https://github.com/WorldDownTown/ZoomTransitioning
//
// Copyright © 2017 Xcore
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

final class ZoomAnimatorInteractiveTransition: UIPercentDrivenInteractiveTransition {
    weak var navigationController: UINavigationController?
    weak var zoomPopGestureRecognizer: UIScreenEdgePanGestureRecognizer?
    private weak var viewController: UIViewController?
    private var interactive = false

    var interactionController: ZoomAnimatorInteractiveTransition? {
        return interactive ? self : nil
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
        return otherGestureRecognizer === navigationController?.interactivePopGestureRecognizer
    }
}
