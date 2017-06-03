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
    fileprivate var closure: (() -> Void)?

    init(_ closure: @escaping () -> Void) {
        self.closure = closure
    }

    @objc fileprivate func invoke(_ sender: AnyObject) {
        closure?()
    }
}

private extension UIBarButtonItem {
    struct AssociatedKey {
        static var actionHandler = "XcoreActionHandler"
    }

    var actionHandler: ClosureWrapper? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.actionHandler) as? ClosureWrapper }
        set { objc_setAssociatedObject(self, &AssociatedKey.actionHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setActionHandler(_ handler: (() -> Void)?) {
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

extension UIBarButtonItem {
    /// Add action handler when the item is selected.
    ///
    /// - parameter handler: The block to invoke when the item is selected.
    public func addAction(_ handler: @escaping () -> Void) {
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

    public convenience init(image: UIImage?, landscapeImagePhone: UIImage? = nil, style: UIBarButtonItemStyle = .plain, handler: (() -> Void)? = nil) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        setActionHandler(handler)
    }

    public convenience init(title: String?, style: UIBarButtonItemStyle = .plain, handler: (() -> Void)? = nil) {
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
    var closure: ((_ sender: AnyObject) -> Void)?
    var events: UIControlEvents

    init(events: UIControlEvents, closure: ((_ sender: AnyObject) -> Void)?) {
        self.closure = closure
        self.events  = events
    }

    @objc func copy(with zone: NSZone?) -> Any {
        return ControlClosureWrapper(events: events, closure: closure)
    }

    @objc fileprivate func invoke(_ sender: AnyObject) {
        closure?(sender)
    }
}

extension UIControl: XCUIControlEventsBlockRepresentable {
    public typealias SenderType = UIControl

    fileprivate struct AssociatedKey {
        static var actionHandler = "XcoreActionHandler"
    }

    fileprivate var actionEvents: [UInt: ControlClosureWrapper]? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.actionHandler) as? [UInt: ControlClosureWrapper] }
        set { objc_setAssociatedObject(self, &AssociatedKey.actionHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }
}

public protocol XCUIControlEventsBlockRepresentable {
    associatedtype SenderType

    func addAction(_ events: UIControlEvents, _ handler: @escaping (_ sender: SenderType) -> Void)
    func removeAction(_ events: UIControlEvents)
}

extension XCUIControlEventsBlockRepresentable where Self: UIControl {
    public func addAction(_ events: UIControlEvents, _ handler: @escaping (_ sender: Self) -> Void) {
        var actionEvents = self.actionEvents ?? [:]
        let wrapper      = actionEvents[events.rawValue] ?? ControlClosureWrapper(events: events, closure: nil)

        wrapper.closure = { sender in
            if let sender = sender as? Self {
                handler(sender)
            }
        }

        actionEvents[events.rawValue] = wrapper
        self.actionEvents = actionEvents
        addTarget(wrapper, action: #selector(wrapper.invoke(_:)), for: events)
    }

    public func removeAction(_ events: UIControlEvents) {
        guard let actionEvents = actionEvents, let wrapper = actionEvents[events.rawValue] else { return }
        removeTarget(wrapper, action: nil, for: events)
        let _ = self.actionEvents?.removeValue(forKey: events.rawValue)
    }
}

import MessageUI

private class MailClosureWrapper: NSObject {
    var closure: ((_ controller: MFMailComposeViewController, _ result: MFMailComposeResult, _ error: Error?) -> Void)?

    init(_ closure: ((_ controller: MFMailComposeViewController, _ result: MFMailComposeResult, _ error: Error?) -> Void)?) {
        self.closure = closure
    }
}

extension MFMailComposeViewController: MFMailComposeViewControllerDelegate {
    fileprivate struct AssociatedKey {
        static var actionHandler     = "XcoreActionHandler"
        static var shouldAutoDismiss = "XcoreShouldAutoDismiss"
    }

    fileprivate var actionHandlerWrapper: MailClosureWrapper? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.actionHandler) as? MailClosureWrapper }
        set { objc_setAssociatedObject(self, &AssociatedKey.actionHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public var shouldAutoDismiss: Bool {
        get { return objc_getAssociatedObject(self, &AssociatedKey.shouldAutoDismiss) as? Bool ?? false }
        set {
            mailComposeDelegate = self
            objc_setAssociatedObject(self, &AssociatedKey.shouldAutoDismiss, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }

    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let actionHandler = actionHandlerWrapper?.closure {
            actionHandler(controller, result, error)
        }

        if shouldAutoDismiss {
            controller.dismiss(animated: true)
        }
    }

    public func didFinishWithResult(_ handler: @escaping (_ controller: MFMailComposeViewController, _ result: MFMailComposeResult, _ error: Error?) -> Void) {
        mailComposeDelegate  = self
        actionHandlerWrapper = MailClosureWrapper(handler)
    }
}

// MARK: Gestures

private extension UIGestureRecognizer {
    struct AssociatedKey {
        static var actionHandler = "XcoreActionHandler"
    }

    var actionHandler: ClosureWrapper? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.actionHandler) as? ClosureWrapper }
        set { objc_setAssociatedObject(self, &AssociatedKey.actionHandler, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func setActionHandler(_ handler: (() -> Void)?) {
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

extension UIGestureRecognizer {
    public convenience init(_ handler: @escaping () -> Void) {
        self.init()
        setActionHandler(handler)
    }

    /// Add action handler when the item is selected.
    ///
    /// - parameter handler: The block to invoke when the item is selected.
    public func addAction(_ handler: @escaping () -> Void) {
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
