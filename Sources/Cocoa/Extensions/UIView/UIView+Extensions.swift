//
// UIView+Extensions.swift
//
// Copyright © 2014 Xcore
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

    @IBInspectable open var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable open dynamic var borderColor: UIColor {
        get { return layer.borderColor != nil ? UIColor(cgColor: layer.borderColor!) : .black }
        set { layer.borderColor = newValue.cgColor }
    }

    @IBInspectable open var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    open func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if corners == .none || radius == 0 {
            layer.mask = nil
            return
        }

        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(radius))
        layer.masksToBounds = true
        layer.mask = CAShapeLayer().apply {
            $0.path = path.cgPath
        }
    }

    // MARK: - Fade Content

    @discardableResult
    open func fadeHead(rect: CGRect, startPoint: CGPoint = CGPoint(x: 0.5, y: 0), endPoint: CGPoint = CGPoint(x: 0.5, y: 0.03)) -> CAGradientLayer {
        return CAGradientLayer().apply {
            $0.frame = rect
            $0.colors = [UIColor.clear.cgColor, UIColor.white.cgColor]
            $0.startPoint = startPoint
            $0.endPoint = endPoint
            layer.mask = $0
        }
    }

    @discardableResult
    open func fadeTail(rect: CGRect, startPoint: CGPoint = CGPoint(x: 0.5, y: 0.93), endPoint: CGPoint = CGPoint(x: 0.5, y: 1)) -> CAGradientLayer {
        return CAGradientLayer().apply {
            $0.frame = rect
            $0.colors = [UIColor.white.cgColor, UIColor.clear.cgColor]
            $0.startPoint = startPoint
            $0.endPoint = endPoint
            layer.mask = $0
        }
    }

    @discardableResult
    open func addGradient(_ colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 1), endPoint: CGPoint = CGPoint(x: 1, y: 1), locations: [Int] = [0, 1]) -> CAGradientLayer {
        return CAGradientLayer().apply {
            $0.colors = colors.map { $0.cgColor }
            $0.startPoint = startPoint
            $0.endPoint = endPoint
            $0.locations = locations.map { NSNumber(value: $0) }
            $0.frame.size = frame.size
            $0.cornerRadius = layer.cornerRadius
            layer.insertSublayer($0, at: 0)
        }
    }

    @discardableResult
    open func addOverlay(color: UIColor) -> UIView {
        return UIView().apply {
            $0.backgroundColor = color
            addSubview($0)
            $0.anchor.edges.equalToSuperview()
        }
    }
}

// MARK: - Borders

@objc extension UIView {
    var onePixel: CGFloat {
        let scale = window?.screen.scale ?? UIScreen.main.scale
        return 1 / scale
    }

    // Credit: http://stackoverflow.com/a/23157272
    @discardableResult
    open func addBorder(edges: UIRectEdge, color: UIColor = .white, thickness: CGFloat = 1, inset: UIEdgeInsets = 0) -> [UIView] {
        var borders = [UIView]()
        let allEdges = edges.contains(.all)
        let metrics = [
            "thickness": thickness,
            "insetTop": inset.top,
            "insetLeft": inset.left,
            "insetBottom": inset.bottom,
            "insetRight": inset.right
        ]

        func border(tag: String) -> UIView {
            return UIView().apply {
                $0.tag = "\(tag)BorderView".hashValue
                $0.backgroundColor = color
                $0.translatesAutoresizingMaskIntoConstraints = false
            }
        }

        if edges.contains(.top) || allEdges {
            let top = border(tag: "top")
            addSubview(top)
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-insetTop-[top(==thickness)]",
                options: [],
                metrics: metrics,
                views: ["top": top]
            ).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-insetLeft-[top]-insetRight-|",
                options: [],
                metrics: metrics,
                views: ["top": top]
            ).activate()
            borders.append(top)
        }

        if edges.contains(.left) || allEdges {
            let left = border(tag: "left")
            addSubview(left)
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-insetLeft-[left(==thickness)]",
                options: [],
                metrics: metrics,
                views: ["left": left]
            ).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-insetTop-[left]-insetBottom-|",
                options: [],
                metrics: metrics,
                views: ["left": left]
            ).activate()
            borders.append(left)
        }

        if edges.contains(.right) || allEdges {
            let right = border(tag: "right")
            addSubview(right)
            NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-insetRight-|",
                options: [],
                metrics: metrics,
                views: ["right": right]
            ).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "V:|-insetTop-[right]-insetBottom-|",
                options: [],
                metrics: metrics,
                views: ["right": right]
            ).activate()
            borders.append(right)
        }

        if edges.contains(.bottom) || allEdges {
            let bottom = border(tag: "bottom")
            addSubview(bottom)
            NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-insetBottom-|",
                options: [],
                metrics: metrics,
                views: ["bottom": bottom]
            ).activate()
            NSLayoutConstraint.constraints(withVisualFormat: "H:|-insetLeft-[bottom]-insetRight-|",
                options: [],
                metrics: metrics,
                views: ["bottom": bottom]
            ).activate()
            borders.append(bottom)
        }

        return borders
    }
}

// MARK: - Snapshot

@objc extension UIView {
    /// Takes a snapshot of the complete view hierarchy as visible onscreen.
    ///
    /// - Parameter afterScreenUpdates:
    ///     A boolean value that indicates whether the snapshot should be rendered
    ///     after recent changes have been incorporated. Specify the value false if
    ///     you want to render a snapshot in the view hierarchy’s current state, which
    ///     might not include recent changes. A Boolean value that indicates whether the
    ///     snapshot should be rendered after recent changes have been incorporated.
    ///     Specify the value `false` if you want to render a snapshot in the view hierarchy’s
    ///     current state, which might not include recent changes. The default value is `false`.
    /// - Returns: `UIImage` of the snapshot.
    open func snapshotImage(afterScreenUpdates: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }

    /// Takes a snapshot of the complete view hierarchy as visible onscreen.
    ///
    /// - Parameter afterScreenUpdates:
    ///     A boolean value that indicates whether the snapshot should be rendered
    ///     after recent changes have been incorporated. Specify the value false if
    ///     you want to render a snapshot in the view hierarchy’s current state, which
    ///     might not include recent changes. A Boolean value that indicates whether the
    ///     snapshot should be rendered after recent changes have been incorporated.
    ///     Specify the value `false` if you want to render a snapshot in the view hierarchy’s
    ///     current state, which might not include recent changes. The default value is `false`.
    /// - Returns: `UIImageView` of the snapshot.
    open func snapshotImageView(afterScreenUpdates: Bool = false) -> UIImageView {
        let image = snapshotImage(afterScreenUpdates: afterScreenUpdates)
        return UIImageView(image: image).apply {
            $0.clipsToBounds = true
            $0.borderColor = borderColor
            $0.borderWidth = borderWidth
            $0.cornerRadius = cornerRadius
            $0.contentMode = contentMode
        }
    }
}

// MARK: - Size

@objc extension UIView {
    open var sizeFittingScreenWidth: CGSize {
        return sizeFitting(width: UIScreen.main.bounds.width)
    }

    open func sizeFitting(width: CGFloat) -> CGSize {
        let layoutSize = systemLayoutSizeFitting(
            CGSize(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return CGSize(width: width, height: ceil(layoutSize.height))
    }

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

// MARK: - Resistance And Hugging

extension UIView {
    open func resistsSizeChange() {
        sizeChangeResistance(.required, axis: .vertical)
        sizeChangeResistance(.defaultLow, axis: .horizontal)
    }

    open func resistsSizeChange(axis: NSLayoutConstraint.Axis) {
        sizeChangeResistance(.required, axis: axis)
    }

    open func sizeChangeResistance(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(priority, for: axis)
        setContentCompressionResistancePriority(priority, for: axis)
    }

    open func resistsSizeChange(axis: [NSLayoutConstraint.Axis]) {
        sizeChangeResistance(.required, axis: axis)
    }

    open func sizeChangeResistance(_ priority: UILayoutPriority, axis: [NSLayoutConstraint.Axis]) {
        axis.forEach {
            setContentHuggingPriority(priority, for: $0)
            setContentCompressionResistancePriority(priority, for: $0)
        }
    }
}

extension Array where Element == UIView {
    public func resistsSizeChange() {
        forEach { $0.resistsSizeChange() }
    }

    public func resistsSizeChange(axis: NSLayoutConstraint.Axis) {
        forEach { $0.resistsSizeChange(axis: axis) }
    }

    public func sizeChangeResistance(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) {
        forEach { $0.sizeChangeResistance(priority, axis: axis) }
    }

    public func sizeChangeResistance(_ priority: UILayoutPriority, axis: [NSLayoutConstraint.Axis]) {
        forEach { $0.sizeChangeResistance(priority, axis: axis) }
    }
}

// MARK: - Lookup

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
    /// - Parameter predicate: A closure that takes a subview in `self` as
    ///   its argument and returns a boolean value indicating whether the
    ///   subview is a match.
    /// - Returns: The first subview of the `self` that satisfies `predicate`,
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
    /// - Parameter predicate: A closure that takes a subview in `self` as
    ///   its argument and returns a boolean value indicating whether the
    ///   subview is a match.
    /// - Returns: An array of subviews that satisfies `predicate`,
    ///   or `[]` if there is no subview that satisfies `predicate`.
    open func subviews(where predicate: (UIView) throws -> Bool) rethrows -> [UIView] {
        var result = [UIView]()

        func innerSubview(_ view: UIView, where predicate: (UIView) throws -> Bool) rethrows {
            if try predicate(view) {
                result.append(view)
            }

            for view in view.subviews {
                try innerSubview(view, where: predicate)
            }
        }

        try innerSubview(self, where: predicate)

        return result
    }

    /// Get a child view by class name.
    ///
    /// - Parameters:
    ///   - className: The class name of the child view (e.g., `UIImageView`).
    ///   - comparison: The comparison option to use when looking for the subview. The default value is `.kindOf`.
    /// - Returns: The child view if exists; otherwise `nil`.
    open func subview(withClassName className: String, comparison: LookupComparison = .kindOf) -> UIView? {
        guard let aClass = NSClassFromString(className) else {
            return nil
        }

        return subview { $0.isType(of: aClass, comparison: comparison) }
    }

    /// Get child views by class name.
    ///
    /// - Parameters:
    ///   - className: The class name of the child views (e.g., `UIImageView`).
    ///   - comparison: The comparison option to use when looking for the subview. The default value is `.kindOf`.
    /// - Returns: The child views if exists; otherwise empty array.
    open func subviews(withClassName className: String, comparison: LookupComparison = .kindOf) -> [UIView] {
        guard let aClass = NSClassFromString(className) else {
            return []
        }

        return subviews { $0.isType(of: aClass, comparison: comparison) }
    }

    /// Get a child view by class.
    ///
    /// - Parameters:
    ///   - aClass: The class name of the child view (e.g., `UIImageView`).
    ///   - comparison: The comparison option to use when looking for the subview. The default value is `.kindOf`.
    /// - Returns: The child view if exists; otherwise `nil`.
    open func subview<T: UIView>(withClass aClass: T.Type, comparison: LookupComparison = .kindOf) -> T? {
        return subview { $0.isType(of: aClass, comparison: comparison) } as? T
    }

    /// Get child views by class.
    ///
    /// - Parameters:
    ///   - aClass: The class name of the child view (e.g., `UIImageView`).
    ///   - comparison: The comparison option to use when looking for the subview. The default value is `.kindOf`.
    /// - Returns: The child view if exists; otherwise `nil`.
    open func subviews<T: UIView>(withClass aClass: T.Type, comparison: LookupComparison = .kindOf) -> [T] {
        return subviews { $0.isType(of: aClass, comparison: comparison) } as? [T] ?? []
    }
}

extension UIView {
    /// Temporarily adds a view to the end of the receiver’s list of subviews.
    ///
    /// - Parameters:
    ///   - view: The view to be temporarily added. After being added, this view
    ///           appears on top of any other subviews.
    ///   - interval: The interval after the given `view` is removed.
    ///   - animated: An option to animate the adding and removing of the `view`.
    public func addSubview(_ view: UIView, removeAfter interval: TimeInterval, animated: Bool = true) {
        view.alpha = 0
        addSubview(view)

        let duration = animated ? .normal : 0

        UIView.animate(withDuration: duration) {
            view.alpha = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + interval) { [weak view] in
            UIView.animate(withDuration: duration) {
                view?.alpha = 0
                view?.removeFromSuperview()
            }
        }
    }
}

// MARK: - NSLayoutAttribute

extension UIView {
    /// Returns constraint for the given attribute.
    ///
    /// - Parameters:
    ///   - attribute: The attribute to use to find the constraint.
    ///   - onlyActive: An option to determine if should find only the active constraint. The default value is `true`.
    /// - Returns: A constraint if exists for the specified attribute.
    public func constraint(forAttribute attribute: NSLayoutConstraint.Attribute, onlyActive: Bool = true) -> NSLayoutConstraint? {
        return constraints.first { constraint in
            if onlyActive, !constraint.isActive {
                return false
            }

            if constraint.firstAttribute == attribute, constraint.firstItem == self {
                return true
            }

            if constraint.secondAttribute == attribute, constraint.secondItem == self {
                return true
            }

            return false
        }
    }

    /// Returns constraint for the given identifier.
    ///
    /// - Parameter identifier: The identifier to use to find the constraint.
    /// - Returns: A constraint if exists for the specified identifier.
    public func constraint(identifier: String) -> NSLayoutConstraint? {
        return constraints.first { $0.identifier == identifier }
    }
}

// MARK: - Utilities

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

public func ==(lhs: AnyObject?, rhs: UIView) -> Bool {
    guard let lhs = lhs as? UIView else {
        return false
    }

    return lhs == rhs
}

extension UIView {
    /// A function indicating whether the receiver subviews are an accessibility
    /// elements that an assistive application can access.
    ///
    /// Assistive applications can get information only about objects that are
    /// represented by accessibility elements. Therefore, if you implement a
    /// custom control or view that should be accessible to users with disabilities,
    /// set this property to `true`. The only exception to this practice is a view
    /// that merely serves as a container for other items that should be accessible.
    /// Such a view should implement the `UIAccessibilityContainer` protocol and set
    /// this property to `false`.
    ///
    /// - Parameter value: A Boolean value indicating whether the receiver subviews
    ///                    are an accessibility elements that an assistive
    ///                    application can access.
    public func makeSubviewsAccessible(_ value: Bool) {
        isAccessibilityElement = value

        for view in subviews {
            view.makeSubviewsAccessible(value)
        }
    }
}
