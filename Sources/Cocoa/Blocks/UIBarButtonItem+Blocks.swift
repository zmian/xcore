//
// UIBarButtonItem+Blocks.swift
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
import ObjectiveC

extension UIBarButtonItem: TargetActionBlockRepresentable {
    public typealias Sender = UIBarButtonItem

    private struct AssociatedKey {
        static var actionHandler = "actionHandler"
    }

    fileprivate var actionHandler: SenderClosureWrapper? {
        get { return associatedObject(&AssociatedKey.actionHandler) }
        set { setAssociatedObject(&AssociatedKey.actionHandler, value: newValue) }
    }
}

extension TargetActionBlockRepresentable where Self: UIBarButtonItem {
    private func setActionHandler(_ handler: ((_ sender: Self) -> Void)?) {
        guard let handler = handler else {
            actionHandler = nil
            target = nil
            action = nil
            return
        }

        let wrapper = SenderClosureWrapper(nil)

        wrapper.closure = { sender in
            guard let sender = sender as? Self else { return }
            handler(sender)
        }

        actionHandler = wrapper
        target = wrapper
        action = #selector(wrapper.invoke(_:))
    }

    /// Add action handler when the item is selected.
    ///
    /// - Parameter handler: The block to invoke when the item is selected.
    public func addAction(_ handler: @escaping (_ sender: Self) -> Void) {
        setActionHandler(handler)
    }

    /// Removes action handler from `self`.
    public func removeAction() {
        setActionHandler(nil)
    }

    /// A boolean value to determine whether an action handler is attached.
    public var hasActionHandler: Bool {
        return actionHandler != nil
    }

    public init(image: UIImage?, landscapeImagePhone: UIImage? = nil, style: UIBarButtonItem.Style = .plain, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        setActionHandler(handler)
    }

    public init(title: String?, style: UIBarButtonItem.Style = .plain, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(title: title, style: style, target: nil, action: nil)
        setActionHandler(handler)
    }

    public init(barButtonSystemItem systemItem: UIBarButtonItem.SystemItem, _ handler: ((_ sender: Self) -> Void)? = nil) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        setActionHandler(handler)
    }
}
