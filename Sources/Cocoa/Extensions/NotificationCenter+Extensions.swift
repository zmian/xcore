//
// NotificationCenter+Extensions.swift
//
// Copyright © 2016 Xcore
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

extension NotificationCenter {
    /// Removes all entries specifying a given observer from the notification
    /// center's dispatch table.
    public static func remove(_ observers: [NSObjectProtocol?]) {
        observers.forEach {
            NotificationCenter.default.remove($0)
        }
    }

    /// Removes all entries specifying a given observer from the notification
    /// center's dispatch table.
    public static func remove(_ observer: NSObjectProtocol?) {
        NotificationCenter.default.remove(observer)
    }

    /// Removes all entries specifying a given observer from the notification
    /// center's dispatch table.
    public func remove(_ observer: NSObjectProtocol?) {
        guard let observer = observer else {
            return
        }

        removeObserver(observer)
    }

    /// Adds an entry to the notification center's dispatch table that includes a
    /// notification queue and a block to add to the queue, and an optional
    /// notification name and sender.
    ///
    /// - Parameters:
    ///   - name: The name of the notification for which to register the observer;
    ///     that is, only notifications with this name are used to add the block
    ///     to the operation queue.
    ///
    ///     If you pass `nil`, the notification center doesn’t use a
    ///     notification’s name to decide whether to add the block to the
    ///     operation queue.
    ///
    ///   - object: The object whose notifications the observer wants to receive;
    ///     that is, only notifications sent by this sender are delivered to the
    ///     the observer.
    ///
    ///     If you pass `nil`, the notification center doesn’t use a notification’s
    ///     sender to decide whether to deliver it to the observer.
    ///
    ///   - queue: The operation queue to which block should be added.
    ///
    ///     If you pass `nil`, the block is run synchronously on the posting thread.
    ///
    ///   - callback: The block to be executed when the notification is received.
    ///
    ///     The block is copied by the notification center and (the copy) held until
    ///     the observer registration is removed.
    /// - Returns: An opaque object to act as the observer.
    @discardableResult
    public func observe(
        _ name: Notification.Name,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        _ callback: @escaping (_ notification: Notification) -> Void
    ) -> NSObjectProtocol {
        return addObserver(forName: name, object: object, queue: queue, using: callback)
    }

    /// Adds an entry to the notification center's dispatch table that includes a
    /// notification queue and a block to add to the queue, and an optional
    /// notification name and sender.
    ///
    /// - Parameters:
    ///   - name: The name of the notification for which to register the observer;
    ///     that is, only notifications with this name are used to add the block
    ///     to the operation queue.
    ///
    ///     If you pass `nil`, the notification center doesn’t use a
    ///     notification’s name to decide whether to add the block to the
    ///     operation queue.
    ///
    ///   - object: The object whose notifications the observer wants to receive;
    ///     that is, only notifications sent by this sender are delivered to the
    ///     the observer.
    ///
    ///     If you pass `nil`, the notification center doesn’t use a notification’s
    ///     sender to decide whether to deliver it to the observer.
    ///
    ///   - queue: The operation queue to which block should be added.
    ///
    ///     If you pass `nil`, the block is run synchronously on the posting thread.
    ///
    ///   - callback: The block to be executed when the notification is received.
    ///
    ///     The block is copied by the notification center and (the copy) held until
    ///     the observer registration is removed.
    /// - Returns: An opaque object to act as the observer.
    @discardableResult
    public func observe(
        _ name: Notification.Name,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        _ callback: @escaping () -> Void
    ) -> NSObjectProtocol {
        return addObserver(forName: name, object: object, queue: queue) { _ in callback() }
    }

    /// Creates a notification with a given name and sender and posts it to the
    /// notification center.
    ///
    /// This is a convenience method for calling `post(name:object:userInfo:)` and
    /// passing `nil` to `aUserInfo`.
    ///
    /// - Parameters:
    ///   - name: The name of the notification.
    ///   - object: The object posting the notification.
    ///   - userInfo: Optional information about the notification.
    ///   - delayInterval: A delay interval before posting the notification. The
    ///                    default value is `0`.
    public static func post(
        _ name: Notification.Name,
        object: Any? = nil,
        userInfo: [AnyHashable: Any]? = nil,
        delayInterval: TimeInterval = 0
    ) {
        guard delayInterval > 0 else {
            NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
            return
        }

        delay(by: delayInterval) {
            NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
        }
    }
}

// MARK: - ON Namespace

extension NotificationCenter {
    final public class Event { }

    public static var on: Event {
        return Event()
    }
}

extension NotificationCenter.Event {
    @discardableResult
    public func observe(_ name: Notification.Name, object: Any? = nil, _ callback: @escaping (_ notification: Notification) -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.observe(name, object: object, callback)
    }

    @discardableResult
    public func observe(_ name: Notification.Name, object: Any? = nil, _ callback: @escaping () -> Void) -> NSObjectProtocol {
        return NotificationCenter.default.observe(name, object: object, callback)
    }

    // MARK: - UIApplication

    @discardableResult
    public func applicationDidFinishLaunching(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIApplication.didFinishLaunchingNotification, callback)
    }

    @discardableResult
    public func applicationWillEnterForeground(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIApplication.willEnterForegroundNotification, callback)
    }

    @discardableResult
    public func applicationDidEnterBackground(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIApplication.didEnterBackgroundNotification, callback)
    }

    @discardableResult
    public func applicationDidBecomeActive(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIApplication.didBecomeActiveNotification, callback)
    }

    @discardableResult
    public func applicationWillResignActive(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIApplication.willResignActiveNotification, callback)
    }

    @discardableResult
    public func applicationDidReceiveMemoryWarning(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIApplication.didReceiveMemoryWarningNotification, callback)
    }

    @discardableResult
    public func applicationWillTerminate(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIApplication.willTerminateNotification, callback)
    }

    // MARK: - UIWindow

    @discardableResult
    public func windowDidBecomeHidden(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIWindow.didBecomeHiddenNotification, callback)
    }

    @discardableResult
    public func windowDidBecomeVisible(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIWindow.didBecomeVisibleNotification, callback)
    }

    // MARK: - UIAccessibility

    @discardableResult
    public func accessibilityReduceTransparencyStatusDidChange(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIAccessibility.reduceTransparencyStatusDidChangeNotification, callback)
    }

    @discardableResult
    public func accessibilityVoiceOverStatusDidChange(_ callback: @escaping () -> Void) -> NSObjectProtocol {
        return observe(UIAccessibility.voiceOverStatusDidChangeNotification, callback)
    }

    // MARK: - UIContentSizeCategory

    /// Posted when the user changes the preferred content size setting.
    ///
    /// This notification is sent when the value in the
    /// `preferredContentSizeCategory` property changes. The block parameter
    /// contains the new new setting.
    @discardableResult
    public func contentSizeCategoryDidChange(_ callback: @escaping (_ newValue: UIContentSizeCategory) -> Void) -> NSObjectProtocol {
        return observe(UIContentSizeCategory.didChangeNotification) { (notification: Notification) in
            guard
                let userInfo = notification.userInfo,
                let rawValue = userInfo[UIContentSizeCategory.newValueUserInfoKey] as? String
            else {
                return
            }

            callback(UIContentSizeCategory(rawValue: rawValue))
        }
    }
}

// MARK: NotificationObject

public protocol NotificationObject {
    var name: Notification.Name { get }
    var object: Any? { get }
    var userInfo: [AnyHashable: Any]? { get }
}

extension NotificationObject {
    public var object: Any? {
        return nil
    }

    public var userInfo: [AnyHashable: Any]? {
        return nil
    }
}

extension NotificationCenter {
    public static func post(_ type: NotificationObject, delayInterval: TimeInterval = 0) {
        NotificationCenter.post(
            type.name,
            object: type.object,
            userInfo: type.userInfo,
            delayInterval: delayInterval
        )
    }
}

extension NotificationCenter.Event {
    @discardableResult
    public func observe(
        _ type: NotificationObject,
        _ callback: @escaping (_ notification: Notification) -> Void
    ) -> NSObjectProtocol {
        return NotificationCenter.default.observe(type.name, callback)
    }

    @discardableResult
    public func observe(
        _ type: NotificationObject,
        _ callback: @escaping () -> Void
    ) -> NSObjectProtocol {
        return NotificationCenter.default.observe(type.name, callback)
    }
}
