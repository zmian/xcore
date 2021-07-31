//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

// MARK: - Animate

extension UIView {
    /// Performs a view animation using a timing curve corresponding to the
    /// motion of a physical spring.
    ///
    /// - Parameters:
    ///   - duration: The total duration of the animations, measured in seconds. If
    ///     you specify a negative value or `0`, the changes are made without
    ///     animating them. The default value is `.slow`.
    ///   - delay: The amount of time (measured in seconds) to wait before beginning
    ///     the animations. The default value is `0`.
    ///   - damping: The damping ratio for the spring animation as it approaches its
    ///     quiescent state. The default value is `0.7`.
    ///   - velocity: The initial spring velocity. For smooth start to the
    ///     animation, match this value to the view’s velocity as it was prior to
    ///     attachment. The default value is `0`.
    ///   - options: A mask of options indicating how you want to perform the
    ///     animations. The default value is `.allowUserInteraction`.
    ///   - animations: A closure object containing the changes to commit to the
    ///     views.
    ///   - completion: A closure object to be executed when the animation sequence
    ///     ends.
    @_disfavoredOverload
    public static func animate(
        duration: TimeInterval = .slow,
        delay: TimeInterval = 0,
        damping: CGFloat = 0.7,
        velocity: CGFloat = 0,
        options: AnimationOptions = .allowUserInteraction,
        animations: @escaping (() -> Void),
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: delay,
            usingSpringWithDamping: damping,
            initialSpringVelocity: velocity,
            options: options,
            animations: animations,
            completion: completion
        )
    }

    public static func animateFromCurrentState(
        duration: TimeInterval = .fast,
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        UIView.animate(
            withDuration: duration,
            delay: 0,
            options: .beginFromCurrentState
        ) {
            animations()
        } completion: {
            completion?($0)
        }
    }
}

// MARK: - Transition

@objc
extension UIView {
    /// Creates a transition animation for the receiver.
    public func transition(
        duration: TimeInterval,
        options: UIView.AnimationOptions = [.transitionCrossDissolve],
        animations: @escaping () -> Void,
        completion: ((Bool) -> Void)? = nil
    ) {
        var options = options
        options.insert(.allowAnimatedContent)
        options.insert(.allowUserInteraction)

        UIView.transition(with: self, duration: duration, options: options) {
            animations()
        } completion: {
            completion?($0)
        }
    }
}

extension UIView {
    @objc
    open func setHidden(
        _ hide: Bool,
        animated: Bool,
        duration: TimeInterval = .default,
        _ completion: (() -> Void)? = nil
    ) {
        guard animated else {
            isHidden = hide
            completion?()
            return
        }

        UIView.transition(
            with: self,
            duration: duration,
            options: [.beginFromCurrentState, .transitionCrossDissolve]
        ) {
            self.isHidden = hide
        } completion: { _ in
            completion?()
        }
    }

    @objc
    open func setAlpha(
        _ value: CGFloat,
        animated: Bool = false,
        duration: TimeInterval = .fast,
        options: AnimationOptions = [.curveEaseInOut],
        completion: (() -> Void)? = nil
    ) {
        UIView.animate(duration: animated ? duration : 0, options: options) {
            self.alpha = value
        } completion: { _ in
            completion?()
        }
    }
}

// MARK: - BackgroundColor

extension UIView {
    @objc
    open func animateBackgroundColor(to color: UIColor?, duration: Double = .default) {
        guard let color = color else { return }
        CABasicAnimation(keyPath: "fillColor").apply {
            $0.timingFunction = .easeInEaseOut
            $0.fromValue = backgroundColor?.cgColor
            $0.toValue = color.cgColor
            $0.duration = duration
            layer.add($0, forKey: "fillColor")
        }
        backgroundColor = color
    }
}

// MARK: - Rotating

extension UIView {
    @objc
    open func startRotating(duration: Double = 1, clockwise: Bool = true) {
        let animationKey = "xcore.rotation"

        guard layer.animation(forKey: animationKey) == nil else {
            return
        }

        let animation = CABasicAnimation(keyPath: "transform.rotation").apply {
            $0.duration = duration
            $0.repeatCount = .infinity
            $0.fromValue = 0
            $0.toValue = Float((clockwise ? .pi : -.pi) * 2.0)
            $0.isRemovedOnCompletion = false
        }

        layer.add(animation, forKey: animationKey)
    }

    @objc
    open func stopRotating() {
        let animationKey = "xcore.rotation"

        guard layer.animation(forKey: animationKey) != nil else {
            return
        }

        layer.removeAnimation(forKey: animationKey)
    }
}

// MARK: - Fade

extension NSObjectProtocol where Self: UIView {
    public func withFadeAnimation(_ block: (_ view: Self) -> Void) {
        CATransition.fade.apply {
            layer.add($0, forKey: "fade")
            block(self)
        }
    }
}

extension NSObjectProtocol where Self: UILabel {
    public func fadeText(_ text: String?) {
        withFadeAnimation { $0.text = text }
    }
}

extension NSObjectProtocol where Self: UIButton {
    /// Temporarily set the text.
    ///
    /// - Parameters:
    ///   - temporaryText: The text to set temporarily.
    ///   - interval: The interval after the given temporary text is removed.
    public func setTemporaryText(
        _ temporaryText: String?,
        removeAfter interval: TimeInterval = 1
    ) {
        let originalText = text
        let originalUserInteraction = isUserInteractionEnabled

        text = temporaryText
        isUserInteractionEnabled = false

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.text = originalText
            strongSelf.isUserInteractionEnabled = originalUserInteraction
        }
    }
}
