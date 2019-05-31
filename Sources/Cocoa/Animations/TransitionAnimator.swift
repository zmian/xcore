//
// TransitionAnimator.swift
//
// Copyright © 2016 Xcore
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

public enum AnimationDirection {
    case `in`
    case out
}

public enum AnimationState {
    case began
    case cancelled
    case ended
}

open class TransitionContext {
    public let context: UIViewControllerContextTransitioning
    public let to: UIViewController
    public let from: UIViewController
    public let containerView: UIView

    public init?(transitionContext: UIViewControllerContextTransitioning) {
        guard
            let to = transitionContext.viewController(forKey: .to),
            let from = transitionContext.viewController(forKey: .from)
        else {
            return nil
        }

        self.context = transitionContext
        self.to = to
        self.from = from
        self.containerView = transitionContext.containerView
    }

    open func completeTransition() {
        context.completeTransition(!context.transitionWasCancelled)
    }
}

open class TransitionAnimator: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    open var direction: AnimationDirection = .in

    // MARK: UIViewControllerTransitioningDelegate

    open func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        direction = .in
        return self
    }

    open func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        direction = .out
        return self
    }

    // MARK: UIViewControllerAnimatedTransitioning

    open func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let context = TransitionContext(transitionContext: transitionContext) else {
            return transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }

        // Orientation bug fix
        // See: http://stackoverflow.com/a/20061872/351305
        context.from.view.frame = context.containerView.bounds
        context.to.view.frame = context.containerView.bounds

        if direction == .in {
            // Add destination view to container
            context.containerView.addSubview(context.to.view)
        }

        transition(context: context, direction: direction)
    }

    open func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        fatalError(because: .subclassMustImplement)
    }

    open func transition(context: TransitionContext, direction: AnimationDirection) {
        fatalError(because: .subclassMustImplement)
    }
}
