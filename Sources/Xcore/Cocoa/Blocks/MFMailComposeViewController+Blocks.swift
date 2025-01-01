//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import MessageUI

extension MFMailComposeViewController: @retroactive @preconcurrency MFMailComposeViewControllerDelegate {
    public func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        if let actionHandler = actionHandler?.handler {
            let value = error.map(Result.failure) ?? .success(result)
            actionHandler(controller, value)
        }

        if shouldAutoDismiss {
            controller.dismiss(animated: true)
        }
    }
}

extension MFMailComposeViewController {
    public typealias Result = Swift.Result<MFMailComposeResult, Error>
    public typealias Handler = (_ controller: MFMailComposeViewController, _ result: Result) -> Void

    private class ClosureWrapper: NSObject {
        var handler: Handler?

        init(_ handler: Handler?) {
            self.handler = handler
        }
    }

    private enum AssociatedKey {
        nonisolated(unsafe) static var actionHandler = "actionHandler"
        nonisolated(unsafe) static var shouldAutoDismiss = "shouldAutoDismiss"
    }

    private var actionHandler: ClosureWrapper? {
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

    public func didFinishWithResult(_ handler: @escaping Handler) {
        mailComposeDelegate = self
        actionHandler = ClosureWrapper(handler)
    }
}
