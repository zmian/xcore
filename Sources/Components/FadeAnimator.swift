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

public class FadeAnimator: CustomViewControllerTransition {
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

    public override func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        return transitionDuration
    }

    public override func animatePresentation(transitionContext ctx: TransitionContext) {
        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        ctx.sourceViewController.view.frame      = ctx.containerView.bounds
        ctx.destinationViewController.view.frame = ctx.containerView.bounds

        // Add destination view to container
        ctx.containerView.addSubview(ctx.destinationViewController.view)

        if fadeIn {
            animateBounceFadeInOrFadeIn(ctx.destinationViewController, transitionContext: ctx)
        } else {
            ctx.completeTransition()
        }
    }

    public override func animateDismissal(transitionContext ctx: TransitionContext) {
        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        ctx.sourceViewController.view.frame      = ctx.containerView.bounds
        ctx.destinationViewController.view.frame = ctx.containerView.bounds

        if fadeOut {
            animateBounceFadeOutOrFadeOut(ctx.sourceViewController, transitionContext: ctx)
        } else {
            ctx.completeTransition()
        }
    }

    // MARK: FadeIn

    private func animateBounceFadeInOrFadeIn(destinationViewController: UIViewController, transitionContext: TransitionContext) {
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
                transitionContext.completeTransition()
            })
        })
    }

    private func animateFadeIn(destinationViewController: UIViewController, transitionContext: TransitionContext) {
        destinationViewController.view.alpha = 0
        UIView.animateWithDuration(fadeInDuration, animations: {
            destinationViewController.view.alpha = 1
        }, completion: { _ in
            transitionContext.completeTransition()
        })
    }

    // MARK: FadeOut

    private func animateBounceFadeOutOrFadeOut(sourceViewController: UIViewController, transitionContext: TransitionContext) {
        guard let fadeAnimatorBounceContainerView = (sourceViewController as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeOut(sourceViewController, transitionContext: transitionContext)
            return
        }

        UIView.animateWithDuration(fadeOutDuration, animations: {
            sourceViewController.view.alpha = 0
            fadeAnimatorBounceContainerView.transform = CGAffineTransformMakeScale(0.9, 0.9)
        }, completion: { _ in
            transitionContext.completeTransition()
        })
    }

    private func animateFadeOut(sourceViewController: UIViewController, transitionContext: TransitionContext) {
        UIView.animateWithDuration(fadeOutDuration, animations: {
            sourceViewController.view.alpha = 0
        }, completion: { _ in
            transitionContext.completeTransition()
        })
    }
}
