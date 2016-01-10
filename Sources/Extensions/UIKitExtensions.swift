//
// UIKitExtensions.swift
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

public func ControllerFromStoryboard(identifier: String) -> UIViewController {
    return UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(identifier)
}

/// Displays `UIAlertController` with the given `title` and `message`, and an OK button to dismiss it.
public func alert(title: String = "", message: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
    let cancelAction = UIAlertAction(title: "OK", style: .Cancel, handler: nil)
    alertController.addAction(cancelAction)
    alertController.show()
}

// MARK: UIAlertController Extension

public extension UIAlertController {
    public func show(presentingViewController: UIViewController? = nil) {
        guard let presentingViewController = presentingViewController ?? UIApplication.sharedApplication().keyWindow?.rootViewController else { return }
        presentingViewController.presentViewController(self, animated: true, completion: nil)
    }
}

// MARK: UIView Extension

public extension UIView {

    /// Spring animation with completion handler
    public static func animate(duration: NSTimeInterval = 0.6, damping: CGFloat = 0.7, velocity: CGFloat = 0, options: UIViewAnimationOptions = .AllowUserInteraction, animations: (Void -> Void), completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            animations()
        }, completion: completion)
    }

    /// Spring animation
    public static func animate(duration: NSTimeInterval = 0.6, damping: CGFloat = 0.7, velocity: CGFloat = 0, options: UIViewAnimationOptions = .AllowUserInteraction, animations: (Void -> Void)) {
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            animations()
        }, completion: nil)
    }

    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.CGPath
        self.layer.mask = mask
        self.layer.masksToBounds = true
    }

    public var viewController: UIViewController? {
        var responder: UIResponder = self
        while responder.nextResponder() != nil {
            responder = responder.nextResponder()!
            if responder is UIViewController {
                return responder as? UIViewController
            }
        }
        return nil
    }

    // MARK: Fade Content

    public func fadeHead(bounds: CGRect, startPoint: CGPoint = CGPointMake(0.5, 0), endPoint: CGPoint = CGPointMake(0.5, 0.03)) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        layer.mask = gradient
    }

    public func fadeTail(bounds: CGRect, startPoint: CGPoint = CGPointMake(0.5, 0.93), endPoint: CGPoint = CGPointMake(0.5, 1)) {
        let gradient = CAGradientLayer()
        gradient.frame = bounds
        gradient.colors = [UIColor.whiteColor().CGColor, UIColor.clearColor().CGColor]
        gradient.startPoint = startPoint
        gradient.endPoint = endPoint
        layer.mask = gradient
    }

    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }

    @IBInspectable public var borderWidth: CGFloat {
        get { return layer.borderWidth }
        set { layer.borderWidth = newValue }
    }

    @IBInspectable public var borderColor: UIColor {
        get { return layer.borderColor != nil ? UIColor(CGColor: layer.borderColor!) : UIColor.blackColor() }
        set { layer.borderColor = newValue.CGColor }
    }
}

// MARK: UIButton Extension

extension UIButton {
    /// Add spacing between `text` and `image` while preserving the `intrinsicContentSize` and respecting `sizeToFit`
    @IBInspectable public var textImageSpacing: CGFloat {
        get {
            let (left, right) = (imageEdgeInsets.left, imageEdgeInsets.right)

            if left + right == 0 {
                return right * 2
            } else {
                return 0
            }
        }

        set(spacing) {
            let insetAmount   = spacing / 2
            imageEdgeInsets   = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            titleEdgeInsets   = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
            contentEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: insetAmount)
        }
    }
}

// MARK: UIViewController Extension

public extension UIViewController {
    /// Easily add child view controller
    ///
    /// - parameter childController: The view controller to add as a child view controller
    /// - parameter containerView:   A container view where this child view controller will be added. Default is parent view controller's view.
    public func addContainerViewController(childController: UIViewController, containerView: UIView? = nil, enableConstraints: Bool = false, padding: UIEdgeInsets = UIEdgeInsetsZero) {
        guard let containerView = containerView ?? self.view else { return }

        childController.beginAppearanceTransition(true, animated: false)
        childController.willMoveToParentViewController(self)
        self.addChildViewController(childController)
        containerView.addSubview(childController.view)
        childController.view.frame = containerView.bounds
        childController.didMoveToParentViewController(self)
        childController.endAppearanceTransition()

        if enableConstraints {
            containerView.addConstraints(NSLayoutConstraint.constraintsForViewToFillSuperview(childController.view, padding: padding))
        }
    }

    /// Easily remove child view controller
    ///
    /// - parameter childController: The view controller to remove from its parent's children controllers
    public func removeContainerViewController(childController: UIViewController) {
        guard self.childViewControllers.contains(childController) else { return }

        childController.beginAppearanceTransition(false, animated: false)
        childController.willMoveToParentViewController(nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
        childController.didMoveToParentViewController(nil)
        childController.endAppearanceTransition()
    }

    /// Determine whether the view controller is being popped or is showing a subview controller
    public var isBeingPopped: Bool {
        if isMovingFromParentViewController() || isBeingDismissed() {
            return true
        }

        if let viewControllers = self.navigationController?.viewControllers {
            if viewControllers.contains(self) {
                return false
            }
        }

        return false
    }

    public var isModal: Bool {
        if self.presentingViewController != nil {
            return true
        }

        if self.presentingViewController?.presentedViewController == self {
            return true
        }

        if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        }

        if (self.tabBarController?.presentingViewController?.isKindOfClass(UITabBarController)) != nil {
            return true
        }

        return false
    }

    /// True iff `isDeviceLandscape` and `isInterfaceLandscape` both are true; false otherwise
    public var isLandscape: Bool          { return isDeviceLandscape && isInterfaceLandscape }
    public var isInterfaceLandscape: Bool { return UIApplication.sharedApplication().statusBarOrientation.isLandscape }
    public var isDeviceLandscape: Bool    { return UIDevice.currentDevice().orientation.isLandscape }
    public var deviceOrientation: UIDeviceOrientation { return UIDevice.currentDevice().orientation }

    /// Method to display view controller over current view controller as modal
    public func presentViewControllerAsModal(viewControllerToPresent: UIViewController, animated: Bool, completion: (Void -> Void)?) {
        if UIDevice.SystemVersion.iOS7OrLess {
            var root = self
            while root.parentViewController != nil {
                root = root.parentViewController!
            }

            self.presentViewController(viewControllerToPresent, animated: true) {
                viewControllerToPresent.dismissViewControllerAnimated(false) {
                    let orginalStyle = root.modalPresentationStyle
                    if orginalStyle != .CurrentContext {
                        root.modalPresentationStyle = .CurrentContext
                    }
                    self.presentViewController(viewControllerToPresent, animated: false, completion: completion)
                    if orginalStyle != .CurrentContext {
                        root.modalPresentationStyle = orginalStyle
                    }
                }
            }
        } else {
            let orginalStyle = viewControllerToPresent.modalPresentationStyle
            if orginalStyle != .OverCurrentContext {
                viewControllerToPresent.modalPresentationStyle = .OverCurrentContext
            }
            self.presentViewController(viewControllerToPresent, animated: animated, completion: completion)
            if orginalStyle != .OverCurrentContext {
                viewControllerToPresent.modalPresentationStyle = orginalStyle
            }
        }
    }

    /// Presents a view controller modally using a custom transition
    ///
    /// - parameter viewControllerToPresent: The view controller to display over the current view controller's content.
    /// - parameter transitioningDelegate:   The delegate object that provides transition animator and interactive controller objects.
    /// - parameter animated:                Pass `true` to animate the presentation; otherwise, pass `false`.
    /// - parameter completion:              The block to execute after the presentation finishes.
    public func presentViewControllerWithTransition(viewControllerToPresent: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate, animated: Bool, completion: (Void -> Void)?) {
        viewControllerToPresent.transitioningDelegate = transitioningDelegate
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.FullScreen // .Custom prevents per view controller rotation
        self.presentViewController(viewControllerToPresent, animated: animated, completion: completion)
    }
}

// MARK: UINavigationBar Extension

private var navigationBarTransparent = false
public extension UINavigationBar {
    public var isTransparent: Bool {
        get {
            return navigationBarTransparent
        }
        set {
            navigationBarTransparent = newValue
            if newValue {
                self.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
                self.shadowImage = UIImage()
                self.translucent = true
                self.backgroundColor = UIColor.clearColor()
            } else {
                self.setBackgroundImage(nil, forBarMetrics: UIBarMetrics.Default)
            }
        }
    }
}

// MARK: UINavigationController Extension

public extension UINavigationController {
    /// Autorotation Fix. Simply override `supportedInterfaceOrientations`
    /// method in any view controller and it would respect that orientation
    /// setting per view controller
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations() ?? super.supportedInterfaceOrientations()
    }

    /// Setting `preferredStatusBarStyle` works
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        return topViewController
    }

    /// Setting `prefersStatusBarHidden` works
    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        return topViewController
    }

    public override func shouldAutorotate() -> Bool {
        return topViewController?.shouldAutorotate() ?? super.shouldAutorotate()
    }
}

// MARK: UITabBarController Extension

public extension UITabBarController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return self.selectedViewController?.supportedInterfaceOrientations() ?? super.supportedInterfaceOrientations()
    }

    public override func shouldAutorotate() -> Bool {
        return self.selectedViewController?.shouldAutorotate() ?? super.shouldAutorotate()
    }
}

// MARK: UILabel Extension

public extension UILabel {
    public func setText(text: String, animated: Bool) {
        if animated && text != self.text {
            UIView.transitionWithView(self, duration: 0.5, options: [.CurveEaseInOut, .TransitionCrossDissolve], animations: {[weak self] in
                self?.text = text
            }, completion: nil)
        } else {
            self.text = text
        }
    }
}

// MARK: UIColor Extension

public extension UIColor {
    public convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red   = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let green = CGFloat((hex & 0xFF00) >> 8) / 255.0
        let blue  = CGFloat((hex & 0xFF)) / 255.0
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    public var alpha: CGFloat {
        get { return CGColorGetAlpha(self.CGColor) }
        set { self.colorWithAlphaComponent(newValue) }
    }

    public func alpha(value: CGFloat) -> UIColor {
        return self.colorWithAlphaComponent(value)
    }
}

// MARK: UIImageView Extension

public extension UIImageView {
    /// Load the image on the background thread
    public func image(named: String) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            let image = UIImage(named: named)
            dispatch_async(dispatch_get_main_queue()) {
                self.image = image
            }
        }
    }

    /// Create animated images. This does not cache the images in memory. Thus, less memory consumption
    ///
    /// - parameter name:     The name of the pattern (e.g., "AnimationImage.png")
    /// - parameter range:    Images range (e.g., 0..<30 This will create: "AnimationImage0.png"..."AnimationImage29.png")
    /// - parameter duration: The animation duration
    public func createAnimatedImages(name: String, _ range: Range<Int>, _ duration: NSTimeInterval) {
        let prefix = name.stringByDeletingPathExtension
        let ext = name.pathExtension == "" ? "png" : name.pathExtension

        var images: [UIImage] = []
        for i in range {
            images.append(UIImage(fileName: "\(prefix)\(i).\(ext)")!)
        }

        self.animationImages = images
        self.animationDuration = duration
        self.animationRepeatCount = 1
        self.image = images.first
    }

    /// Convenience method to start animation with completion handler
    ///
    /// - parameter endImage:   Image to set when the animation finishes
    /// - parameter completion: The block to execute after the animation finishes
    public func startAnimating(endImage endImage: UIImage? = nil, completion: (Void -> Void)?) {
        if endImage != nil {
            image = endImage
        }
        startAnimating()
        dispatch_after(seconds(animationDuration), dispatch_get_main_queue()) {[weak self] in
            self?.stopAnimating()
            self?.animationImages = nil
            dispatch_after(seconds(0.5), dispatch_get_main_queue()) {
                completion?()
            }
        }
    }
}

// MARK: UIImage Extension

public extension UIImage {
    /// Creates an image from specified color and size
    ///
    /// Default size is `GSizeMake(50, 50)`
    public convenience init(color: UIColor, size: CGSize = CGSizeMake(50, 50)) {
        let rect = CGRect(origin: CGPointZero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }

    /// Identical to UIImage:named but does not cache the images in memory.
    /// Great for image based animations to quickly discard objects after use.
    public convenience init?(fileName: String) {
        let name = fileName.stringByDeletingPathExtension
        let ext  = fileName.pathExtension == "" ? "png" : fileName.pathExtension
        if let path = NSBundle.mainBundle().pathForResource(name, ofType: ext) {
            self.init(contentsOfFile: path)
        } else {
            return nil
        }
    }

    /// Creating arbitrarily-colored icons from a black-with-alpha master image
    public func tintColor(color: UIColor) -> UIImage {
        let image = self
        let rect = CGRectMake(0, 0, image.size.width, image.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let c: CGContextRef = UIGraphicsGetCurrentContext()!
        image.drawInRect(rect)
        CGContextSetFillColorWithColor(c, color.CGColor)
        CGContextSetBlendMode(c, CGBlendMode.SourceAtop)
        CGContextFillRect(c, rect)
        return UIGraphicsGetImageFromCurrentImageContext()
    }

    public func resize(newSize: CGSize, tintColor: UIColor? = nil, completionHandler: (resizedImage: UIImage) -> Void) {
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0);
            self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let tintedImage: UIImage
            if let tintColor = tintColor {
                tintedImage = newImage.tintColor(tintColor)
            } else {
                tintedImage = newImage
            }
            dispatch_async(dispatch_get_main_queue()) {
                completionHandler(resizedImage: tintedImage)
            }
        }
    }
}

// MARK: UIScrollView Extension

public extension UIScrollView {
    public enum ScrollDirection {
        case None, Up, Down, Left, Right, Unknown
    }

    public var scrollDirection: ScrollDirection {
        let translation = panGestureRecognizer.translationInView(superview)

        if translation.y > 0 {
            return .Down
        } else if !(translation.y > 0) {
            return .Up
        }

        if translation.x > 0 {
            return .Right
        } else if !(translation.x > 0) {
            return .Left
        }

        return .Unknown
    }
}

// MARK: UITableView Extension

public extension UITableView {
    /// Adjust target offset so that cells are snapped to top.
    ///
    /// Call this method in scroll view delegate:
    ///
    ///     func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    ///        snapRowsToTop(targetContentOffset, cellHeight: cellHeight, headerHeight: headerHeight)
    ///     }
    public func snapRowsToTop(targetContentOffset: UnsafeMutablePointer<CGPoint>, cellHeight: CGFloat, headerHeight: CGFloat) {
        // Adjust target offset so that cells are snapped to top
        let section = (indexPathsForVisibleRows?.first?.section ?? 0) + 1
        targetContentOffset.memory.y -= (targetContentOffset.memory.y % cellHeight) - (CGFloat(section) * headerHeight)
    }

    // TODO: This can be use to handles a table view with varying row and section heights
    // Still needs testing
    private func snapRowsToTop(targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Find the indexPath where the animation will currently end.
        let indexPath = indexPathForRowAtPoint(targetContentOffset.memory) ?? NSIndexPath(forRow: 0, inSection: 0)

        var offsetY: CGFloat = 0
        for s in 0..<indexPath.section {
            for r in 0..<indexPath.row {
                let indexPath = NSIndexPath(forRow: r, inSection: s)
                var rowHeight = self.delegate?.tableView?(self, heightForRowAtIndexPath: indexPath) ?? 0
                var sectionHeaderHeight = self.delegate?.tableView?(self, heightForHeaderInSection: s) ?? 0
                var sectionFooterHeight = self.delegate?.tableView?(self, heightForFooterInSection: s) ?? 0
                rowHeight           = rowHeight == 0 ? self.rowHeight : rowHeight
                sectionFooterHeight = sectionFooterHeight == 0 ? self.sectionFooterHeight : sectionFooterHeight
                sectionHeaderHeight = sectionHeaderHeight == 0 ? self.sectionHeaderHeight : sectionHeaderHeight
                offsetY += rowHeight + sectionHeaderHeight + sectionFooterHeight
            }
        }

        // Tell the animation to end at the top of that row.
        targetContentOffset.memory.y = offsetY
    }

    /// Compare the top two visible rows to the current content offset
    /// and returns the best index path that is visible on top
    public var visibleTopIndexPath: NSIndexPath? {
        let visibleRows  = indexPathsForVisibleRows ?? []
        let firstPath: NSIndexPath
        let secondPath: NSIndexPath

        if visibleRows.count == 0 {
            return nil
        } else if visibleRows.count == 1 {
            return visibleRows.first
        } else {
            firstPath  = visibleRows[0]
            secondPath = visibleRows[1]
        }

        let firstRowRect = rectForRowAtIndexPath(firstPath)
        return firstRowRect.origin.y > contentOffset.y ? firstPath : secondPath
    }
}

// MARK: UIFont Extension

public extension UIFont {
    public static func printAvailableFontNames() {
        for family in UIFont.familyNames() {
            let count = UIFont.fontNamesForFamilyName(family).count
            print("▿ \(family) (\(count) \(count == 1 ? "font" : "fonts"))")
            for name in UIFont.fontNamesForFamilyName(family) {
                print("  - \(name)")
            }
        }
    }

    public var monospacedDigitFont: UIFont {
        let oldFontDescriptor = fontDescriptor()
        let newFontDescriptor = oldFontDescriptor.monospacedDigitFontDescriptor
        return UIFont(descriptor: newFontDescriptor, size: 0)
    }
}

private extension UIFontDescriptor {
    var monospacedDigitFontDescriptor: UIFontDescriptor {
        let fontDescriptorFeatureSettings = [[UIFontFeatureTypeIdentifierKey: kNumberSpacingType, UIFontFeatureSelectorIdentifierKey: kMonospacedNumbersSelector]]
        let fontDescriptorAttributes = [UIFontDescriptorFeatureSettingsAttribute: fontDescriptorFeatureSettings]
        let fontDescriptor = self.fontDescriptorByAddingAttributes(fontDescriptorAttributes)
        return fontDescriptor
    }

}

// MARK: NSLayoutConstraint Extension

public extension NSLayoutConstraint {

    private static let defaultPriority: Float = 1000

    private enum ConstraintPriority: Float {
        case Low      = 250
        case High     = 750
        case Required = 1000
    }

    // MARK: Convenience Methods

    public convenience init(item view1: AnyObject, attribute attr1: NSLayoutAttribute, relatedBy relation: NSLayoutRelation = .Equal, toItem view2: AnyObject? = nil, attribute attr2: NSLayoutAttribute? = nil, multiplier: CGFloat = 1, constant c: CGFloat = 0, priority: Float = NSLayoutConstraint.defaultPriority) {
        let attribute2 = attr2 != nil ? attr2! : attr1
        self.init(item: view1, attribute: attr1, relatedBy: relation, toItem: view2, attribute: attribute2, multiplier: multiplier, constant: c)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, aspectRatio: CGFloat, priority: Float = NSLayoutConstraint.defaultPriority) {
        self.init(item: view1, attribute: .Width, relatedBy: .Equal, toItem: view1, attribute: .Height, multiplier: aspectRatio)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, width: CGFloat, priority: Float = NSLayoutConstraint.defaultPriority) {
        self.init(item: view1, attribute: .Width, attribute: .NotAnAttribute, constant: width)
        self.priority = priority
    }

    public convenience init(item view1: AnyObject, height: CGFloat, priority: Float = NSLayoutConstraint.defaultPriority) {
        self.init(item: view1, attribute: .Height, attribute: .NotAnAttribute, constant: height)
        self.priority = priority
    }

    // MARK: Static Methods

    public static func size(viewToSize: UIView, size: CGSize, priority: Float = NSLayoutConstraint.defaultPriority) -> [NSLayoutConstraint] {
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return [
            NSLayoutConstraint(item: viewToSize, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.width, priority: priority),
            NSLayoutConstraint(item: viewToSize, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: size.height, priority: priority)
        ]
    }

    public static func centerX(viewToCenter: UIView, superview: UIView? = nil, offset: CGFloat = 0) -> NSLayoutConstraint {
        let superview = superview ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: viewToCenter, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: offset)
    }

    public static func centerY(viewToCenter: UIView, superview: UIView? = nil, offset: CGFloat = 0) -> NSLayoutConstraint {
        let superview = superview ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint(item: viewToCenter, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1, constant: offset)
    }

    public static func centerXY(viewToCenter: UIView, superview: UIView? = nil, offset: CGPoint = CGPointZero) -> [NSLayoutConstraint] {
        let superview = superview ?? viewToCenter.superview
        viewToCenter.translatesAutoresizingMaskIntoConstraints = false

        return [
            NSLayoutConstraint(item: viewToCenter, attribute: .CenterX, relatedBy: .Equal, toItem: superview, attribute: .CenterX, multiplier: 1, constant: offset.x),
            NSLayoutConstraint(item: viewToCenter, attribute: .CenterY, relatedBy: .Equal, toItem: superview, attribute: .CenterY, multiplier: 1, constant: offset.y)
        ]
    }

    public static func constraintsForViewToFillSuperviewHorizontal(viewToSize: UIView, paddingLeft: CGFloat = 0, paddingRight: CGFloat = 0, priority: Float = NSLayoutConstraint.defaultPriority) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority), "paddingLeft": paddingLeft, "paddingRight": paddingRight]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint.constraintsWithVisualFormat("H:|-paddingLeft@priority-[view]-paddingRight@priority-|", options: [], metrics: metrics, views: views)
    }

    public static func constraintsForViewToFillSuperviewVertical(viewToSize: UIView, paddingTop: CGFloat = 0, paddingBottom: CGFloat = 0, priority: Float = NSLayoutConstraint.defaultPriority) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
        let metrics = ["priority": CGFloat(priority), "paddingTop": paddingTop, "paddingBottom": paddingBottom]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false
        return NSLayoutConstraint.constraintsWithVisualFormat("V:|-paddingTop@priority-[view]-paddingBottom@priority-|", options: [], metrics: metrics, views: views)
    }

    public static func constraintsForViewToFillSuperview(viewToSize: UIView, padding: UIEdgeInsets = UIEdgeInsetsZero) -> [NSLayoutConstraint] {
        let views = ["view": viewToSize]
        let metrics = ["paddingTop": padding.top, "paddingLeft": padding.left, "paddingBottom": padding.bottom, "paddingRight": padding.right]
        viewToSize.translatesAutoresizingMaskIntoConstraints = false

        var constraints: [NSLayoutConstraint] = []
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("H:|-paddingLeft-[view]-paddingRight-|", options: [], metrics: metrics, views: views)
        constraints += NSLayoutConstraint.constraintsWithVisualFormat("V:|-paddingTop-[view]-paddingBottom-|", options: [], metrics: metrics, views: views)
        return constraints
    }
}

public extension UIDevice {
    public struct ScreenSize {
        public static var width: CGFloat     { return UIScreen.mainScreen().bounds.size.width }
        public static var height: CGFloat    { return UIScreen.mainScreen().bounds.size.height }
        public static var maxLength: CGFloat { return max(ScreenSize.width, ScreenSize.height) }
        public static var minLength: CGFloat { return min(ScreenSize.width, ScreenSize.height) }
    }

    public struct DeviceType {
        public static var iPhone4OrLess: Bool { return UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength < 568.0 }
        public static var iPhone5: Bool       { return UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 568.0 }
        public static var iPhone6: Bool       { return UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 667.0 }
        public static var iPhone6Plus: Bool   { return UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 736.0 }
        public static var Simulator: Bool     { return TARGET_IPHONE_SIMULATOR == 1 }
    }

    public struct SystemVersion {
        public static let iOS8OrGreater = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_0)
        public static let iOS7OrLess    = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_0)

        public static func lessThanOrEqual(string: String) -> Bool {
            return  UIDevice.currentDevice().systemVersion.compare(string, options: .NumericSearch, range: nil, locale: nil) == .OrderedAscending
        }

        public static func greaterThanOrEqual(string: String) -> Bool {
            return !lessThanOrEqual(string)
        }

        public static func equal(string: String) -> Bool {
            return  UIDevice.currentDevice().systemVersion.compare(string, options: .NumericSearch, range: nil, locale: nil) == .OrderedSame
        }
    }
}

public extension NSBundle {
    public static var appVersionNumber: String {
        return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    public static var appBuildNumber: String {
        return NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}

// MARK: Private Helpers

private func seconds(interval: NSTimeInterval) -> dispatch_time_t {
    return dispatch_time(DISPATCH_TIME_NOW, Int64(interval * Double(NSEC_PER_SEC)))
}
