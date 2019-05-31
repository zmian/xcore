//
// MFMailComposeViewController+Blocks.swift
//
// Copyright © 2015 Xcore
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
import MessageUI
import ObjectiveC

extension MFMailComposeViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        var value: Result

        if let actionHandler = actionHandlerWrapper?.closure {
            if let error = error {
                value = .failure(error)
            } else {
                value = .success(result)
            }

            actionHandler(controller, value)
        }

        if shouldAutoDismiss {
            controller.dismiss(animated: true)
        }
    }
}

extension MFMailComposeViewController {
    public typealias Result = Swift.Result<MFMailComposeResult, Error>

    private class ClosureWrapper: NSObject {
        var closure: ((_ controller: MFMailComposeViewController, _ result: Result) -> Void)?

        init(_ closure: ((_ controller: MFMailComposeViewController, _ result: Result) -> Void)?) {
            self.closure = closure
        }
    }

    private struct AssociatedKey {
        static var actionHandler = "actionHandler"
        static var shouldAutoDismiss = "shouldAutoDismiss"
    }

    private var actionHandlerWrapper: ClosureWrapper? {
        get { return associatedObject(&AssociatedKey.actionHandler) }
        set { setAssociatedObject(&AssociatedKey.actionHandler, value: newValue) }
    }

    public var shouldAutoDismiss: Bool {
        get { return associatedObject(&AssociatedKey.shouldAutoDismiss, default: false) }
        set {
            mailComposeDelegate = self
            setAssociatedObject(&AssociatedKey.shouldAutoDismiss, value: newValue)
        }
    }

    public func didFinishWithResult(_ handler: @escaping (_ controller: MFMailComposeViewController, _ result: Result) -> Void) {
        mailComposeDelegate = self
        actionHandlerWrapper = ClosureWrapper(handler)
    }
}
