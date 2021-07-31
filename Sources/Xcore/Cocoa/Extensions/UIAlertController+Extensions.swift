//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol PopoverPresentationSourceView {}

extension UIView: PopoverPresentationSourceView {}
extension UIBarButtonItem: PopoverPresentationSourceView {}

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

/// Displays an instance of `UIAlertController` with the given `title` and
/// `message`, and an OK button to dismiss it.
func alert(title: String = "", message: String = "") {
    UIAlertController(title: title, message: message, preferredStyle: .alert).apply {
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        $0.addAction(cancelAction)
        $0.show()
    }
}

extension UIAlertController {
    open func show(presentingViewController: UIViewController? = nil) {
        guard let presentingViewController = presentingViewController ?? UIApplication.sharedOrNil?.firstSceneKeyWindow?.topViewController else {
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
    ///   - actions: A an array of `UIAlertAction` to display.
    ///   - title: The title of the alert. Use this string to get the user’s
    ///     attention and communicate the reason for the alert.
    ///   - message: Descriptive text that provides additional details about the
    ///     reason for the alert.
    ///   - sourceView: A source view that presented the alert. A required property
    ///     for iPad support.
    ///   - style: The style to use when presenting the alert controller. Use this
    ///     parameter to configure the alert controller as an action sheet or as a
    ///     modal alert. The default value is `.actionSheet`.
    ///   - appendsCancelAction: An item to automatically append cancel action in
    ///     addition to the provided array of actions. The default value is `true`.
    @discardableResult
    static func present(
        actions: [UIAlertAction],
        title: String? = nil,
        message: String? = nil,
        sourceView: PopoverPresentationSourceView,
        style: Style = .actionSheet,
        appendsCancelAction: Bool = true
    ) -> UIAlertController {
        let alertController = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )

        // For iPad support
        alertController.popoverPresentationController?.setSourceView(sourceView)

        for action in actions {
            alertController.addAction(action)
        }

        if appendsCancelAction {
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel) { [weak alertController] _ in
                alertController?.dismiss(animated: true)
            })
        }

        alertController.show()
        return alertController
    }
}

extension UIAlertController {
    /// A convenience method to display an action sheet with list of specified
    /// items.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let items = ["Year", "Month", "Day"]
    /// UIAlertController.present(items, sourceView: button) { item in
    ///     print("selected item:" item)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - sourceView: A source view that presented the alert. A required property
    ///     for iPad support.
    ///   - handler: A closure to invoke when an item is selected.
    @discardableResult
    static func present(
        _ items: [String],
        title: String? = nil,
        message: String? = nil,
        sourceView: PopoverPresentationSourceView,
        _ handler: @escaping (_ item: String) -> Void
    ) -> UIAlertController {
        let actions = items.map { item in
            UIAlertAction(title: item, style: .default) { _ in
                handler(item)
            }
        }

        return present(
            actions: actions,
            title: title,
            message: message,
            sourceView: sourceView
        )
    }
}
