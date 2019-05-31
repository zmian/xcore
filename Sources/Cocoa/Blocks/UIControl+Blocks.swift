//
// UIControl+Blocks.swift
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

private class ControlClosureWrapper: NSObject, NSCopying {
    var closure: ((_ sender: AnyObject) -> Void)?
    var event: UIControl.Event

    init(event: UIControl.Event, closure: ((_ sender: AnyObject) -> Void)?) {
        self.closure = closure
        self.event = event
    }

    @objc func copy(with zone: NSZone?) -> Any {
        return ControlClosureWrapper(event: event, closure: closure)
    }

    @objc func invoke(_ sender: AnyObject) {
        closure?(sender)
    }
}

extension UIControl: ControlTargetActionBlockRepresentable {
    public typealias Sender = UIControl

    private struct AssociatedKey {
        static var actionHandler = "actionHandler"
    }

    fileprivate var actionEvent: [UInt: ControlClosureWrapper]? {
        get { return associatedObject(&AssociatedKey.actionHandler) }
        set { setAssociatedObject(&AssociatedKey.actionHandler, value: newValue) }
    }
}

public protocol ControlTargetActionBlockRepresentable: class {
    associatedtype Sender
    func addAction(_ event: UIControl.Event, _ handler: @escaping (_ sender: Sender) -> Void)
    func removeAction(_ event: UIControl.Event)
}

extension ControlTargetActionBlockRepresentable where Self: UIControl {
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

    public func removeAction(_ event: UIControl.Event) {
        guard let actionEvent = actionEvent, let wrapper = actionEvent[event.rawValue] else { return }
        removeTarget(wrapper, action: nil, for: event)
        _ = self.actionEvent?.removeValue(forKey: event.rawValue)
    }
}
