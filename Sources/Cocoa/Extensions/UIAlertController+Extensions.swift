//
// UIAlertController+Extensions.swift
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

public protocol PopoverPresentationSourceView {
}

extension UIView: PopoverPresentationSourceView { }
extension UIBarButtonItem: PopoverPresentationSourceView { }

extension UIPopoverPresentationController {
    public func setSourceView(_ sourceView: PopoverPresentationSourceView) {
        // For iPad support
        if let sourceView = sourceView as? UIView {
            self.sourceView = sourceView
            self.sourceRect = sourceView.bounds
        } else if let sourceView = sourceView as? UIBarButtonItem {
            self.barButtonItem = sourceView
        }
    }
}

/// Displays an instance of `UIAlertController` with the given `title` and `message`, and an OK button to dismiss it.
public func alert(title: String = "", message: String = "") {
    UIAlertController(title: title, message: message, preferredStyle: .alert).apply {
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        $0.addAction(cancelAction)
        $0.show()
    }
}

extension UIAlertController {
    open func show(presentingViewController: UIViewController? = nil) {
        guard let presentingViewController = presentingViewController ?? UIApplication.sharedOrNil?.keyWindow?.topViewController else {
            return
        }

        // There is bug in `tableView:didSelectRowAtIndexPath` that causes delay in
        // presenting `UIAlertController` and wrapping the `presentViewController:` call
        // in `DispatchQueue.main.async` fixes it.
        //
        // http://openradar.appspot.com/19285091
        DispatchQueue.main.async { [weak presentingViewController] in
            presentingViewController?.present(self, animated: true)
        }
    }
}

extension UIAlertController {
    /// A convenience method to present multiple actions using `UIAlertController`.
    ///
    /// - Parameters:
    ///   - actions:             A an array of `UIAlertAction` to display.
    ///   - title:               The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    ///   - message:             Descriptive text that provides additional details about the reason for the alert.
    ///   - sourceView:          A source view that presented the alert. A required property for iPad support.
    ///   - style:               The style to use when presenting the alert controller.
    ///                          Use this parameter to configure the alert controller as an action sheet or as a modal alert.
    ///                          The default value is `.actionSheet`.
    ///   - appendsCancelAction: An option to automatically append cancel action in addition to the provided array of actions.
    ///                          The default value is `true`.
    @discardableResult
    public static func present(actions: [UIAlertAction], title: String? = nil, message: String? = nil, sourceView: PopoverPresentationSourceView, style: Style = .actionSheet, appendsCancelAction: Bool = true) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

        // For iPad support
        alertController.popoverPresentationController?.setSourceView(sourceView)

        for action in actions {
            alertController.addAction(action)
        }

        if appendsCancelAction {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak alertController] action in
                alertController?.dismiss(animated: true)
            })
        }

        alertController.show()
        return alertController
    }
}

extension UIAlertController {
    /// A convenience method to display an action sheet with list of specified options.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// let options = ["Year", "Month", "Day"]
    /// UIAlertController.present(options: options, sourceView: button) { option in
    ///     print("selected option:" option)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - sourceView: A source view that presented the alert. A required property for iPad support.
    ///   - handler: A block to invoke when an option is selected.
    @discardableResult
    public static func present(options: [String], title: String? = nil, message: String? = nil, sourceView: PopoverPresentationSourceView, _ handler: @escaping (_ option: String) -> Void) -> UIAlertController {
        let actions = options.map { option in
            UIAlertAction(title: option, style: .default) { _ in
                handler(option)
            }
        }

        return present(actions: actions, title: title, message: message, sourceView: sourceView)
    }

    /// A convenience method to display an action sheet with list of specified options
    /// that conforms to `OptionsRepresentable` protocol.
    ///
    /// **Example:**
    ///
    /// ```swift
    /// enum CompassPoint: Int, CaseIterable, OptionsRepresentable {
    ///     case north
    ///     case south
    ///     case east
    ///     case west
    /// }
    ///
    /// UIAlertController.present(sourceView: button) { (option: CompassPoint) -> Void in
    ///     print("selected option:" option)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - sourceView: A source view that presented the alert. A required property for iPad support.
    ///   - handler: A block to invoke when an option is selected.
    @discardableResult
    public static func present<T: OptionsRepresentable>(sourceView: PopoverPresentationSourceView, _ handler: @escaping (_ option: T) -> Void) -> UIAlertController {
        let options = T.allCases
        let actions = options.map { option in
            UIAlertAction(title: option.description, style: .default) { _ in
                handler(option)
            }
        }

        return present(actions: actions, title: T.title, message: T.message, sourceView: sourceView)
    }
}
