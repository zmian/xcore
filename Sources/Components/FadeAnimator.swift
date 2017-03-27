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

open class FadeAnimator: CustomViewControllerTransition {
    fileprivate var transitionDuration: TimeInterval {
        var duration: TimeInterval = 0

        if fadeIn {
            duration = fadeInDuration
        }

        if fadeOut {
            duration += fadeOutDuration
        }

        return duration
    }

    open var fadeInDuration: TimeInterval  = 0.3
    open var fadeOutDuration: TimeInterval = 0.25
    open var fadeIn  = true
    open var fadeOut = true

    open override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return transitionDuration
    }

    open override func animatePresentation(transitionContext ctx: TransitionContext) {
        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        ctx.sourceViewController.view.frame      = ctx.containerView.bounds
        ctx.destinationViewController.view.frame = ctx.containerView.bounds

        // Add destination view to container
        ctx.containerView.addSubview(ctx.destinationViewController.view)

        if fadeIn {
            animateBounceFadeInOrFadeIn(transitionContext: ctx)
        } else {
            ctx.completeTransition()
        }
    }

    open override func animateDismissal(transitionContext ctx: TransitionContext) {
        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        ctx.sourceViewController.view.frame      = ctx.containerView.bounds
        ctx.destinationViewController.view.frame = ctx.containerView.bounds

        if fadeOut {
            animateBounceFadeOutOrFadeOut(transitionContext: ctx)
        } else {
            ctx.completeTransition()
        }
    }

    // MARK: FadeIn

    fileprivate func animateBounceFadeInOrFadeIn(transitionContext ctx: TransitionContext) {
        guard let fadeAnimatorBounceContainerView = (ctx.destinationViewController as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeIn(transitionContext: ctx)
            return
        }

        ctx.destinationViewController.view.alpha = 0
        fadeAnimatorBounceContainerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: fadeInDuration, animations: {
            ctx.destinationViewController.view.alpha = 1
            fadeAnimatorBounceContainerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                fadeAnimatorBounceContainerView.transform = .identity
            }, completion: { _ in
                ctx.completeTransition()
            })
        })
    }

    fileprivate func animateFadeIn(transitionContext ctx: TransitionContext) {
        ctx.destinationViewController.view.alpha = 0
        UIView.animate(withDuration: fadeInDuration, animations: {
            ctx.destinationViewController.view.alpha = 1
        }, completion: { _ in
            ctx.completeTransition()
        })
    }

    // MARK: FadeOut

    fileprivate func animateBounceFadeOutOrFadeOut(transitionContext ctx: TransitionContext) {
        guard let fadeAnimatorBounceContainerView = (ctx.sourceViewController as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeOut(transitionContext: ctx)
            return
        }

        UIView.animate(withDuration: fadeOutDuration, animations: {
            ctx.sourceViewController.view.alpha = 0
            fadeAnimatorBounceContainerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            ctx.completeTransition()
        })
    }

    fileprivate func animateFadeOut(transitionContext ctx: TransitionContext) {
        UIView.animate(withDuration: fadeOutDuration, animations: {
            ctx.sourceViewController.view.alpha = 0
        }, completion: { _ in
            ctx.completeTransition()
        })
    }
}
