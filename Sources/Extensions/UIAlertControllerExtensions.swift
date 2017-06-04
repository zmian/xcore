//
// UIAlertControllerExtensions.swift
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

/// Displays an instance of `UIAlertController` with the given `title` and `message`, and an OK button to dismiss it.
public func alert(title: String = "", message: String = "") {
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    alertController.addAction(cancelAction)
    alertController.show()
}

extension UIAlertController {
    open func show(presentingViewController: UIViewController? = nil) {
        guard let presentingViewController = presentingViewController ?? UIApplication.shared.keyWindow?.topViewController else { return }

        // There is bug in `tableView:didSelectRowAtIndexPath` that causes delay in presenting
        // `UIAlertController` and wrapping the `presentViewController:` call in `DispatchQueue.main.async` fixes it.
        //
        // http://openradar.appspot.com/19285091
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            presentingViewController.present(weakSelf, animated: true)
        }
    }
}

extension UIAlertController {
    /// A convenience method to present multiple actions using `UIAlertController`.
    ///
    /// - parameter actions:                         A an array of `UIAlertAction` to display.
    /// - parameter title:                           The title of the alert. Use this string to get the user’s attention and communicate the reason for the alert.
    /// - parameter message:                         Descriptive text that provides additional details about the reason for the alert.
    /// - parameter sourceView:                      A source view that presented the alert. A required property for iPad support.
    /// - parameter style:                           The style to use when presenting the alert controller.
    ///                                              Use this parameter to configure the alert controller as an action sheet or as a modal alert.
    ///                                              The default value is `.actionSheet`.
    /// - parameter automaticallyAppendCancelAction: An option to automatically append cancel action in addition to the provided array of actions.
    ///                                              The default value is `true`.
    @discardableResult
    open static func present(actions: [UIAlertAction], title: String? = nil, message: String? = nil, sourceView: UIView, style: UIAlertControllerStyle = .actionSheet, automaticallyAppendCancelAction: Bool = true) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)

        // For iPad support
        alertController.popoverPresentationController?.sourceView = sourceView
        alertController.popoverPresentationController?.sourceRect = sourceView.bounds

        for action in actions {
            alertController.addAction(action)
        }

        if automaticallyAppendCancelAction {
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
    /// - parameter sourceView: A source view that presented the alert. A required property for iPad support.
    /// - parameter handler:    A block to invoke when an option is selected.
    @discardableResult
    open static func present(options: [String], title: String? = nil, message: String? = nil, sourceView: UIView, _ handler: @escaping (_ option: String) -> Void) -> UIAlertController {
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
    /// enum CompassPoint: Int, EnumIteratable, OptionsRepresentable {
    ///     case north, south, east, west
    /// }
    ///
    /// UIAlertController.present(sourceView: button) { (option: CompassPoint) -> Void in
    ///     print("selected option:" option)
    /// }
    /// ```
    ///
    /// - parameter sourceView: A source view that presented the alert. A required property for iPad support.
    /// - parameter handler:    A block to invoke when an option is selected.
    @discardableResult
    open static func present<T: OptionsRepresentable>(sourceView: UIView, _ handler: @escaping (_ option: T) -> Void) -> UIAlertController {
        let options = T.allValues
        let actions = options.map { option in
            UIAlertAction(title: option.description, style: .default) { _ in
                handler(option)
            }
        }

        return present(actions: actions, title: T.title, message: T.message, sourceView: sourceView)
    }
}
