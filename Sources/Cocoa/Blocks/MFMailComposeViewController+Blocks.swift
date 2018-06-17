//
// MFMailComposeViewController+Blocks.swift
//
// Copyright © 2015 Zeeshan Mian
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

private class MailClosureWrapper: NSObject {
    var closure: ((_ controller: MFMailComposeViewController, _ result: MFMailComposeResult, _ error: Error?) -> Void)?

    init(_ closure: ((_ controller: MFMailComposeViewController, _ result: MFMailComposeResult, _ error: Error?) -> Void)?) {
        self.closure = closure
    }
}

extension MFMailComposeViewController: MFMailComposeViewControllerDelegate {
    private struct AssociatedKey {
        static var actionHandler = "actionHandler"
        static var shouldAutoDismiss = "shouldAutoDismiss"
    }

    private var actionHandlerWrapper: MailClosureWrapper? {
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

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let actionHandler = actionHandlerWrapper?.closure {
            actionHandler(controller, result, error)
        }

        if shouldAutoDismiss {
            controller.dismiss(animated: true)
        }
    }

    public func didFinishWithResult(_ handler: @escaping (_ controller: MFMailComposeViewController, _ result: MFMailComposeResult, _ error: Error?) -> Void) {
        mailComposeDelegate = self
        actionHandlerWrapper = MailClosureWrapper(handler)
    }
}
