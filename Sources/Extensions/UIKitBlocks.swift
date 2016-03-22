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

private class ClosureWrapper: NSObject {
    private var closure: (() -> Void)?

    init(_ closure: () -> Void) {
        self.closure = closure
    }

    @objc private func invoke(sender: AnyObject) {
        closure?()
    }
}

private extension UIBarButtonItem {
    struct AssociatedKey {
        static var ActionHandler = "Xcore_ActionHandler"
    }

    var actionHandler: ClosureWrapper? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.ActionHandler) as? ClosureWrapper }
        set { objc_setAssociatedObject(self, &AssociatedKey.ActionHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setActionHandler(handler: (() -> Void)?) {
        if let handler = handler {
            let wrapper   = ClosureWrapper(handler)
            actionHandler = wrapper
            target        = wrapper
            action        = #selector(wrapper.invoke(_:))
        } else {
            actionHandler = nil
            target        = nil
            action        = nil
        }
    }
}

// MARK: UIBarButtonItem Block-based Interface

public extension UIBarButtonItem {
    /// Add action handler when the item is selected.
    ///
    /// - parameter handler: The block to invoke when the item is selected.
    public func addAction(handler: () -> Void) {
        setActionHandler(handler)
    }

    /// Removes action handler from `self`.
    public func removeAction() {
        setActionHandler(nil)
    }

    /// A boolean value to determine whether an action handler is attached.
    public var hasActionHandler: Bool {
        return target != nil
    }

    public convenience init(image: UIImage?, landscapeImagePhone: UIImage? = nil, style: UIBarButtonItemStyle = .Plain, handler: (() -> Void)? = nil) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        setActionHandler(handler)
    }

    public convenience init(title: String?, style: UIBarButtonItemStyle = .Plain, handler: (() -> Void)? = nil) {
        self.init(title: title, style: style, target: nil, action: nil)
        setActionHandler(handler)
    }

    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, handler: (() -> Void)? = nil) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        setActionHandler(handler)
    }
}

// MARK: UIControl Block-based Interface

private class ControlClosureWrapper: NSObject, NSCopying {
    var closure: ((sender: AnyObject) -> Void)?
    var events: UIControlEvents

    init(events: UIControlEvents, closure: ((sender: AnyObject) -> Void)?) {
        self.closure = closure
        self.events  = events
    }

    @objc func copyWithZone(zone: NSZone) -> AnyObject {
        return ControlClosureWrapper(events: events, closure: closure)
    }

    @objc private func invoke(sender: AnyObject) {
        closure?(sender: sender)
    }
}

extension UIControl: UIControlEventsBlockRepresentable {
    private struct AssociatedKey {
        static var ActionHandler = "Xcore_ActionHandler"
    }

    private var actionEvents: [UInt: ControlClosureWrapper]? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.ActionHandler) as? [UInt: ControlClosureWrapper] }
        set { objc_setAssociatedObject(self, &AssociatedKey.ActionHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public protocol UIControlEventsBlockRepresentable {
    func addAction(events: UIControlEvents, handler: (sender: Self) -> Void)
    func removeAction(events: UIControlEvents)
}

extension UIControlEventsBlockRepresentable where Self: UIControl {
    public func addAction(events: UIControlEvents, handler: (sender: Self) -> Void) {
        var actionEvents = self.actionEvents ?? [:]
        let wrapper      = actionEvents[events.rawValue] ?? ControlClosureWrapper(events: events, closure: nil)

        wrapper.closure = { sender in
            if let sender = sender as? Self {
                handler(sender: sender)
            }
        }

        actionEvents[events.rawValue] = wrapper
        self.actionEvents = actionEvents
        addTarget(wrapper, action: #selector(wrapper.invoke(_:)), forControlEvents: events)
    }

    public func removeAction(events: UIControlEvents) {
        guard let actionEvents = actionEvents, wrapper = actionEvents[events.rawValue] else { return }
        removeTarget(wrapper, action: nil, forControlEvents: events)
        self.actionEvents?.removeValueForKey(events.rawValue)
    }
}

import MessageUI

private class MailClosureWrapper: NSObject {
    var closure: ((controller: MFMailComposeViewController, result: MFMailComposeResult, error: NSError?) -> Void)?

    init(_ closure: ((controller: MFMailComposeViewController, result: MFMailComposeResult, error: NSError?) -> Void)?) {
        self.closure = closure
    }
}

extension MFMailComposeViewController: MFMailComposeViewControllerDelegate {
    private struct AssociatedKey {
        static var ActionHandler     = "Xcore_ActionHandler"
        static var ShouldAutoDismiss = "Xcore_ShouldAutoDismiss"
    }

    private var actionHandlerWrapper: MailClosureWrapper? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.ActionHandler) as? MailClosureWrapper }
        set { objc_setAssociatedObject(self, &AssociatedKey.ActionHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public var shouldAutoDismiss: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.ShouldAutoDismiss) as? Bool ?? false }
        set {
            mailComposeDelegate = self
            objc_setAssociatedObject(self, &AssociatedKey.ShouldAutoDismiss, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        if let actionHandler = actionHandlerWrapper?.closure {
            actionHandler(controller: controller, result: result, error: error)
        }

        if shouldAutoDismiss {
            controller.dismissViewControllerAnimated(true, completion: nil)
        }
    }

    public func didFinishWithResult(handler: (controller: MFMailComposeViewController, result: MFMailComposeResult, error: NSError?) -> Void) {
        mailComposeDelegate  = self
        actionHandlerWrapper = MailClosureWrapper(handler)
    }
}

// MARK: Gestures

private extension UIGestureRecognizer {
    struct AssociatedKey {
        static var ActionHandler = "Xcore_ActionHandler"
    }

    var actionHandler: ClosureWrapper? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.ActionHandler) as? ClosureWrapper }
        set { objc_setAssociatedObject(self, &AssociatedKey.ActionHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setActionHandler(handler: (() -> Void)?) {
        if let handler = handler {
            let wrapper   = ClosureWrapper(handler)
            actionHandler = wrapper
            addTarget(wrapper, action: #selector(wrapper.invoke(_:)))
        } else {
            actionHandler = nil
            removeTarget(nil, action: nil)
        }
    }
}

// MARK: UIGestureRecognizer Block-based Interface

public extension UIGestureRecognizer {
    public convenience init(handler: () -> Void) {
        self.init()
        setActionHandler(handler)
    }

    /// Add action handler when the item is selected.
    ///
    /// - parameter handler: The block to invoke when the item is selected.
    public func addAction(handler: () -> Void) {
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
}
