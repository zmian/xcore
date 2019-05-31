//
// ZoomAnimator.swift
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
        return direction == .in ? source.zoomAnimatorSourceDuration : destination.zoomAnimatorDestinationDuration
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
