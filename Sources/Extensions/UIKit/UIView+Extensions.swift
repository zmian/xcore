//
// UIView+Extensions.swift
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

@objc extension UIView {
    open var viewController: UIViewController? {
        return responder()
    }

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

    open func setHiddenAnimated(_ hide: Bool, duration: TimeInterval = .normal, _ completion: (() -> Void)? = nil) {
        UIView.transition(
            with: self,
            duration: duration,
            options: .transitionCrossDissolve,
            animations: {
                self.isHidden = hide
            }, completion: { _ in
                completion?()
            }
        )
    }

    @IBInspectable open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable open var borderColor: UIColor {
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : UIColor.black }
        set { layer.borderColor = newValue.cgColor }
    }

    @IBInspectable open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius  = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    open func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path            = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask            = CAShapeLayer()
        mask.path           = path.cgPath
        layer.mask          = mask
        layer.masksToBounds = true
    }

    // MARK: Fade Content

    @discardableResult
    open func fadeHead(rect: CGRect, startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 0.03)) -> CAGradientLayer {
        let gradientLayer        = CAGradientLayer()
        gradientLayer.frame      = rect
        gradientLayer.colors     = [UIColor.clear.cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint   = endPoint
        layer.mask               = gradientLayer
        return gradientLayer
    }

    @discardableResult
    open func fadeTail(rect: CGRect, startPoint: CGPoint = CGPoint(x: 0.5, y: 0.93), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) -> CAGradientLayer {
        let gradientLayer        = CAGradientLayer()
        gradientLayer.frame      = rect
        gradientLayer.colors     = [UIColor.white.cgColor, UIColor.clear.cgColor]
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint   = endPoint
        layer.mask               = gradientLayer
        return gradientLayer
    }

    @discardableResult
    open func addGradient(_ colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 1), endPoint: CGPoint = CGPoint(x: 1, y: 1), locations: [Int] = [0, 1]) -> CAGradientLayer {
        let gradientLayer          = CAGradientLayer()
        gradientLayer.colors       = colors.map { $0.cgColor }
        gradientLayer.startPoint   = startPoint
        gradientLayer.endPoint     = endPoint
        gradientLayer.locations    = locations.map { NSNumber(value: $0) }
        gradientLayer.frame.size   = frame.size
        gradientLayer.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradientLayer, at: 0)
        return gradientLayer
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

// MARK: Snapshot

@objc extension UIView {
    /// Takes a snapshot of the complete view hierarchy as visible onscreen.
    ///
    /// - parameter afterScreenUpdates:
    ///     A boolean value that indicates whether the snapshot should be rendered
    ///     after recent changes have been incorporated. Specify the value false if
    ///     you want to render a snapshot in the view hierarchy’s current state, which
    ///     might not include recent changes. A Boolean value that indicates whether the
    ///     snapshot should be rendered after recent changes have been incorporated.
    ///     Specify the value `false` if you want to render a snapshot in the view hierarchy’s
    ///     current state, which might not include recent changes. The default value is `false`.
    ///
    /// - returns: `UIImage` of the snapshot.
    open func snapshotImage(afterScreenUpdates: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }

    /// Takes a snapshot of the complete view hierarchy as visible onscreen.
    ///
    /// - parameter afterScreenUpdates:
    ///     A boolean value that indicates whether the snapshot should be rendered
    ///     after recent changes have been incorporated. Specify the value false if
    ///     you want to render a snapshot in the view hierarchy’s current state, which
    ///     might not include recent changes. A Boolean value that indicates whether the
    ///     snapshot should be rendered after recent changes have been incorporated.
    ///     Specify the value `false` if you want to render a snapshot in the view hierarchy’s
    ///     current state, which might not include recent changes. The default value is `false`.
    ///
    /// - returns: `UIImageView` of the snapshot.
    open func snapshotImageView(afterScreenUpdates: Bool = false) -> UIImageView {
        let imageView = UIImageView(image: snapshotImage(afterScreenUpdates: afterScreenUpdates))
        imageView.clipsToBounds = true
        imageView.borderColor = borderColor
        imageView.borderWidth = borderWidth
        imageView.cornerRadius = cornerRadius
        imageView.contentMode = contentMode
        return imageView
    }
}

@objc extension UIView {
    open var sizeFittingScreenWidth: CGSize {
        return sizeFitting(width: UIScreen.main.bounds.width)
    }

    open func sizeFitting(width: CGFloat) -> CGSize {
        let layoutSize = systemLayoutSizeFitting(CGSize(width: width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return CGSize(width: width, height: ceil(layoutSize.height))
    }
}

@objc extension UIView {
    open func resizeToFitSubviews() {
        var height: CGFloat = 0

        for subview in subviews {
            height += subview.sizeFitting(width: subview.frame.width).height
        }

        if frame.size.height != height {
            frame.size.height = height
        }
    }
}

// MARK: Resistance And Hugging

extension UIView {
    open func resistsSizeChange() {
        sizeChangeResistance(.required, axis: .vertical)
        sizeChangeResistance(.defaultLow, axis: .horizontal)
    }

    open func resistsSizeChange(axis: UILayoutConstraintAxis) {
        sizeChangeResistance(.required, axis: axis)
    }

    open func sizeChangeResistance(_ priority: UILayoutPriority, axis: UILayoutConstraintAxis...) {
        for element in axis {
            setContentHuggingPriority(priority, for: element)
            setContentCompressionResistancePriority(priority, for: element)
        }
    }
}

extension Array where Element == UIView {
    public func resistsSizeChange() {
        forEach { $0.resistsSizeChange() }
    }

    public func resistsSizeChange(axis: UILayoutConstraintAxis) {
        forEach { $0.resistsSizeChange(axis: axis) }
    }

    public func sizeChangeResistance(_ priority: UILayoutPriority, axis: UILayoutConstraintAxis) {
        forEach { $0.sizeChangeResistance(priority, axis: axis) }
    }
}

// MARK: Lookup

extension UIView {
    /// Returns the first subview of the `self` that satisfies the given
    /// predicate.
    ///
    /// The following example uses the `subview(where:)` method to find the first
    /// subview with tag less than 10:
    ///
    ///     let stackView = UIStackView()
    ///     if let subview = stackView.subview(where: { $0.tag < 10 }) {
    ///         ...
    ///     }
    ///
    /// - parameter predicate: A closure that takes a subview in `self` as
    ///   its argument and returns a boolean value indicating whether the
    ///   subview is a match.
    ///
    /// - returns: The first subview of the `self` that satisfies `predicate`,
    ///   or `nil` if there is no subview that satisfies `predicate`.
    open func subview(where predicate: (UIView) throws -> Bool) rethrows -> UIView? {
        if try predicate(self) {
            return self
        }

        for view in subviews {
            if let subview = try view.subview(where: predicate) {
                return subview
            }
        }

        return nil
    }

    /// Returns the subviews of the `self` that satisfies the given
    /// predicate.
    ///
    /// The following example uses the `subviews(where:)` method to find the
    /// subviews with tag less than 10:
    ///
    ///     let stackView = UIStackView()
    ///     if let subviews = stackView.subview(where: { $0.tag < 10 }) {
    ///         ...
    ///     }
    ///
    /// - parameter predicate: A closure that takes a subview in `self` as
    ///   its argument and returns a boolean value indicating whether the
    ///   subview is a match.
    ///
    /// - returns: An array of subviews that satisfies `predicate`,
    ///   or `[]` if there is no subview that satisfies `predicate`.
    open func subviews(where predicate: (UIView) throws -> Bool) rethrows -> [UIView] {
        var result = [UIView]()

        if try predicate(self) {
            result.append(self)
        }

        for view in subviews {
            if let subview = try view.subview(where: predicate) {
                result.append(subview)
            }
        }

        return result
    }

    /// Get a child view by class name.
    ///
    /// - parameter className: The class name of the child view (e.g., `UIImageView`).
    /// - parameter comparison: The comparison option to use when looking for the subview. The default value is `.kindOf`.
    ///
    /// - returns: The child view if exists; otherwise nil.
    open func subview(withClassName className: String, comparison: LookupComparison = .kindOf) -> UIView? {
        guard let aClass = NSClassFromString(className) else {
            return nil
        }

        return internalSubview(withClass: aClass, comparison: comparison)
    }

    /// Get a child views by class name.
    ///
    /// - parameter className: The class name of the child views (e.g., `UIImageView`).
    /// - parameter comparison: The comparison option to use when looking for the subview. The default value is `.kindOf`.
    ///
    /// - returns: The child views if exists; otherwise empty array.
    open func subviews(withClassName className: String, comparison: LookupComparison = .kindOf) -> [UIView] {
        guard let aClass = NSClassFromString(className) else {
            return []
        }

        var result = [UIView]()

        if isType(of: aClass, comparison: comparison) {
            result.append(self)
        }

        for view in subviews {
            if let subview = view.internalSubview(withClass: aClass, comparison: comparison) {
                result.append(subview)
            }
        }

        return result
    }

    /// Get a child view by class.
    ///
    /// - parameter aClass: The class name of the child view (e.g., `UIImageView`).
    /// - parameter comparison: The comparison option to use when looking for the subview. The default value is `.kindOf`.
    ///
    /// - returns: The child view if exists; otherwise nil.
    open func subview<T: UIView>(withClass aClass: T.Type, comparison: LookupComparison = .kindOf) -> T? {
        return internalSubview(withClass: aClass, comparison: comparison) as? T
    }

    /// Get a child view by class name.
    ///
    /// - parameter aClass: The class name of the child view (e.g., `UIImageView`).
    /// - parameter comparison: The comparison option to use when looking for the subview.
    ///
    /// - returns: The child view if exists; otherwise nil.
    private func internalSubview(withClass aClass: AnyClass, comparison: LookupComparison) -> UIView? {
        if isType(of: aClass, comparison: comparison) {
            return self
        }

        for view in subviews {
            if let subview = view.internalSubview(withClass: aClass, comparison: comparison) {
                return subview
            }
        }

        return nil
    }
}

// MARK: Utilities

extension UIView {
    /// Prints `self` child view hierarchy.
    open func printDebugSubviewsDescription() {
        debugSubviews()
    }

    private func debugSubviews(_ count: Int = 0) {
        if count == 0 {
            print("\n\n\n")
        }

        for _ in 0...count {
            print("--")
        }

        print("\(type(of: self))")

        for view in subviews {
            view.debugSubviews(count + 1)
        }

        if count == 0 {
            print("\n\n\n")
        }
    }
}
