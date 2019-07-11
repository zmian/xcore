//
// ModallyPresentable.swift
//
// Copyright © 2017 Xcore
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

/// Presents a view controller modally.
public protocol ModallyPresentable {
    /// Returns a bar button item that dismisses `self`.
    func dismissBarButtonItem() -> UIBarButtonItem

    /// Returns the class used to create the `UINavigationController` instance
    /// for this view controller.
    ///
    /// The default value is `UINavigationController.self`.
    var navigationControllerClassWhenModallyPresented: UINavigationController.Type { get }
}

extension ModallyPresentable {
    public var navigationControllerClassWhenModallyPresented: UINavigationController.Type {
        return UINavigationController.self
    }
}

extension ModallyPresentable where Self: UIViewController {
    /// Returns a bar button item that dismisses `self`.
    public func dismissBarButtonItem() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .cancel).apply {
            $0.accessibilityIdentifier = "dismissButton"
            $0.addAction { [weak self] _ in
                self?.dismiss(animated: true)
            }
        }
    }

    /// Presents a view controller modally.
    public func present(presentingViewController: UIViewController? = nil) {
        guard
            let presentingViewController = presentingViewController ??
                UIApplication.sharedOrNil?.keyWindow?.topViewController ??
                UIApplication.sharedOrNil?.delegate?.window??.topViewController
        else {
            return
        }

        navigationItem.leftBarButtonItem = dismissBarButtonItem()

        let NavigationController = navigationControllerClassWhenModallyPresented

        // There is bug in `tableView:didSelectRowAtIndexPath` that causes delay in presenting
        // `UIAlertController` and wrapping the `presentViewController:` call in `DispatchQueue.main.async` fixes it.
        //
        // http://openradar.appspot.com/19285091
        DispatchQueue.main.async { [weak presentingViewController] in
            let nvc = NavigationController.init(rootViewController: self)
            presentingViewController?.present(nvc, animated: true)
        }
    }
}
