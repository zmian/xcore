//
// CustomViewControllerTransition.swift
//
// Copyright © 2016 Zeeshan Mian
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

public class TransitionContext {
    private let transitionContext: UIViewControllerContextTransitioning
    let sourceViewController: UIViewController
    let destinationViewController: UIViewController
    let containerView: UIView

    init?(transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey),
            destinationViewController  = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey),
            containerView              = transitionContext.containerView()
        else {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled());
            return nil
        }

        self.transitionContext         = transitionContext
        self.sourceViewController      = sourceViewController
        self.destinationViewController = destinationViewController
        self.containerView             = containerView
    }

    func completeTransition() {
        transitionContext.completeTransition(!transitionContext.transitionWasCancelled())
    }
}

public class CustomViewControllerTransition: NSObject, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    // MARK: UIViewControllerTransitioningDelegate

    public func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    public func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }

    // MARK: UIViewControllerAnimatedTransitioning

    public func transitionDuration(transitionContext: UIViewControllerContextTransitioning?) -> NSTimeInterval {
        fatalError("Should be implemented by subclasses")
    }

    public func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        guard let context = TransitionContext(transitionContext: transitionContext) else { return transitionContext.completeTransition(!transitionContext.transitionWasCancelled()) }

        if context.destinationViewController.isBeingPresented() {
            animatePresentation(transitionContext: context)
        } else {
            animateDismissal(transitionContext: context)
        }
    }

    public func animatePresentation(transitionContext ctx: TransitionContext) {
        fatalError("Should be implemented by subclasses")
    }

    public func animateDismissal(transitionContext ctx: TransitionContext) {
        fatalError("Should be implemented by subclasses")
    }
}
