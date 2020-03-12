//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

open class ZoomAnimator: TransitionAnimator {
    private let source: ZoomAnimatorSource
    private let destination: ZoomAnimatorDestination

    public required init(source: ZoomAnimatorSource, destination: ZoomAnimatorDestination, direction: AnimationDirection) {
        self.source = source
        self.destination = destination
        super.init()
        self.direction = direction
    }

    open override func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        direction == .in ? source.zoomAnimatorSourceDuration : destination.zoomAnimatorDestinationDuration
    }

    open override func transition(context: TransitionContext, direction: AnimationDirection) {
        switch direction {
            case .in:
                animateTransitionForPush(context)
            case .out:
                animateTransitionForPop(context)
        }
    }

    private func animateTransitionForPush(_ context: TransitionContext) {
        guard let sourceView = context.from.view, let destinationView = context.to.view else {
            return context.completeTransition()
        }

        let containerView = context.containerView
        let transitioningImageView = transitioningPushImageView()

        containerView.backgroundColor = sourceView.backgroundColor
        sourceView.alpha = 1
        destinationView.alpha = 0

        if direction == .out {
            containerView.insertSubview(destinationView, belowSubview: sourceView)
        }
        containerView.addSubview(transitioningImageView)

        source.zoomAnimatorSourceStateChanged(state: .began)
        destination.zoomAnimatorDestinationStateChanged(state: .began)
        let destinationViewFrame = destination.zoomAnimatorDestinationViewFrame(direction: direction)

        source.zoomAnimatorSourceAnimation(animations: {
            sourceView.alpha = 0
            destinationView.alpha = 1
            transitioningImageView.frame = destinationViewFrame
        }, completion: {
            sourceView.alpha = 1
            transitioningImageView.alpha = 0
            transitioningImageView.removeFromSuperview()
            self.source.zoomAnimatorSourceStateChanged(state: .ended)
            self.destination.zoomAnimatorDestinationStateChanged(state: .ended)
            context.completeTransition()
        })
    }

    private func animateTransitionForPop(_ context: TransitionContext) {
        guard let sourceView = context.to.view, let destinationView = context.from.view else {
            return context.completeTransition()
        }

        let containerView = context.containerView
        let transitioningImageView = transitioningPopImageView()

        containerView.backgroundColor = destinationView.backgroundColor
        destinationView.alpha = 1
        sourceView.alpha = 0

        if direction == .out {
            containerView.insertSubview(sourceView, belowSubview: destinationView)
        }
        containerView.addSubview(transitioningImageView)

        source.zoomAnimatorSourceStateChanged(state: .began)
        destination.zoomAnimatorDestinationStateChanged(state: .began)
        let sourceViewFrame = destination.zoomAnimatorDestinationViewFrame(direction: direction)

        if transitioningImageView.frame.maxY < 0 {
            transitioningImageView.frame.origin.y = -transitioningImageView.frame.height
        }

        destination.zoomAnimatorDestinationAnimation(animations: {
            destinationView.alpha = 0
            sourceView.alpha = 1
            transitioningImageView.frame = sourceViewFrame
        }, completion: {
            destinationView.alpha = 1
            transitioningImageView.removeFromSuperview()
            self.source.zoomAnimatorSourceStateChanged(state: .ended)
            self.destination.zoomAnimatorDestinationStateChanged(state: .ended)
            context.completeTransition()
        })
    }

    private func transitioningPushImageView() -> UIImageView {
        let imageView = source.zoomAnimatorSourceView().snapshotImageView()
        imageView.frame = source.zoomAnimatorSourceViewFrame(direction: direction)
        return imageView
    }

    private func transitioningPopImageView() -> UIImageView {
        let imageView = source.zoomAnimatorSourceView().snapshotImageView()
        imageView.frame = destination.zoomAnimatorDestinationViewFrame(direction: direction)
        return imageView
    }
}
