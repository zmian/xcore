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

/// Attempts to open the resource at the specified URL.
///
/// Requests are made using `SafariViewController` if available;
/// otherwise it uses `UIApplication:openURL`.
///
/// - parameter url:                      The url to open.
/// - parameter presentingViewController: A view controller that wants to open the url.
public func open(url: URL, presentingViewController: UIViewController) {
    if #available(iOS 9.0, *) {
        let svc = SFSafariViewController(url: url)
        presentingViewController.present(svc, animated: true, completion: nil)
    } else {
        UIApplication.shared.openURL(url)
    }
}

/// Displays an instance of `UIAlertController` with the given `title` and `message`, and an OK button to dismiss it.
public func alert(title: String = "", message: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    alertController.show()
}

// MARK: UIAlertController Extension

extension UIAlertController {
    open func show(presentingViewController: UIViewController? = nil) {
        guard let presentingViewController = presentingViewController ?? UIApplication.shared.keyWindow?.topViewController else { return }

        // There is bug in `tableView:didSelectRowAtIndexPath` that causes delay in presenting
        // `UIAlertController` and wrapping the `presentViewController:` call in `dispatch.async.main` fixes it.
        //
        // http://openradar.appspot.com/19285091
        dispatch.async.main {
            presentingViewController.present(self, animated: true)
        }
    }
}

// MARK: UIApplication Extension

extension UIApplication {
    open class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.visibleViewController)
        }

        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }

        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }

        return base
    }
}

// MARK: UIWindow Extension

extension UIWindow {
    /// The view controller at the top of the window's `rootViewController` stack.
    open var topViewController: UIViewController? {
        return UIApplication.topViewController(rootViewController)
    }
}

// MARK: UINavigationController Extension

extension UINavigationController {
    /// Initializes and returns a newly created navigation controller that uses your custom bar subclasses.
    ///
    /// - parameter rootViewController: The view controller that resides at the bottom of the navigation stack. This object cannot be an instance of the `UITabBarController` class.
    /// - parameter navigationBarClass: Specify the custom `UINavigationBar` subclass you want to use, or specify `nil` to use the standard `UINavigationBar` class.
    /// - parameter toolbarClass:       Specify the custom `UIToolbar` subclass you want to use, or specify `nil` to use the standard `UIToolbar` class.
    ///
    /// - returns: The initialized navigation controller object.
    public convenience init(rootViewController: UIViewController, navigationBarClass: AnyClass?, toolbarClass: AnyClass?) {
        self.init(navigationBarClass: navigationBarClass, toolbarClass: toolbarClass)
        self.rootViewController = rootViewController
    }

    /// A convenience property to set root view controller without animation.
    open var rootViewController: UIViewController? {
        get { return viewControllers.first }
        set {
            var rvc: [UIViewController] = []
            if let vc = newValue {
                rvc = [vc]
            }
            setViewControllers(rvc, animated: false)
        }
    }

    /// A convenience method to pop to view controller of specified subclass of `UIViewController` type.
    ///
    /// - parameter type:            The View controller type to pop to.
    /// - parameter animated:        Set this value to true to animate the transition.
    ///                              Pass `false` if you are setting up a navigation controller
    ///                              before its view is displayed.
    /// - parameter isReversedOrder: If multiple view controllers of specified type exists it
    ///                              pop the latest of type by default. Pass `false` to reverse the behavior.
    open func popToViewController(ofClassType type: UIViewController.Type, animated: Bool, isReversedOrder: Bool = true) {
        let viewControllers = isReversedOrder ? self.viewControllers.reversed() : self.viewControllers

        for viewController in viewControllers {
            if viewController.isKind(of: type) {
                popToViewController(viewController, animated: animated)
                break
            }
        }
    }
}

extension UINavigationController {
    // Autorotation Fix. Simply override `supportedInterfaceOrientations`
    // method in any view controller and it would respect that orientation
    // setting per view controller.
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.preferredInterfaceOrientations ?? preferredInterfaceOrientations ?? topViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.interfaceOrientationForPresentation ?? interfaceOrientationForPresentation ?? topViewController?.preferredInterfaceOrientationForPresentation ?? super.preferredInterfaceOrientationForPresentation
    }

    // Setting `preferredStatusBarStyle` works.
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        if topViewController?.statusBarStyle != nil || statusBarStyle != nil {
            return nil
        } else {
            return topViewController
        }
    }

    // Setting `prefersStatusBarHidden` works.
    open override var childViewControllerForStatusBarHidden: UIViewController? {
        if topViewController?.isStatusBarHidden != nil || isStatusBarHidden != nil {
            return nil
        } else {
            return topViewController
        }
    }

    open override var shouldAutorotate: Bool {
        return topViewController?.enableAutorotate ?? enableAutorotate ?? topViewController?.shouldAutorotate ?? super.shouldAutorotate
    }

    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return topViewController?.statusBarStyle ?? statusBarStyle ?? topViewController?.preferredStatusBarStyle ?? super.preferredStatusBarStyle
    }

    open override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return topViewController?.statusBarUpdateAnimation ?? statusBarUpdateAnimation ?? topViewController?.preferredStatusBarUpdateAnimation ?? super.preferredStatusBarUpdateAnimation
    }

    open override var prefersStatusBarHidden: Bool {
        return topViewController?.isStatusBarHidden ?? isStatusBarHidden ?? topViewController?.prefersStatusBarHidden ?? super.prefersStatusBarHidden
    }
}

extension UINavigationController {
    open func get<T>(viewController: T.Type) -> T? {
        for vc in viewControllers {
            if let vc = vc as? T {
                return vc
            }
        }

        return nil
    }

    open func pushOnFirstViewController(_ viewController: UIViewController, animated: Bool = true) {
        var vcs = [UIViewController]()
        if let firstViewController = viewControllers.first {
            vcs.append(firstViewController)
        }
        vcs.append(viewController)
        setViewControllers(vcs, animated: animated)
    }
}

// MARK: UITabBarController Extension

extension UITabBarController {
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return selectedViewController?.supportedInterfaceOrientations ?? super.supportedInterfaceOrientations
    }

    open override var shouldAutorotate: Bool {
        return selectedViewController?.shouldAutorotate ?? super.shouldAutorotate
    }
}

// MARK: UINavigationBar Extension

extension UINavigationBar {
    fileprivate struct AssociatedKey {
        static var isTransparent = "XcoreIsTransparent"
    }

    open var isTransparent: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.isTransparent) as? Bool ?? false }
        set {
            guard newValue != isTransparent else { return }
            objc_setAssociatedObject(self, &AssociatedKey.isTransparent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                setBackgroundImage(UIImage(), for: .default)
                shadowImage     = UIImage()
                isTranslucent   = true
                backgroundColor = .clear
            } else {
                setBackgroundImage(nil, for: .default)
            }
        }
    }
}

// MARK: UIToolbar Extension

extension UIToolbar {
    fileprivate struct AssociatedKey {
        static var isTransparent = "XcoreIsTransparent"
    }

    open var isTransparent: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.isTransparent) as? Bool ?? false }
        set {
            guard newValue != isTransparent else { return }
            objc_setAssociatedObject(self, &AssociatedKey.isTransparent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                setBackgroundImage(UIImage(), forToolbarPosition: .any, barMetrics: .default)
                isTranslucent   = true
                backgroundColor = .clear
            } else {
                setBackgroundImage(nil, forToolbarPosition: .any, barMetrics: .default)
            }
        }
    }
}

// MARK: UITabBar Extension

extension UITabBar {
    fileprivate struct AssociatedKey {
        static var isTransparent = "XcoreIsTransparent"
    }

    open var isTransparent: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.isTransparent) as? Bool ?? false }
        set {
            guard newValue != isTransparent else { return }
            objc_setAssociatedObject(self, &AssociatedKey.isTransparent, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)

            if newValue {
                backgroundImage = UIImage()
                shadowImage     = UIImage()
                isTranslucent   = true
                backgroundColor = .clear
            } else {
                backgroundImage = nil
            }
        }
    }

    open var isBorderHidden: Bool {
        get { return value(forKey: "_hidesShadow") as? Bool ?? false }
        set { setValue(newValue, forKey: "_hidesShadow") }
    }

    open func setBorder(color: UIColor, thickness: CGFloat = 1) {
        isBorderHidden = true
        addBorder(edges: .top, color: color, thickness: thickness)
    }
}

// MARK: UILabel Extension

extension UILabel {
    open func setText(_ text: String, animated: Bool, duration: TimeInterval = 0.5) {
        if animated && text != self.text {
            UIView.transition(with: self, duration: duration, options: .transitionCrossDissolve, animations: {[weak self] in
                self?.text = text
            }, completion: nil)
        } else {
            self.text = text
        }
    }

    open func setLineSpacing(_ spacing: CGFloat, text: String? = nil) {
        guard let text = text ?? self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let attributedString = NSMutableAttributedString(string: text)
        attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
}

// MARK: UIImageView Extension

extension UIImageView {
    /// Load the specified named image on **background thread**.
    ///
    /// - parameter named:  The name of the image.
    /// - parameter bundle: The bundle the image file or asset catalog is located in, pass `nil` to use the main bundle.
    public func image(named: String, bundle: Bundle? = nil) {
        dispatch.async.bg(.userInitiated) {
            let image = UIImage(named: named, in: bundle, compatibleWith: nil)
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
    public func createAnimatedImages(_ name: String, _ range: Range<Int>, _ duration: TimeInterval) {
        let prefix = name.stringByDeletingPathExtension
        let ext = name.pathExtension == "" ? "png" : name.pathExtension

        var images: [UIImage] = []
        for i in range.lowerBound..<range.upperBound {
            if let image = UIImage(fileName: "\(prefix)\(i).\(ext)") {
                images.append(image)
            }
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
    public func startAnimating(endImage: UIImage? = nil, completion: (() -> Void)?) {
        if endImage != nil {
            image = endImage
        }
        startAnimating()
        delay(by: animationDuration) {[weak self] in
            self?.stopAnimating()
            self?.animationImages = nil
            delay(by: 0.5) {
                completion?()
            }
        }
    }

    /// Determines how the image is rendered.
    /// The default rendering mode is `UIImageRenderingModeAutomatic`.
    ///
    /// `Int` is workaround since `@IBInspectable` doesn't support enums.
    /// ```
    /// Possible Values:
    ///
    /// UIImageRenderingMode.automatic      // 0
    /// UIImageRenderingMode.alwaysOriginal // 1
    /// UIImageRenderingMode.alwaysTemplate // 2
    /// ```
    @IBInspectable public var renderingMode: Int {
        get { return image?.renderingMode.rawValue ?? UIImageRenderingMode.automatic.rawValue }
        set {
            guard let renderingMode = UIImageRenderingMode(rawValue: newValue) else { return }
            image?.withRenderingMode(renderingMode)
        }
    }
}

// MARK: UIImage Extension

extension UIImage {
    /// Creates an image from specified color and size.
    ///
    /// The default size is `50,50`.
    public convenience init(color: UIColor, size: CGSize = CGSize(width: 50, height: 50)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context?.setFillColor(color.cgColor)
        context?.fill(rect)
        if let image = UIGraphicsGetImageFromCurrentImageContext()?.cgImage {
            self.init(cgImage: image)
        } else {
            self.init()
        }
        UIGraphicsEndImageContext()
    }

    /// Identical to `UIImage:named` but does not cache images in memory.
    /// This is great for animations to quickly discard images after use.
    public convenience init?(fileName: String) {
        let name = fileName.stringByDeletingPathExtension
        let ext  = fileName.pathExtension == "" ? "png" : fileName.pathExtension
        if let path = Bundle.main.path(forResource: name, ofType: ext) {
            self.init(contentsOfFile: path)
        } else {
            return nil
        }
    }

    /// Creating arbitrarily-colored icons from a black-with-alpha master image.
    public func tintColor(_ color: UIColor) -> UIImage {
        let image = self
        let rect = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, image.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        image.draw(in: rect)
        ctx.setFillColor(color.cgColor)
        ctx.setBlendMode(.sourceAtop)
        ctx.fill(rect)
        return UIGraphicsGetImageFromCurrentImageContext()!
    }

    public func resize(_ newSize: CGSize, tintColor: UIColor? = nil, completionHandler: @escaping (_ resizedImage: UIImage) -> Void) {
        dispatch.async.bg(.userInitiated) {
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))

            guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else {
                return
            }

            UIGraphicsEndImageContext()
            let tintedImage: UIImage
            if let tintColor = tintColor {
                tintedImage = newImage.tintColor(tintColor)
            } else {
                tintedImage = newImage
            }
            dispatch.async.main {
                completionHandler(tintedImage)
            }
        }
    }

    // Credit: http://stackoverflow.com/a/34547445

    /// Colorize image with given tint color.
    ///
    /// This is similar to Photoshop's **Color** layer blend mode.
    /// This is perfect for non-greyscale source images, and images that have both highlights and shadows that should be preserved.
    /// White will stay white and black will stay black as the lightness of the image is preserved.
    ///
    /// Sample Result:
    ///
    /// <img src="http://yannickstephan.com/easyhelper/tint1.png" height="70" width="120"/>
    ///
    /// <img src="http://yannickstephan.com/easyhelper/tint2.png" height="70" width="120"/>
    ///
    /// - parameter tintColor: The color used to colorize `self`.
    ///
    /// - returns: Colorize image.
    public func colorize(_ tintColor: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }

        return modifiedImage { context, rect in
            // draw black background - workaround to preserve color of partially transparent pixels
            context.setBlendMode(.normal)
            UIColor.black.setFill()
            context.fill(rect)

            // draw original image
            context.setBlendMode(.normal)
            context.draw(cgImage, in: rect)

            // tint image (loosing alpha) - the luminosity of the original image is preserved
            context.setBlendMode(.color)
            tintColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage, in: rect)
        }
    }

    /// Tint Picto to color
    ///
    /// - parameter fillColor: UIColor
    ///
    /// - returns: UIImage
    public func tintPicto(_ fillColor: UIColor) -> UIImage {
        guard let cgImage = cgImage else { return self }

        return modifiedImage { context, rect in
            // draw tint color
            context.setBlendMode(.normal)
            fillColor.setFill()
            context.fill(rect)

            // mask by alpha values of original image
            context.setBlendMode(.destinationIn)
            context.draw(cgImage, in: rect)
        }
    }

    /// Modified Image Context, apply modification on image
    fileprivate func modifiedImage(_ draw: (CGContext, CGRect) -> ()) -> UIImage {
        // using scale correctly preserves retina images
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let context = UIGraphicsGetCurrentContext()!
        // correctly rotate image
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        let rect = CGRect(origin: .zero, size: size)
        draw(context, rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}

// MARK: UIScrollView Extension

extension UIScrollView {
    public enum ScrollDirection {
        case none, up, down, left, right, unknown
    }

    public var scrollDirection: ScrollDirection {
        let translation = panGestureRecognizer.translation(in: superview)

        if translation.y > 0 {
            return .down
        } else if !(translation.y > 0) {
            return .up
        }

        if translation.x > 0 {
            return .right
        } else if !(translation.x > 0) {
            return .left
        }

        return .unknown
    }
}

// MARK: UITableView Extension

extension UITableView {
    /// Adjust target offset so that cells are snapped to top.
    ///
    /// Call this method in scroll view delegate:
    ///```
    /// func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    ///     snapRowsToTop(targetContentOffset, cellHeight: cellHeight, headerHeight: headerHeight)
    /// }
    ///```
    public func snapRowsToTop(_ targetContentOffset: UnsafeMutablePointer<CGPoint>, cellHeight: CGFloat, headerHeight: CGFloat) {
        // Adjust target offset so that cells are snapped to top
        let section = (indexPathsForVisibleRows?.first?.section ?? 0) + 1
        targetContentOffset.pointee.y -= (targetContentOffset.pointee.y.truncatingRemainder(dividingBy: cellHeight)) - (CGFloat(section) * headerHeight)
    }

    // TODO: This can be use to handles a table view with varying row and section heights
    // Still needs testing
    fileprivate func snapRowsToTop(_ targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        // Find the indexPath where the animation will currently end.
        let indexPath = indexPathForRow(at: targetContentOffset.pointee) ?? IndexPath(row: 0, section: 0)

        var offsetY: CGFloat = 0
        for s in 0..<indexPath.section {
            for r in 0..<indexPath.row {
                let indexPath           = IndexPath(row: r, section: s)
                var rowHeight           = self.delegate?.tableView?(self, heightForRowAt: indexPath) ?? 0
                var sectionHeaderHeight = self.delegate?.tableView?(self, heightForHeaderInSection: s) ?? 0
                var sectionFooterHeight = self.delegate?.tableView?(self, heightForFooterInSection: s) ?? 0
                rowHeight               = rowHeight == 0 ? self.rowHeight : rowHeight
                sectionFooterHeight     = sectionFooterHeight == 0 ? self.sectionFooterHeight : sectionFooterHeight
                sectionHeaderHeight     = sectionHeaderHeight == 0 ? self.sectionHeaderHeight : sectionHeaderHeight
                offsetY                += rowHeight + sectionHeaderHeight + sectionFooterHeight
            }
        }

        // Tell the animation to end at the top of that row.
        targetContentOffset.pointee.y = offsetY
    }

    /// Compares the top two visible rows to the current content offset
    /// and returns the best index path that is visible on the top.
    public var visibleTopIndexPath: IndexPath? {
        let visibleRows  = indexPathsForVisibleRows ?? []
        let firstPath: IndexPath
        let secondPath: IndexPath

        if visibleRows.isEmpty {
            return nil
        } else if visibleRows.count == 1 {
            return visibleRows.first
        } else {
            firstPath  = visibleRows[0]
            secondPath = visibleRows[1]
        }

        let firstRowRect = rectForRow(at: firstPath)
        return firstRowRect.origin.y > contentOffset.y ? firstPath : secondPath
    }

    /// A convenience property for the index paths representing the selected rows.
    /// This simply return empty array when there are no selected rows instead of `nil`.
    ///
    /// ```
    /// return indexPathsForSelectedRows ?? []
    /// ```
    public var selectedIndexPaths: [IndexPath] {
        return indexPathsForSelectedRows ?? []
    }

    /// Deselects all selected rows, with an option to animate the deselection.
    ///
    /// Calling this method does not cause the delegate to receive a `tableView:willDeselectRowAtIndexPath:`
    /// or `tableView:didDeselectRowAtIndexPath:` message, nor does it send `UITableViewSelectionDidChangeNotification`
    /// notifications to observers.
    ///
    /// - parameter animated: true if you want to animate the deselection, and false if the change should be immediate.
    public func deselectAllRows(animated: Bool) {
        indexPathsForSelectedRows?.forEach {
            deselectRow(at: $0, animated: animated)
        }
    }

    /// Selects a row in the table view identified by index path, optionally scrolling the row to a location in the table view.
    ///
    /// Calling this method does not cause the delegate to receive a `tableView:willSelectRowAtIndexPath:` or
    /// `tableView:didSelectRowAtIndexPath:` message, nor does it send `UITableViewSelectionDidChangeNotification`
    /// notifications to observers.
    ///
    /// Passing `UITableViewScrollPositionNone` results in no scrolling, rather than the minimum scrolling described for that constant.
    /// To scroll to the newly selected row with minimum scrolling, select the row using this method with `UITableViewScrollPositionNone`,
    /// then call `scrollToRowAtIndexPath:atScrollPosition:animated:` with `UITableViewScrollPositionNone`.
    ///
    /// - parameter indexPaths:     An array of index paths identifying rows in the table view.
    /// - parameter animated:       Pass `true` if you want to animate the selection and any change in position;
    ///                             Pass `false` if the change should be immediate.
    /// - parameter scrollPosition: A constant that identifies a relative position in the table view (top, middle, bottom)
    ///                             for the row when scrolling concludes. The default value is `UITableViewScrollPositionNone`.
    public func selectRows(at indexPaths: [IndexPath], animated: Bool, scrollPosition: UITableViewScrollPosition = .none) {
        indexPaths.forEach {
            selectRow(at: $0, animated: animated, scrollPosition: scrollPosition)
        }
    }

    /// Toggles the table view into and out of editing mode with completion handler when animation is completed.
    ///
    /// - parameter editing:           `true` to enter editing mode; `false` to leave it. The default value is `false`.
    /// - parameter animated:          `true` to animate the transition to editing mode; `false` to make the transition immediate.
    /// - parameter completionHandler: A block object called when animation is completed.
    public func setEditing(_ editing: Bool, animated: Bool, completionHandler: @escaping () -> Void) {
        CATransaction.animationTransaction({
            setEditing(editing, animated: animated)
        }, completionHandler: completionHandler)
    }
}

@IBDesignable
extension UIDatePicker {
    @IBInspectable
    @nonobjc
    open var textColor: UIColor? {
        get { return value(forKey: "textColor") as? UIColor }
        set { setValue(newValue, forKey: "textColor") }
    }
}

extension UIRefreshControl {
    private struct AssociatedKey {
        static var timeoutTimer = "timeoutTimer"
    }

    private var timeoutTimer: Timer? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.timeoutTimer) as? Timer }
        set { objc_setAssociatedObject(self, &AssociatedKey.timeoutTimer, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    open func refreshingTimeout(after timeoutInterval: TimeInterval, completion: (() -> Void)? = nil) {
        timeoutTimer?.invalidate()
        timeoutTimer = Timer.schedule(delay: timeoutInterval) {[weak self] _ in
            guard let weakSelf = self else { return }
            weakSelf.endRefreshing()
            completion?()
        }
    }
}

extension UIBarButtonItem {
    open dynamic var textColor: UIColor? {
        get { return titleTextAttributes(for: .normal)?[NSForegroundColorAttributeName] as? UIColor }
        set {
            var attributes = titleTextAttributes(for: .normal) ?? [:]
            attributes[NSForegroundColorAttributeName] = newValue
            setTitleTextAttributes(attributes, for: .normal)
        }
    }

    open dynamic var font: UIFont? {
        get { return titleTextAttributes(for: .normal)?[NSFontAttributeName] as? UIFont }
        set {
            var attributes = titleTextAttributes(for: .normal) ?? [:]
            attributes[NSFontAttributeName] = newValue
            setTitleTextAttributes(attributes, for: .normal)
        }
    }
}
