//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension UIGestureRecognizer: TargetActionBlockRepresentable {
    public typealias Sender = UIGestureRecognizer

    private enum AssociatedKey {
        static var actionHandler = "actionHandler"
    }

    fileprivate var actionHandler: SenderClosureWrapper? {
        get { associatedObject(&AssociatedKey.actionHandler) }
        set { setAssociatedObject(&AssociatedKey.actionHandler, value: newValue) }
    }
}

extension TargetActionBlockRepresentable where Self: UIGestureRecognizer {
    private func setActionHandler(_ handler: ((_ sender: Self) -> Void)?) {
        guard let handler = handler else {
            actionHandler = nil
            removeTarget(nil, action: nil)
            return
        }

        let wrapper = SenderClosureWrapper(nil)

        wrapper.closure = { sender in
            guard let sender = sender as? Self else { return }
            handler(sender)
        }

        actionHandler = wrapper
        addTarget(wrapper, action: #selector(wrapper.invoke(_:)))
    }

    /// Add action handler when the item is selected.
    ///
    /// - Parameter action: The block to invoke when the item is selected.
    public func addAction(_ action: @escaping (_ sender: Self) -> Void) {
        setActionHandler(action)
    }

    /// Removes action handler from `self`.
    public func removeAction() {
        setActionHandler(nil)
    }

    /// A boolean value to determine whether an action handler is attached.
    public var hasActionHandler: Bool {
        actionHandler != nil
    }

    public init(_ handler: @escaping (_ sender: Self) -> Void) {
        self.init()
        setActionHandler(handler)
    }
}
