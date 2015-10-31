//
// FadeAnimator.swift
//
// Copyright © 2015 Zeeshan Mian
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

public class FadeAnimatorDelegate: NSObject, UIViewControllerTransitioningDelegate {

    let transition = FadeAnimator()
    public var transitionDuration: NSTimeInterval = 0.5
    public var fadeInDuration: NSTimeInterval     = 0.5
    public var fadeOutDuration: NSTimeInterval    = 0.5
    public var fadeIn  = true
    public var fadeOut = true

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionDuration = transitionDuration
        transition.fadeInDuration     = fadeInDuration
        transition.fadeOutDuration    = fadeOutDuration
        transition.fadeIn  = fadeIn
        transition.fadeOut = fadeOut
        return transition
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionDuration = transitionDuration
        transition.fadeInDuration     = fadeInDuration
        transition.fadeOutDuration    = fadeOutDuration
        transition.fadeIn  = fadeIn
        transition.fadeOut = fadeOut
        return transition
    }
}

public class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    public var transitionDuration: NSTimeInterval = 0.5
    public var fadeInDuration: NSTimeInterval     = 0.5
    public var fadeOutDuration: NSTimeInterval    = 0.5
    public var fadeIn  = true
    public var fadeOut = true

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        let destinationViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!

        if destinationViewController.isBeingPresented() {
            animatePresentation(transitionContext)
        } else {
            animateDismissal(transitionContext)
        }
    }

    private func animatePresentation(transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceViewController      = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
                  destinationViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                  containerView             = transitionContext.containerView() else { transitionContext.completeTransition(true); return }

        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        sourceViewController.view.frame      = containerView.bounds
        destinationViewController.view.frame = containerView.bounds

        // Add destination view to container
        containerView.addSubview(destinationViewController.view)

        if fadeIn {
            destinationViewController.view.alpha = 0
            UIView.animateWithDuration(fadeInDuration, animations: {
                destinationViewController.view.alpha = 1
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            transitionContext.completeTransition(true)
        }
    }

    private func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceViewController      = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
                  destinationViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                  containerView             = transitionContext.containerView() else { transitionContext.completeTransition(true); return }

        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        sourceViewController.view.frame      = containerView.bounds
        destinationViewController.view.frame = containerView.bounds

        if fadeOut {
            UIView.animateWithDuration(fadeOutDuration, animations: {
                sourceViewController.view.alpha = 0
            }, completion: { _ in
                transitionContext.completeTransition(true)
            })
        } else {
            transitionContext.completeTransition(true)
        }
    }
}
