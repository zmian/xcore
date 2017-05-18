//
// UIViewExtensions.swift
//
// Copyright © 2014 Zeeshan Mian
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

extension UIView {
    /// Performs a view animation using a timing curve corresponding to the motion of a physical spring.
    ///
    /// - parameter duration:   The total duration of the animations, measured in seconds. If you specify a negative value or `0`, the changes are made without animating them. The default value is `0.6`.
    /// - parameter delay:      The amount of time (measured in seconds) to wait before beginning the animations. The default value is `0`.
    /// - parameter damping:    The damping ratio for the spring animation as it approaches its quiescent state. The default value is `0.7`.
    /// - parameter velocity:   The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment. The default value is `0`.
    /// - parameter options:    A mask of options indicating how you want to perform the animations. The default value is `UIViewAnimationOptions.AllowUserInteraction`.
    /// - parameter animations: A block object containing the changes to commit to the views.
    /// - parameter completion: A block object to be executed when the animation sequence ends.
    public static func animate(_ duration: TimeInterval = 0.6, delay: TimeInterval = 0, damping: CGFloat = 0.7, velocity: CGFloat = 0, options: UIViewAnimationOptions = .allowUserInteraction, animations: @escaping (() -> Void), completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: animations, completion: completion)
    }

    /// Performs a view animation using a timing curve corresponding to the motion of a physical spring.
    ///
    /// - parameter duration:   The total duration of the animations, measured in seconds. If you specify a negative value or `0`, the changes are made without animating them. The default value is `0.6`.
    /// - parameter delay:      The amount of time (measured in seconds) to wait before beginning the animations. The default value is `0`.
    /// - parameter damping:    The damping ratio for the spring animation as it approaches its quiescent state. The default value is `0.7`.
    /// - parameter velocity:   The initial spring velocity. For smooth start to the animation, match this value to the view’s velocity as it was prior to attachment. The default value is `0`.
    /// - parameter options:    A mask of options indicating how you want to perform the animations. The default value is `UIViewAnimationOptions.AllowUserInteraction`.
    /// - parameter animations: A block object containing the changes to commit to the views.
    public static func animate(_ duration: TimeInterval = 0.6, delay: TimeInterval = 0, damping: CGFloat = 0.7, velocity: CGFloat = 0, options: UIViewAnimationOptions = .allowUserInteraction, animations: @escaping (() -> Void)) {
        UIView.animate(withDuration: duration, delay: delay, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: animations, completion: nil)
    }

    open func setHiddenAnimated(_ hidden: Bool, duration: TimeInterval = 0.35, _ completion: (() -> Void)? = nil) {
        guard isHidden != hidden else { return }
        alpha  = hidden ? 1 : 0
        isHidden = false

        UIView.animate(withDuration: duration, animations: {
            self.alpha = hidden ? 0 : 1
        }, completion: { _ in
            self.isHidden = hidden
            completion?()
        })
    }

    open func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path            = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask            = CAShapeLayer()
        mask.path           = path.cgPath
        layer.mask          = mask
        layer.masksToBounds = true
    }

    open var viewController: UIViewController? {
        var responder: UIResponder = self
        while let nextResponder = responder.next {
            responder = nextResponder
            if responder is UIViewController {
                return responder as? UIViewController
            }
        }
        return nil
    }

    // MARK: Fade Content

    open func fadeHead(rect: CGRect, startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 0.03)) {
        let gradient        = CAGradientLayer()
        gradient.frame      = rect
        gradient.colors     = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint   = endPoint
        layer.mask          = gradient
    }

    open func fadeTail(rect: CGRect, startPoint: CGPoint = CGPoint(x: 0.5, y: 0.93), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) {
        let gradient        = CAGradientLayer()
        gradient.frame      = rect
        gradient.colors     = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradient.startPoint = startPoint
        gradient.endPoint   = endPoint
        layer.mask          = gradient
    }

    @IBInspectable open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius  = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable open var borderColor: UIColor {
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : UIColor.black }
        set { layer.borderColor = newValue.cgColor }
    }

    @discardableResult
    open func addGradient(_ colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 1), endPoint: CGPoint = CGPoint(x: 1, y: 1), locations: [Int] = [0, 1]) -> CAGradientLayer {
        let gradient          = CAGradientLayer()
        gradient.colors       = colors.map { $0.cgColor }
        gradient.startPoint   = startPoint
        gradient.endPoint     = endPoint
        gradient.locations    = locations.map { NSNumber(value: $0) }
        gradient.frame.size   = frame.size
        gradient.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradient, at: 0)
        return gradient
    }

    @discardableResult
    open func addOverlay(color: UIColor) -> UIView {
        let overlay = UIView()
        overlay.backgroundColor = color
        addSubview(overlay)
        NSLayoutConstraint.constraintsForViewToFillSuperview(overlay).activate()
        return overlay
    }

    // Credit: http://stackoverflow.com/a/23157272
    @discardableResult
    open func addBorder(edges: UIRectEdge, color: UIColor = .white, thickness: CGFloat = 1, padding: UIEdgeInsets = .zero) -> [UIView] {
        var borders = [UIView]()
        let metrics = ["thickness": thickness, "paddingTop": padding.top, "paddingLeft": padding.left, "paddingBottom": padding.bottom, "paddingRight": padding.right]

        func border() -> UIView {
            let border = UIView(frame: .zero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }

        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-paddingTop-[top(==thickness)]",
                options: [],
                metrics: metrics,
                views: ["top": top]).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-paddingLeft-[top]-paddingRight-|",
                options: [],
                metrics: metrics,
                views: ["top": top]).activate()
            borders.append(top)
        }

        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-paddingLeft-[left(==thickness)]",
                options: [],
                metrics: metrics,
                views: ["left": left]).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-paddingTop-[left]-paddingBottom-|",
                options: [],
                metrics: metrics,
                views: ["left": left]).activate()
            borders.append(left)
        }

        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-paddingRight-|",
                options: [],
                metrics: metrics,
                views: ["right": right]).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-paddingTop-[right]-paddingBottom-|",
                options: [],
                metrics: metrics,
                views: ["right": right]).activate()
            borders.append(right)
        }

        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-paddingBottom-|",
                options: [],
                metrics: metrics,
                views: ["bottom": bottom]).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-paddingLeft-[bottom]-paddingRight-|",
                options: [],
                metrics: metrics,
                views: ["bottom": bottom]).activate()
            borders.append(bottom)
        }

        return borders
    }
}
