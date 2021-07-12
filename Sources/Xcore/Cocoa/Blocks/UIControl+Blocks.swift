//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

private class ControlClosureWrapper: NSObject, NSCopying {
    var closure: ((_ sender: AnyObject) -> Void)?
    var event: UIControl.Event

    init(event: UIControl.Event, closure: ((_ sender: AnyObject) -> Void)?) {
        self.closure = closure
        self.event = event
    }

    @objc
    func copy(with zone: NSZone?) -> Any {
        ControlClosureWrapper(event: event, closure: closure)
    }

    @objc
    func invoke(_ sender: AnyObject) {
        closure?(sender)
    }
}

extension UIControl: ControlTargetActionBlockRepresentable {
    public typealias Sender = UIControl

    private enum AssociatedKey {
        static var actionHandler = "actionHandler"
    }

    fileprivate var actionEvent: [UInt: ControlClosureWrapper]? {
        get { associatedObject(&AssociatedKey.actionHandler) }
        set { setAssociatedObject(&AssociatedKey.actionHandler, value: newValue) }
    }
}

public protocol ControlTargetActionBlockRepresentable: AnyObject {
    associatedtype Sender
    func addAction(_ event: UIControl.Event, _ handler: @escaping (_ sender: Sender) -> Void)
    func removeAction(_ event: UIControl.Event)
}

extension ControlTargetActionBlockRepresentable where Self: UIControl {
    /// Associates an action method with the control.
    ///
    /// - Note: Unlike `addTarget(_:action:for:)`, calling this method with same
    ///   event will override the existing `handler`.
    ///
    /// - Parameters:
    ///   - event: An event to add to `self`.
    ///   - handler: The block invoked whenever given event is triggered.
    public func addAction(_ event: UIControl.Event, _ handler: @escaping (_ sender: Self) -> Void) {
        var actionEvent = self.actionEvent ?? [:]
        let wrapper = actionEvent[event.rawValue] ?? ControlClosureWrapper(event: event, closure: nil)

        wrapper.closure = { sender in
            guard let sender = sender as? Self else { return }
            handler(sender)
        }

        actionEvent[event.rawValue] = wrapper
        self.actionEvent = actionEvent
        addTarget(wrapper, action: #selector(wrapper.invoke(_:)), for: event)
    }

    /// Stops the delivery of the given event from `self`.
    ///
    /// - Parameter event: An event to remove from `self`.
    public func removeAction(_ event: UIControl.Event) {
        guard let actionEvent = actionEvent, let wrapper = actionEvent[event.rawValue] else { return }
        removeTarget(wrapper, action: nil, for: event)
        _ = self.actionEvent?.removeValue(forKey: event.rawValue)
    }
}

extension ControlTargetActionBlockRepresentable where Self: UIButton {
    /// Associates `.touchUpInside` action method with the control.
    ///
    /// - Parameter handler: The block invoked whenever `.touchUpInside` event is
    ///   triggered.
    public func action(_ handler: ((_ sender: Self) -> Void)?) {
        guard let handler = handler else {
            removeAction(.touchUpInside)
            return
        }

        addAction(.touchUpInside, handler)
    }
}
