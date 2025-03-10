//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(UIKit)
import UIKit

extension UIGestureRecognizer: TargetActionBlockRepresentable {
    public typealias Sender = UIGestureRecognizer

    private enum AssociatedKey {
        nonisolated(unsafe) static var actionHandler = "actionHandler"
    }

    fileprivate var actionHandler: SenderClosureWrapper? {
        get { associatedObject(&AssociatedKey.actionHandler) }
        set { setAssociatedObject(&AssociatedKey.actionHandler, value: newValue) }
    }
}

extension TargetActionBlockRepresentable where Self: UIGestureRecognizer {
    public init(_ handler: @escaping (_ sender: Self) -> Void) {
        self.init()
        setActionHandler(handler)
    }

    public func addAction(_ action: @escaping (_ sender: Self) -> Void) {
        setActionHandler(action)
    }

    public func removeAction() {
        setActionHandler(nil)
    }

    /// A Boolean property indicating whether an action handler is attached.
    public var hasActionHandler: Bool {
        actionHandler != nil
    }

    private func setActionHandler(_ handler: ((_ sender: Self) -> Void)?) {
        guard let handler else {
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
}
#endif
