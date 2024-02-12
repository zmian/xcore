//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

public protocol ControlTargetActionBlockRepresentable: AnyObject {
    associatedtype Sender

    /// Adds the action to a given event.
    ///
    /// - Note: Unlike `addTarget(_:action:for:)`, actions are uniqued based on the
    ///   given `event`, and subsequent actions with the same `event` replace
    ///   previously added actions.
    ///
    /// - Parameters:
    ///   - event: An event to add to `self`.
    ///   - handler: The block invoked whenever given event is triggered.
    func addAction(_ event: UIControl.Event, _ handler: @escaping (_ sender: Sender) -> Void)

    /// Stops the delivery of the given event from `self`.
    ///
    /// - Parameter event: An event to remove from `self`.
    func removeAction(_ event: UIControl.Event)
}

extension UIControl: ControlTargetActionBlockRepresentable {
    public typealias Sender = UIControl
}

extension ControlTargetActionBlockRepresentable where Self: UIControl {
    public func addAction(_ event: UIControl.Event, _ handler: @escaping (_ sender: Self) -> Void) {
        let uniqueId = UIAction.Identifier("\(event.rawValue)")

        let action = UIAction(identifier: uniqueId) {
            guard let sender = $0.sender as? Self else { return }
            handler(sender)
        }

        addAction(action, for: event)
    }

    public func removeAction(_ event: UIControl.Event) {
        let uniqueId = UIAction.Identifier("\(event.rawValue)")
        removeAction(identifiedBy: uniqueId, for: event)
    }
}

extension ControlTargetActionBlockRepresentable where Self: UIButton {
    /// Associates `.primaryActionTriggered` action method with the control.
    ///
    /// - Parameter handler: The block invoked whenever `.primaryActionTriggered`
    ///   event is triggered.
    public func action(_ handler: ((_ sender: Self) -> Void)?) {
        guard let handler else {
            removeAction(.primaryActionTriggered)
            return
        }

        addAction(.primaryActionTriggered, handler)
    }
}
