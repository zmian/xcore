//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
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

    open override func transitionDuration(
        using transitionContext: UIViewControllerContextTransitioning?
    ) -> TimeInterval {
        direction == .in ? fadeInDuration : fadeOutDuration
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

    // MARK: - FadeIn

    private func animateBounceFadeInOrFadeIn(context: TransitionContext) {
        guard let bounceContainerView = (context.to as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeIn(context: context)
            return
        }

        context.to.view.alpha = 0
        bounceContainerView.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: fadeInDuration) {
            context.to.view.alpha = 1
            bounceContainerView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                bounceContainerView.transform = .identity
            } completion: { _ in
                context.completeTransition()
            }
        }
    }

    private func animateFadeIn(context: TransitionContext) {
        context.to.view.alpha = 0
        UIView.animate(withDuration: fadeInDuration) {
            context.to.view.alpha = 1
        } completion: { _ in
            context.completeTransition()
        }
    }

    // MARK: - FadeOut

    private func animateBounceFadeOutOrFadeOut(context: TransitionContext) {
        guard let bounceContainerView = (context.from as? FadeAnimatorBounceable)?.fadeAnimatorBounceContainerView() else {
            animateFadeOut(context: context)
            return
        }

        UIView.animate(withDuration: fadeOutDuration) {
            context.from.view.alpha = 0
            bounceContainerView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        } completion: { _ in
            context.completeTransition()
        }
    }

    private func animateFadeOut(context: TransitionContext) {
        UIView.animate(withDuration: fadeOutDuration) {
            context.from.view.alpha = 0
        } completion: { _ in
            context.completeTransition()
        }
    }
}
