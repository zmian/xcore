//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import MessageUI

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

    private enum AssociatedKey {
        static var actionHandler = "actionHandler"
        static var shouldAutoDismiss = "shouldAutoDismiss"
    }

    private var actionHandlerWrapper: ClosureWrapper? {
        get { associatedObject(&AssociatedKey.actionHandler) }
        set { setAssociatedObject(&AssociatedKey.actionHandler, value: newValue) }
    }

    public var shouldAutoDismiss: Bool {
        get { associatedObject(&AssociatedKey.shouldAutoDismiss, default: false) }
        set {
            mailComposeDelegate = self
            setAssociatedObject(&AssociatedKey.shouldAutoDismiss, value: newValue)
        }
    }

    public func didFinishWithResult(
        _ handler: @escaping (_ controller: MFMailComposeViewController, _ result: Result) -> Void
    ) {
        mailComposeDelegate = self
        actionHandlerWrapper = ClosureWrapper(handler)
    }
}
