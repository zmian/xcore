//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

@objc
extension UIView {
    open var viewController: UIViewController? {
        responder()
    }
}

// MARK: - Snapshot

@objc
extension UIView {
    /// Takes a snapshot of the complete view hierarchy as visible onscreen.
    ///
    /// - Parameter afterScreenUpdates: A Boolean value indicating whether the
    ///   snapshot should be rendered after recent changes have been incorporated.
    ///   Specify the value false if you want to render a snapshot in the view
    ///   hierarchy’s current state, which might not include recent changes. A
    ///   Boolean value indicating whether the snapshot should be rendered after
    ///   recent changes have been incorporated. Specify the value `false` if you
    ///   want to render a snapshot in the view hierarchy’s current state, which
    ///   might not include recent changes. The default value is `false`.
    /// - Returns: `UIImage` of the snapshot.
    open func snapshotImage(afterScreenUpdates: Bool = false) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: afterScreenUpdates)
        let snapshot = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return snapshot
    }
}

// MARK: - Size

@objc
extension UIView {
    open var sizeFittingScreenWidth: CGSize {
        sizeFitting(width: Screen.main.bounds.width)
    }

    open func sizeFitting(width: CGFloat) -> CGSize {
        let layoutSize = systemLayoutSizeFitting(
            CGSize(width: width, height: 0),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )

        return CGSize(width: width, height: ceil(layoutSize.height))
    }
}

// MARK: - Resistance And Hugging

extension UIView {
    public func resistsSizeChange() {
        sizeChangeResistance(.required, axis: .vertical)
        sizeChangeResistance(.defaultLow, axis: .horizontal)
    }

    public func resistsSizeChange(axis: NSLayoutConstraint.Axis) {
        sizeChangeResistance(.required, axis: axis)
    }

    public func sizeChangeResistance(_ priority: UILayoutPriority, axis: NSLayoutConstraint.Axis) {
        setContentHuggingPriority(priority, for: axis)
        setContentCompressionResistancePriority(priority, for: axis)
    }

    public func resistsSizeChange(axis: [NSLayoutConstraint.Axis]) {
        sizeChangeResistance(.required, axis: axis)
    }

    public func sizeChangeResistance(_ priority: UILayoutPriority, axis: [NSLayoutConstraint.Axis]) {
        axis.forEach {
            setContentHuggingPriority(priority, for: $0)
            setContentCompressionResistancePriority(priority, for: $0)
        }
    }
}

@MainActor
extension Array<UIView> {
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
    /// - Parameter predicate: A closure that takes a subview in `self` as its
    ///   argument and returns a Boolean value indicating whether the subview is a
    ///   match.
    /// - Returns: The first subview of the `self` that satisfies `predicate`,
    ///   or `nil` if there is no subview that satisfies `predicate`.
    public func firstSubview(where predicate: (UIView) throws -> Bool) rethrows -> UIView? {
        if try predicate(self) {
            return self
        }

        for view in subviews {
            if let subview = try view.firstSubview(where: predicate) {
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
    /// - Parameter predicate: A closure that takes a subview in `self` as its
    ///   argument and returns a Boolean value indicating whether the subview is a
    ///   match.
    /// - Returns: An array of subviews that satisfies `predicate`, or `[]` if there
    ///   is no subview that satisfies `predicate`.
    public func subviews(where predicate: (UIView) throws -> Bool) rethrows -> [UIView] {
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

    /// Get the first child view by class name.
    ///
    /// - Parameters:
    ///   - className: The class name of the child view (e.g., `UIImageView`).
    ///   - comparison: The comparison option to use when looking for the subview.
    /// - Returns: The child view if exists; otherwise, `nil`.
    public func firstSubview(
        withClassName className: String,
        comparison: LookupComparison = .kindOf
    ) -> UIView? {
        guard let aClass = NSClassFromString(className) else {
            return nil
        }

        return firstSubview { $0.isType(of: aClass, comparison: comparison) }
    }

    /// Get child views by class name.
    ///
    /// - Parameters:
    ///   - className: The class name of the child views (e.g., `UIImageView`).
    ///   - comparison: The comparison option to use when looking for the subview.
    /// - Returns: The child views if exists; otherwise, empty array.
    public func subviews(
        withClassName className: String,
        comparison: LookupComparison = .kindOf
    ) -> [UIView] {
        guard let aClass = NSClassFromString(className) else {
            return []
        }

        return subviews { $0.isType(of: aClass, comparison: comparison) }
    }

    /// Get the first child view by class.
    ///
    /// - Parameters:
    ///   - aClass: The class name of the child view (e.g., `UIImageView`).
    ///   - comparison: The comparison option to use when looking for the subview.
    /// - Returns: The child view if exists; otherwise, `nil`.
    public func firstSubview<T: UIView>(
        withClass aClass: T.Type,
        comparison: LookupComparison = .kindOf
    ) -> T? {
        firstSubview { $0.isType(of: aClass, comparison: comparison) } as? T
    }

    /// Get child views by class.
    ///
    /// - Parameters:
    ///   - aClass: The class name of the child view (e.g., `UIImageView`).
    ///   - comparison: The comparison option to use when looking for the subview.
    /// - Returns: The child view if exists; otherwise, `nil`.
    public func subviews<T: UIView>(
        withClass aClass: T.Type,
        comparison: LookupComparison = .kindOf
    ) -> [T] {
        subviews { $0.isType(of: aClass, comparison: comparison) } as? [T] ?? []
    }
}

// MARK: - Internal

extension UIView {
    func pinEdgesToSuperview(inset: UIEdgeInsets = .zero) {
        pinEdges(to: superview!, inset: inset)
    }

    private func pinEdges(to other: UIView, inset: UIEdgeInsets = .zero) {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: other.topAnchor, constant: inset.top),
            bottomAnchor.constraint(equalTo: other.bottomAnchor, constant: inset.bottom),
            leadingAnchor.constraint(equalTo: other.leadingAnchor, constant: inset.left),
            trailingAnchor.constraint(equalTo: other.trailingAnchor, constant: inset.right)
        ])
    }
}
#endif
