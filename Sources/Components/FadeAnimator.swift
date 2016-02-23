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

public protocol FadeAnimatorBounceable {
    func fadeAnimatorBounceContainerView() -> UIView
}

public class FadeAnimatorDelegate: NSObject, UIViewControllerTransitioningDelegate {

    let transition = FadeAnimator()
    public var fadeInDuration: NSTimeInterval  = 0.3
    public var fadeOutDuration: NSTimeInterval = 0.25
    public var fadeIn  = true
    public var fadeOut = true

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.fadeInDuration  = fadeInDuration
        transition.fadeOutDuration = fadeOutDuration
        transition.fadeIn  = fadeIn
        transition.fadeOut = fadeOut
        return transition
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.fadeInDuration  = fadeInDuration
        transition.fadeOutDuration = fadeOutDuration
        transition.fadeIn  = fadeIn
        transition.fadeOut = fadeOut
        return transition
    }
}

public class FadeAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    private var transitionDuration: NSTimeInterval {
        var duration: NSTimeInterval = 0

        if fadeIn {
            duration = fadeInDuration
        }

        if fadeOut {
            duration += fadeOutDuration
        }

        return duration
    }

    public var fadeInDuration: NSTimeInterval  = 0.3
    public var fadeOutDuration: NSTimeInterval = 0.25
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
                  containerView             = transitionContext.containerView() else { transitionContext.completeTransition(!transitionContext.transitionWasCancelled()); return }

        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        sourceViewController.view.frame      = containerView.bounds
        destinationViewController.view.frame = containerView.bounds

        // Add destination view to container
        containerView.addSubview(destinationViewController.view)

        if fadeIn {
            animateBounceFadeInOrFadeIn(destinationViewController, transitionContext: transitionContext)
        } else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }

    private func animateDismissal(transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceViewController      = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
                  destinationViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
                  containerView             = transitionContext.containerView() else { transitionContext.completeTransition(!transitionContext.transitionWasCancelled()); return }

        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        sourceViewController.view.frame      = containerView.bounds
        destinationViewController.view.frame = containerView.bounds

        if fadeOut {
            animateBounceFadeOutOrFadeOut(sourceViewController, transitionContext: transitionContext)
        } else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        }
    }

    // MARK: FadeIn

    private func animateBounceFadeInOrFadeIn(destinationViewController: UIViewController, transitionContext: UIViewControllerContextTransitioning) {
        guard let fadeAnimatorBounceContainerView = (destinationViewController as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeIn(destinationViewController, transitionContext: transitionContext)
            return
        }

        destinationViewController.view.alpha = 0
        fadeAnimatorBounceContainerView.transform = CGAffineTransformMakeScale(0.5, 0.5)
        UIView.animateWithDuration(fadeInDuration, animations: {
            destinationViewController.view.alpha = 1
            fadeAnimatorBounceContainerView.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }, completion: { _ in
            UIView.animateWithDuration(0.2, animations: {
                fadeAnimatorBounceContainerView.transform = CGAffineTransformIdentity
            }, completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
            })
        })
    }

    private func animateFadeIn(destinationViewController: UIViewController, transitionContext: UIViewControllerContextTransitioning) {
        destinationViewController.view.alpha = 0
        UIView.animateWithDuration(fadeInDuration, animations: {
            destinationViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }

    // MARK: FadeOut

    private func animateBounceFadeOutOrFadeOut(sourceViewController: UIViewController, transitionContext: UIViewControllerContextTransitioning) {
        guard let fadeAnimatorBounceContainerView = (sourceViewController as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeOut(sourceViewController, transitionContext: transitionContext)
            return
        }

        UIView.animateWithDuration(fadeOutDuration, animations: {
            sourceViewController.view.alpha = 0
            fadeAnimatorBounceContainerView.transform = CGAffineTransformMakeScale(0.9, 0.9)
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }

    private func animateFadeOut(sourceViewController: UIViewController, transitionContext: UIViewControllerContextTransitioning) {
        UIView.animateWithDuration(fadeOutDuration, animations: {
            sourceViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
        })
    }
}
