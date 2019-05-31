//
// FadeAnimator.swift
//
// Copyright © 2015 Xcore
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

open class FadeAnimator: TransitionAnimator {
    open var fadeInDuration: TimeInterval = 0.3
    open var fadeOutDuration: TimeInterval = 0.25
    open var fadeIn = true
    open var fadeOut = true

    open override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return direction == .in ? fadeInDuration : fadeOutDuration
    }

    open override func transition(context: TransitionContext, direction: AnimationDirection) {
        switch direction {
            case .in:
                if fadeIn {
                    animateBounceFadeInOrFadeIn(context: context)
                } else {
                    context.completeTransition()
                }
            case .out:
                if fadeOut {
                    animateBounceFadeOutOrFadeOut(context: context)
                } else {
                    context.completeTransition()
                }
        }
    }

    // MARK: FadeIn

    private func animateBounceFadeInOrFadeIn(context: TransitionContext) {
        guard let bounceContainerView = (context.to as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeIn(context: context)
            return
        }

        context.to.view.alpha = 0
        bounceContainerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: fadeInDuration, animations: {
            context.to.view.alpha = 1
            bounceContainerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, animations: {
                bounceContainerView.transform = .identity
            }, completion: { _ in
                context.completeTransition()
            })
        })
    }

    private func animateFadeIn(context: TransitionContext) {
        context.to.view.alpha = 0
        UIView.animate(withDuration: fadeInDuration, animations: {
            context.to.view.alpha = 1
        }, completion: { _ in
            context.completeTransition()
        })
    }

    // MARK: FadeOut

    private func animateBounceFadeOutOrFadeOut(context: TransitionContext) {
        guard let bounceContainerView = (context.from as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeOut(context: context)
            return
        }

        UIView.animate(withDuration: fadeOutDuration, animations: {
            context.from.view.alpha = 0
            bounceContainerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }, completion: { _ in
            context.completeTransition()
        })
    }

    private func animateFadeOut(context: TransitionContext) {
        UIView.animate(withDuration: fadeOutDuration, animations: {
            context.from.view.alpha = 0
        }, completion: { _ in
            context.completeTransition()
        })
    }
}
