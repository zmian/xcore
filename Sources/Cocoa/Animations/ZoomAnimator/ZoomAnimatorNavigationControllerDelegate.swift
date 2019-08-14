//
// ZoomAnimatorNavigationControllerDelegate.swift
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
        return zoomInteractiveTransition.interactionController
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
