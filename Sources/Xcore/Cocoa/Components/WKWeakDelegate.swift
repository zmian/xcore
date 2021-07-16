//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import WebKit

/// `WKUserContentController` retains `WKScriptMessageHandler` so this object
/// exists to break that retain cycle.
private class WKWeakDelegate: NSObject, WKScriptMessageHandler {
    private weak var delegate: WKScriptMessageHandler?

    init(_ delegate: WKScriptMessageHandler) {
        self.delegate = delegate
        super.init()
    }

    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {
        delegate?.userContentController(userContentController, didReceive: message)
    }
}

// MARK: - Swizzle

extension WKUserContentController {
    static func runOnceSwapSelectors() {
        swizzle(
            WKUserContentController.self,
            originalSelector: #selector(WKUserContentController.add(_:name:)),
            swizzledSelector: #selector(WKUserContentController.swizzled_add(_:name:))
        )
    }

    @objc
    private func swizzled_add(_ scriptMessageHandler: WKScriptMessageHandler, name: String) {
        swizzled_add(WKWeakDelegate(scriptMessageHandler), name: name)
    }
}
