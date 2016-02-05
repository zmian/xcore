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
import SafariServices
import ObjectiveC

/// Instantiates and returns the view controller with the specified identifier
/// for the specified storyboard resource file.
///
/// - parameter identifier:     An identifier string that uniquely identifies the view controller in the storyboard file.
/// - parameter storyboardName: The name of the storyboard resource file without the filename extension. Default is `Main`
/// - parameter bundle:         The bundle containing the storyboard file and its related resources. If you specify nil,
///   this method looks in the main bundle of the current application. The default value is `nil`.
///
/// - returns: The view controller corresponding to the specified identifier string.
public func ControllerFromStoryboard(identifier: String, storyboardName: String = "Main", bundle: NSBundle? = nil) -> UIViewController {
    return UIStoryboard(name: storyboardName, bundle: bundle).instantiateViewControllerWithIdentifier(identifier)
}

/// Attempts to open the resource at the specified URL.
///
/// Requests are made using `SafariViewController` if available;
/// otherwise it uses `UIApplication:openURL`.
///
/// - parameter presentingViewController: A view controller that wants to open the url.
/// - parameter url:                      The url to open.
public func openURL(presentingViewController: UIViewController, url: NSURL) {
    if #available(iOS 9.0, *) {
        let svc = SFSafariViewController(URL: url)
        presentingViewController.presentViewController(svc, animated: true, completion: nil)
    } else {
        UIApplication.sharedApplication().openURL(url)
    }
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

    /// Spring animation with completion handler.
    public static func animate(duration: NSTimeInterval = 0.6, damping: CGFloat = 0.7, velocity: CGFloat = 0, options: UIViewAnimationOptions = .AllowUserInteraction, animations: (() -> Void), completion: ((Bool) -> Void)?) {
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            animations()
        }, completion: completion)
    }

    /// Spring animation
    public static func animate(duration: NSTimeInterval = 0.6, damping: CGFloat = 0.7, velocity: CGFloat = 0, options: UIViewAnimationOptions = .AllowUserInteraction, animations: (() -> Void)) {
        UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: options, animations: {
            animations()
        }, completion: nil)
    }

    public func setHiddenAnimated(hide: Bool, duration: NSTimeInterval) {
        guard hidden != hide else { return }
        alpha  = hide ? 1 : 0
        hidden = false

        UIView.animateWithDuration(duration, animations: {
            self.alpha = hide ? 0 : 1
        }, completion: { _ in
            self.hidden = hide
        })
    }

    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path            = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask            = CAShapeLayer()
        mask.path           = path.CGPath
        layer.mask          = mask
        layer.masksToBounds = true
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
        let gradient        = CAGradientLayer()
        gradient.frame      = bounds
        gradient.colors     = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
        gradient.startPoint = startPoint
        gradient.endPoint   = endPoint
        layer.mask          = gradient
    }

    public func fadeTail(bounds: CGRect, startPoint: CGPoint = CGPointMake(0.5, 0.93), endPoint: CGPoint = CGPointMake(0.5, 1)) {
        let gradient        = CAGradientLayer()
        gradient.frame      = bounds
        gradient.colors     = [UIColor.whiteColor().CGColor, UIColor.clearColor().CGColor]
        gradient.startPoint = startPoint
        gradient.endPoint   = endPoint
        layer.mask          = gradient
    }

    @IBInspectable public var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.cornerRadius  = newValue
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

    public func addGradient(colors: [UIColor], startPoint: CGPoint = CGPoint(x: 0, y: 1), endPoint: CGPoint = CGPoint(x: 1, y: 1), locations: [Int] = [0, 1]) -> CAGradientLayer {
        let gradient          = CAGradientLayer()
        gradient.colors       = colors.map { $0.CGColor }
        gradient.startPoint   = startPoint
        gradient.endPoint     = endPoint
        gradient.locations    = locations
        gradient.frame.size   = frame.size
        gradient.cornerRadius = layer.cornerRadius
        layer.insertSublayer(gradient, atIndex: 0)
        return gradient
    }

    public func addOverlay(color: UIColor) -> UIView {
        let overlay = UIView()
        overlay.backgroundColor = color
        addSubview(overlay)
        NSLayoutConstraint.constraintsForViewToFillSuperview(overlay).activate()
        return overlay
    }

    // Credit: http://stackoverflow.com/a/23157272

    public func addBorder(edges edges: UIRectEdge, color: UIColor = UIColor.whiteColor(), thickness: CGFloat = 1) -> [UIView] {
        var borders = [UIView]()

        func border() -> UIView {
            let border = UIView(frame: CGRectZero)
            border.backgroundColor = color
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }

        if edges.contains(.Top) || edges.contains(.All) {
            let top = border()
            addSubview(top)
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[top(==thickness)]",
                options: [],
                metrics: ["thickness": thickness],
                views: ["top": top]).activate()
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[top]-(0)-|",
                options: [],
                metrics: nil,
                views: ["top": top]).activate()
            borders.append(top)
        }

        if edges.contains(.Left) || edges.contains(.All) {
            let left = border()
            addSubview(left)
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[left(==thickness)]",
                options: [],
                metrics: ["thickness": thickness],
                views: ["left": left]).activate()
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[left]-(0)-|",
                options: [],
                metrics: nil,
                views: ["left": left]).activate()
            borders.append(left)
        }

        if edges.contains(.Right) || edges.contains(.All) {
            let right = border()
            addSubview(right)
            NSLayoutConstraint.constraintsWithVisualFormat("H:[right(==thickness)]-(0)-|",
                options: [],
                metrics: ["thickness": thickness],
                views: ["right": right]).activate()
            NSLayoutConstraint.constraintsWithVisualFormat("V:|-(0)-[right]-(0)-|",
                options: [],
                metrics: nil,
                views: ["right": right]).activate()
            borders.append(right)
        }

        if edges.contains(.Bottom) || edges.contains(.All) {
            let bottom = border()
            addSubview(bottom)
            NSLayoutConstraint.constraintsWithVisualFormat("V:[bottom(==thickness)]-(0)-|",
                options: [],
                metrics: ["thickness": thickness],
                views: ["bottom": bottom]).activate()
            NSLayoutConstraint.constraintsWithVisualFormat("H:|-(0)-[bottom]-(0)-|",
                options: [],
                metrics: nil,
                views: ["bottom": bottom]).activate()
            borders.append(bottom)
        }

        return borders
    }
}

// MARK: UIViewController Extension

public extension UIViewController {
    /// A convenience method to easily add child view controller.
    ///
    /// - parameter childController: The view controller to add as a child view controller.
    /// - parameter containerView:   A container view where this child view controller will be added. The default value is view controller's view.
    public func addContainerViewController(childController: UIViewController, containerView: UIView? = nil, enableConstraints: Bool = false, padding: UIEdgeInsets = UIEdgeInsetsZero) {
        guard let containerView = containerView ?? view else { return }

        childController.beginAppearanceTransition(true, animated: false)
        childController.willMoveToParentViewController(self)
        addChildViewController(childController)
        containerView.addSubview(childController.view)
        childController.view.frame = containerView.bounds
        childController.didMoveToParentViewController(self)
        childController.endAppearanceTransition()

        if enableConstraints {
            NSLayoutConstraint.constraintsForViewToFillSuperview(childController.view, padding: padding).activate()
        }
    }

    /// A convenience method to easily remove child view controller.
    ///
    /// - parameter childController: The view controller to remove from its parent's children controllers.
    public func removeContainerViewController(childController: UIViewController) {
        guard childViewControllers.contains(childController) else { return }

        childController.beginAppearanceTransition(false, animated: false)
        childController.willMoveToParentViewController(nil)
        childController.view.removeFromSuperview()
        childController.removeFromParentViewController()
        childController.didMoveToParentViewController(nil)
        childController.endAppearanceTransition()
    }

    /// A boolean value to determine whether the view controller is being popped or is showing a subview controller.
    public var isBeingPopped: Bool {
        if isMovingFromParentViewController() || isBeingDismissed() {
            return true
        }

        if let viewControllers = navigationController?.viewControllers where viewControllers.contains(self) {
            return false
        }

        return false
    }

    public var isModal: Bool {
        if presentingViewController != nil {
            return true
        }

        if presentingViewController?.presentedViewController == self {
            return true
        }

        if navigationController?.presentingViewController?.presentedViewController == navigationController {
            return true
        }

        if (tabBarController?.presentingViewController?.isKindOfClass(UITabBarController)) != nil {
            return true
        }

        return false
    }

    /// True iff `isDeviceLandscape` and `isInterfaceLandscape` both are true; false otherwise.
    public var isLandscape: Bool          { return isDeviceLandscape && isInterfaceLandscape }
    public var isInterfaceLandscape: Bool { return UIApplication.sharedApplication().statusBarOrientation.isLandscape }
    /// Returns the physical orientation of the device.
    public var isDeviceLandscape: Bool    { return UIDevice.currentDevice().orientation.isLandscape }
    /// This value represents the physical orientation of the device and may be different from the current orientation
    /// of your application’s user interface. See `UIDeviceOrientation` for descriptions of the possible values.
    public var deviceOrientation: UIDeviceOrientation { return UIDevice.currentDevice().orientation }

    /// Method to display view controller over current view controller as modal.
    public func presentViewControllerAsModal(viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)? = nil) {
        let orginalStyle = viewControllerToPresent.modalPresentationStyle
        if orginalStyle != .OverCurrentContext {
            viewControllerToPresent.modalPresentationStyle = .OverCurrentContext
        }

        presentViewController(viewControllerToPresent, animated: animated, completion: completion)

        if orginalStyle != .OverCurrentContext {
            viewControllerToPresent.modalPresentationStyle = orginalStyle
        }
    }

    /// Presents a view controller modally using a custom transition.
    ///
    /// - parameter viewControllerToPresent: The view controller to display over the current view controller's content.
    /// - parameter transitioningDelegate:   The delegate object that provides transition animator and interactive controller objects.
    /// - parameter animated:                Pass `true` to animate the presentation; otherwise, pass `false`.
    /// - parameter completion:              The block to execute after the presentation finishes.
    public func presentViewControllerWithTransition(viewControllerToPresent: UIViewController, transitioningDelegate: UIViewControllerTransitioningDelegate, animated: Bool, completion: (() -> Void)? = nil) {
        viewControllerToPresent.transitioningDelegate = transitioningDelegate
        viewControllerToPresent.modalPresentationStyle = UIModalPresentationStyle.FullScreen // .Custom prevents per view controller rotation
        presentViewController(viewControllerToPresent, animated: animated, completion: completion)
    }
}

public extension UIViewController {
    private struct AssociatedKey {
        static var SupportedInterfaceOrientations = "Xcore_SupportedInterfaceOrientations"
        static var PreferredStatusBarStyle        = "Xcore_preferredStatusBarStyle"
        static var PrefersStatusBarHidden         = "Xcore_PrefersStatusBarHidden"
        static var ShouldAutorotate               = "Xcore_ShouldAutorotate"
    }

    /// A convenience property to set `supportedInterfaceOrientations()` without subclassing.
    /// This is useful when you don't have access to the actual class and need
    /// to set supported interface orientation.
    ///
    /// The default value is `nil` which means use the `supportedInterfaceOrientations() value`.
    /// ```
    /// let vc = UIImagePickerController()
    /// vc.preferredInterfaceOrientations = .AllButUpsideDown
    /// ```
    public var preferredInterfaceOrientations: UIInterfaceOrientationMask? {
        get {
            if let intValue = objc_getAssociatedObject(self, &AssociatedKey.SupportedInterfaceOrientations) as? UInt {
                return UIInterfaceOrientationMask(rawValue: intValue)
            } else {
                return nil
            }
        }
        set { objc_setAssociatedObject(self, &AssociatedKey.SupportedInterfaceOrientations, newValue?.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// A convenience property to set status bar style without subclassing.
    /// This is useful when you don't have access to the actual class and need
    /// to update the status bar style to match with app look and feel.
    ///
    /// The default value is `nil` which means use the `preferredStatusBarStyle() value`.
    /// ```
    /// let vc = UIImagePickerController()
    /// vc.statusBarStyle = .LightContent
    /// ```
    public var statusBarStyle: UIStatusBarStyle? {
        get {
            if let intValue = objc_getAssociatedObject(self, &AssociatedKey.PreferredStatusBarStyle) as? Int {
                return UIStatusBarStyle(rawValue: intValue)
            } else {
                return nil
            }
        }
        set { objc_setAssociatedObject(self, &AssociatedKey.PreferredStatusBarStyle, newValue?.rawValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// A convenience property to set `prefersStatusBarHidden()` without subclassing.
    /// This is useful when you don't have access to the actual class and need
    /// to show/hide status bar.
    ///
    /// The default value is `nil` which means use the `prefersStatusBarHidden() value`.
    /// ```
    /// let vc = UIImagePickerController()
    /// vc.isStatusBarHidden = false
    /// ```
    public var isStatusBarHidden: Bool? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.PrefersStatusBarHidden) as? Bool }
        set { objc_setAssociatedObject(self, &AssociatedKey.PrefersStatusBarHidden, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    /// A convenience property to set `shouldAutorotate()` without subclassing.
    /// This is useful when you don't have access to the actual class and need
    /// to enable/disable rotation.
    ///
    /// The default value is `nil` which means use the `shouldAutorotate()` value.
    /// ```
    /// let vc = UIImagePickerController()
    /// vc.enableAutorotate = false
    /// ```
    public var enableAutorotate: Bool? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.ShouldAutorotate) as? Bool }
        set { objc_setAssociatedObject(self, &AssociatedKey.ShouldAutorotate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

// MARK: UINavigationController Extension

public extension UINavigationController {
    // Autorotation Fix. Simply override `supportedInterfaceOrientations`
    // method in any view controller and it would respect that orientation
    // setting per view controller.
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return topViewController?.preferredInterfaceOrientations ?? preferredInterfaceOrientations ?? topViewController?.supportedInterfaceOrientations() ?? super.supportedInterfaceOrientations()
    }

    // Setting `preferredStatusBarStyle` works.
    public override func childViewControllerForStatusBarStyle() -> UIViewController? {
        if topViewController?.statusBarStyle != nil || statusBarStyle != nil {
            return nil
        } else {
            return topViewController
        }
    }

    // Setting `prefersStatusBarHidden` works.
    public override func childViewControllerForStatusBarHidden() -> UIViewController? {
        if topViewController?.isStatusBarHidden != nil || isStatusBarHidden != nil {
            return nil
        } else {
            return topViewController
        }
    }

    public override func shouldAutorotate() -> Bool {
        return topViewController?.enableAutorotate ?? enableAutorotate ?? topViewController?.shouldAutorotate() ?? super.shouldAutorotate()
    }

    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return topViewController?.statusBarStyle ?? statusBarStyle ?? topViewController?.preferredStatusBarStyle() ?? super.preferredStatusBarStyle()
    }

    public override func prefersStatusBarHidden() -> Bool {
        return topViewController?.isStatusBarHidden ?? isStatusBarHidden ?? topViewController?.prefersStatusBarHidden() ?? super.prefersStatusBarHidden()
    }
}

// MARK: UITabBarController Extension

public extension UITabBarController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations() ?? super.supportedInterfaceOrientations()
    }

    public override func shouldAutorotate() -> Bool {
        return selectedViewController?.shouldAutorotate() ?? super.shouldAutorotate()
    }
}

// MARK: UINavigationBar Extension

public extension UINavigationBar {
    private struct AssociatedKey {
        static var IsTransparent = "Xcore_IsTransparent"
    }

    public var isTransparent: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.IsTransparent) as? Bool ?? false }
        set {
            guard newValue != isTransparent else { return }
            objc_setAssociatedObject(self, &AssociatedKey.IsTransparent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                setBackgroundImage(UIImage(), forBarMetrics: .Default)
                shadowImage     = UIImage()
                translucent     = true
                backgroundColor = UIColor.clearColor()
            } else {
                setBackgroundImage(nil, forBarMetrics: .Default)
            }
        }
    }
}

// MARK: UIToolbar Extension

public extension UIToolbar {
    private struct AssociatedKey {
        static var IsTransparent = "Xcore_IsTransparent"
    }

    public var isTransparent: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.IsTransparent) as? Bool ?? false }
        set {
            guard newValue != isTransparent else { return }
            objc_setAssociatedObject(self, &AssociatedKey.IsTransparent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                setBackgroundImage(UIImage(), forToolbarPosition: .Any, barMetrics: .Default)
                translucent     = true
                backgroundColor = UIColor.clearColor()
            } else {
                setBackgroundImage(nil, forToolbarPosition: .Any, barMetrics: .Default)
            }
        }
    }
}

// MARK: UIButton Extension

extension UIButton {
    /// Add space between `text` and `image` while preserving the `intrinsicContentSize` and respecting `sizeToFit`.
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

    public override func tintColorDidChange() {
        super.tintColorDidChange()
        imageView?.tintColor = tintColor
    }

    /// The image used for the normal state.
    public var image: UIImage? {
        get { return imageForState(.Normal) }
        set { setImage(newValue, forState: .Normal) }
    }

    /// The image used for the highlighted state.
    public var highlightedImage: UIImage? {
        get { return imageForState(.Highlighted) }
        set { setImage(newValue, forState: .Highlighted) }
    }

    /// The text used for the normal state.
    public var text: String? {
        get { return titleForState(.Normal) }
        set { setTitle(newValue, forState: .Normal) }
    }

    /// The text used for the highlighted state.
    public var highlightedText: String? {
        get { return titleForState(.Highlighted) }
        set { setTitle(newValue, forState: .Highlighted) }
    }

    /// The color of the title used for the normal state.
    public var textColor: UIColor? {
        get { return titleColorForState(.Normal) }
        set { setTitleColor(newValue, forState: .Normal) }
    }

    /// The color of the title used for the highlighted state.
    public var highlightedTextColor: UIColor? {
        get { return titleColorForState(.Highlighted) }
        set { setTitleColor(newValue, forState: .Highlighted) }
    }

    /// Creates and returns a new button of the specified type with action handler.
    ///
    /// - parameter image:            The image to use for the normal state.
    /// - parameter highlightedImage: The image to use for the highlighted state.
    /// - parameter handler:          The block to invoke when the button is tapped.
    ///
    /// - returns: A newly created button.
    public convenience init(image: UIImage?, highlightedImage: UIImage? = nil, handler: ((sender: UIButton) -> Void)? = nil) {
        self.init(type: UIButtonType.Custom)
        setImage(image, forState: .Normal)
        setImage(highlightedImage, forState: .Highlighted)
        imageView?.contentMode = .ScaleAspectFit
        imageView?.tintColor   = tintColor
        if let handler = handler {
            addAction(.TouchUpInside, handler: handler)
        }
    }

    /// Creates and returns a new button of the specified type with action handler.
    ///
    /// - parameter imageNamed: A string to identify a local or a remote image.
    /// - parameter handler:    The block to invoke when the button is tapped.
    ///
    /// - returns: A newly created button.
    public convenience init(imageNamed: String, handler: ((sender: UIButton) -> Void)? = nil) {
        self.init(image: nil, handler: handler)
        imageView?.remoteOrLocalImage(imageNamed) {[weak self] image in
            self?.setImage(image, forState: .Normal)
        }
    }
}

// MARK: UILabel Extension

public extension UILabel {
    public func setText(text: String, animated: Bool, duration: NSTimeInterval = 0.5) {
        if animated && text != self.text {
            UIView.transitionWithView(self, duration: duration, options: [.CurveEaseInOut, .TransitionCrossDissolve], animations: {[weak self] in
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

    @nonobjc
    public convenience init(hex: String, alpha: CGFloat = 1.0) {
        var hexString = hex
        if hexString.hasPrefix("#"), let cleanString = hexString.stripPrefix("#") {
            hexString = cleanString
        }

        if let hex = Int(hexString, radix: 16) {
            self.init(hex: hex, alpha: alpha)
        } else {
            self.init(hex: 0x000000, alpha: alpha)
        }
    }

    public var alpha: CGFloat {
        get { return CGColorGetAlpha(CGColor) }
        set { colorWithAlphaComponent(newValue) }
    }

    public func alpha(value: CGFloat) -> UIColor {
        return colorWithAlphaComponent(value)
    }

    // Credit: http://stackoverflow.com/a/31466450

    public func lighter(amount: CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightness(1 + amount)
    }

    public func darker(amount: CGFloat = 0.25) -> UIColor {
        return hueColorWithBrightness(1 - amount)
    }

    private func hueColorWithBrightness(amount: CGFloat) -> UIColor {
        var hue: CGFloat        = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat      = 0

        if getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha) {
            return UIColor(hue: hue, saturation: saturation, brightness: brightness * amount, alpha: alpha)
        } else {
            return self
        }
    }
}

// MARK: UIImageView Extension

public extension UIImageView {
    /// Load the specified named image on the background thread.
    public func image(named: String) {
        dispatch.async.bg(.UserInitiated) {
            let image = UIImage(named: named)
            dispatch.async.main {
                self.image = image
            }
        }
    }

    /// Create animated images. This does not cache the images in memory.
    /// Thus, less memory consumption for one of images.
    ///
    /// - parameter name:     The name of the pattern (e.g., `"AnimationImage.png"`).
    /// - parameter range:    Images range (e.g., `0..<30` This will create: `"AnimationImage0.png"..."AnimationImage29.png"`).
    /// - parameter duration: The animation duration.
    public func createAnimatedImages(name: String, _ range: Range<Int>, _ duration: NSTimeInterval) {
        let prefix = name.stringByDeletingPathExtension
        let ext = name.pathExtension == "" ? "png" : name.pathExtension

        var images: [UIImage] = []
        for i in range {
            images.append(UIImage(fileName: "\(prefix)\(i).\(ext)")!)
        }

        animationImages      = images
        animationDuration    = duration
        animationRepeatCount = 1
        image                = images.first
    }

    /// A convenience method to start animation with completion handler.
    ///
    /// - parameter endImage:   Image to set when the animation finishes.
    /// - parameter completion: The block to execute after the animation finishes.
    public func startAnimating(endImage endImage: UIImage? = nil, completion: (() -> Void)?) {
        if endImage != nil {
            image = endImage
        }
        startAnimating()
        delayBy(animationDuration) {[weak self] in
            self?.stopAnimating()
            self?.animationImages = nil
            delayBy(0.5) {
                completion?()
            }
        }
    }
}

// MARK: UIImage Extension

public extension UIImage {
    /// Creates an image from specified color and size.
    ///
    /// The default size is `CGSize(width: 50, height: 50)`.
    public convenience init(color: UIColor, size: CGSize = CGSize(width: 50, height: 50)) {
        let rect = CGRect(origin: CGPointZero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillRect(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(CGImage: image.CGImage!)
    }

    /// Identical to `UIImage:named` but does not cache images in memory.
    /// This is great for animations to quickly discard images after use.
    public convenience init?(fileName: String) {
        let name = fileName.stringByDeletingPathExtension
        let ext  = fileName.pathExtension == "" ? "png" : fileName.pathExtension
        if let path = NSBundle.mainBundle().pathForResource(name, ofType: ext) {
            self.init(contentsOfFile: path)
        } else {
            return nil
        }
    }

    /// Creating arbitrarily-colored icons from a black-with-alpha master image.
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
        dispatch.async.bg(.UserInitiated) {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            self.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            let tintedImage: UIImage
            if let tintColor = tintColor {
                tintedImage = newImage.tintColor(tintColor)
            } else {
                tintedImage = newImage
            }
            dispatch.async.main {
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
    ///```
    /// func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    ///     snapRowsToTop(targetContentOffset, cellHeight: cellHeight, headerHeight: headerHeight)
    /// }
    ///```
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
                let indexPath           = NSIndexPath(forRow: r, inSection: s)
                var rowHeight           = self.delegate?.tableView?(self, heightForRowAtIndexPath: indexPath) ?? 0
                var sectionHeaderHeight = self.delegate?.tableView?(self, heightForHeaderInSection: s) ?? 0
                var sectionFooterHeight = self.delegate?.tableView?(self, heightForFooterInSection: s) ?? 0
                rowHeight               = rowHeight == 0 ? self.rowHeight : rowHeight
                sectionFooterHeight     = sectionFooterHeight == 0 ? self.sectionFooterHeight : sectionFooterHeight
                sectionHeaderHeight     = sectionHeaderHeight == 0 ? self.sectionHeaderHeight : sectionHeaderHeight
                offsetY                += rowHeight + sectionHeaderHeight + sectionFooterHeight
            }
        }

        // Tell the animation to end at the top of that row.
        targetContentOffset.memory.y = offsetY
    }

    /// Compares the top two visible rows to the current content offset
    /// and returns the best index path that is visible on the top.
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

// MARK: UIDevice Extension

public extension UIDevice {
    public struct ScreenSize {
        public static var width: CGFloat     { return UIScreen.mainScreen().bounds.width }
        public static var height: CGFloat    { return UIScreen.mainScreen().bounds.height }
        public static var minLength: CGFloat { return min(width, height) }
        public static var maxLength: CGFloat { return max(width, height) }
    }

    public struct DeviceType {
        public static var iPhone4OrLess: Bool { return UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength < 568 }
        public static var iPhone5: Bool       { return UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 568 }
        public static var iPhone6: Bool       { return UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 667 }
        public static var iPhone6Plus: Bool   { return UIDevice.currentDevice().userInterfaceIdiom == .Phone && ScreenSize.maxLength == 736 }
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

// MARK: NSBundle Extension

public extension NSBundle {
    public static var appVersionNumber: String {
        return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    public static var appBuildNumber: String {
        return NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String ?? ""
    }
}
