//
// UIKitBlocks.swift
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
import ObjectiveC

private class ClosureWrapper: NSObject, NSCopying {
    var closure: (() -> Void)?

    convenience init(_ closure: (() -> Void)?) {
        self.init()
        self.closure = closure
    }

    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return ClosureWrapper(closure)
    }
}

extension UIBarButtonItem {
    private struct AssociatedKey {
        static var ActionHandler = "Xcore_ActionHandler"
    }

    private var tapAction: (() -> Void)? {
        get { return (objc_getAssociatedObject(self, &AssociatedKey.ActionHandler) as? ClosureWrapper)?.closure }
        set { objc_setAssociatedObject(self, &AssociatedKey.ActionHandler, ClosureWrapper(newValue), .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    @objc private func performActionHandler() {
        tapAction?()
    }

    private func actionHandler(callback: () -> Void) {
        tapAction = callback
        target    = self
        action    = "performActionHandler"
    }
}

// MARK: Block-based Interface

extension UIBarButtonItem {
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle, handler: (() -> Void)? = nil) {
        self.init(image: image, style: style, target: nil, action: nil)
        if let handler = handler {
            actionHandler(handler)
        }
    }

    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle, handler: (() -> Void)? = nil) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        if let handler = handler {
            actionHandler(handler)
        }
    }

    public convenience init(title: String?, style: UIBarButtonItemStyle, handler: (() -> Void)? = nil) {
        self.init(title: title, style: style, target: nil, action: nil)
        if let handler = handler {
            actionHandler(handler)
        }
    }

    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, handler: (() -> Void)? = nil) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        if let handler = handler {
            actionHandler(handler)
        }
    }
}
