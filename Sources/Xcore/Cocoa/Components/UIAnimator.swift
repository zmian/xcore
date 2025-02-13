//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A wrapper for `UIViewPropertyAnimator` that runs an animation and executes a
/// completion handler when finished.
///
/// This structure creates and starts a `UIViewPropertyAnimator` with a
/// specified duration, animation block, and completion block. It retains a
/// reference to the in-flight animator and provides a method to cancel the
/// animation if needed.
///
/// **Usage**
///
/// ```swift
/// var animator = UIAnimator(duration: 1.0) {
///     // Define your animations here.
/// } completion: {
///     // Perform actions upon completion.
/// }
///
/// // Cancel the animation when necessary.
/// animator.cancel()
/// ```
@MainActor
struct UIAnimator {
    /// The underlying `UIViewPropertyAnimator` used to run the animation.
    private var animator: UIViewPropertyAnimator?

    /// Creates a new UIAnimator that immediately starts the animation.
    ///
    /// - Parameters:
    ///   - duration: The duration of the animation, in seconds.
    ///   - animations: A closure that defines the animations to perform.
    ///   - completion: A closure called when the animation finishes.
    init(
        duration: TimeInterval,
        animations: @escaping () -> Void,
        completion: @escaping () -> Void
    ) {
        let animator = UIViewPropertyAnimator(duration: duration, curve: .easeInOut) {
            animations()
        }

        animator.addCompletion { _ in
            completion()
        }

        animator.startAnimation()

        self.animator = animator
    }

    /// Cancels the in-flight animation.
    mutating func cancel() {
        animator?.stopAnimation(false)
        animator?.finishAnimation(at: .current)
        animator = nil
    }
}
