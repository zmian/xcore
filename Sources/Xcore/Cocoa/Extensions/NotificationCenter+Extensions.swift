//
// Xcore
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension NotificationCenter {
    /// Returns an asynchronous sequence of notifications produced by default center
    /// for a given notification name and optional source object.
    ///
    /// The following iOS example iterates over an asynchronous sequence of
    /// ``orientationDidChangeNotification`` notifications. It uses the
    /// ``AsyncSequence`` method ``filter(_:)`` to only receive notifications when
    /// the device rotates into the upright portrait orientation.
    ///
    /// ``` swift
    /// UIDevice.current.beginGeneratingDeviceOrientationNotifications()
    ///
    /// let notifications = await NotificationCenter
    ///     .async(UIDevice.orientationDidChangeNotification)
    ///     .filter { _ in
    ///         UIDevice.current.orientation == .portrait
    ///     }
    ///
    /// for await notification in notifications {
    ///     print("Device is now in portrait orientation.")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - name: A notfiication name. The sequence includes only notifications with
    ///     this name.
    ///   - object: A source object of notifications. Specify a sender object to
    ///     deliver only notifications from that sender. When `nil`, the
    ///     notification center doesn’t consider the sender as a criteria for
    ///     delivery.
    /// - Returns: An asynchronous sequence of notifications from the center.
    @available(macOS 12, iOS 15, tvOS 15, watchOS 8, *)
    public static func async(_ name: Notification.Name, object: AnyObject? = nil) -> Notifications {
        shared.notifications(named: name, object: object)
    }
}

extension NotificationCenter {
    /// Adds an entry to the notification center's dispatch table that includes a
    /// notification queue and a closure to add to the queue, and an optional
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
    ///   - object: The object whose notifications the observer wants to receive;
    ///     that is, only notifications sent by this sender are delivered to the
    ///     the observer.
    ///
    ///     If you pass `nil`, the notification center doesn’t use a notification’s
    ///     sender to decide whether to deliver it to the observer.
    ///   - queue: The operation queue to which block should be added.
    ///
    ///     If you pass `nil`, the block is run synchronously on the posting thread.
    ///   - callback: The block to be executed when the notification is received.
    ///
    ///     The block is copied by the notification center and (the copy) held until
    ///     the observer registration is removed.
    /// - Returns: An opaque object to act as the observer.
    @discardableResult
    public static func observe(
        _ name: Notification.Name,
        object: Any? = nil,
        queue: OperationQueue? = nil,
        _ callback: @escaping (_ notification: Notification) -> Void
    ) -> NSObjectProtocol {
        shared.addObserver(forName: name, object: object, queue: queue, using: callback)
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
    ///     default value is `0`.
    public static func post(
        _ name: Notification.Name,
        object: Any? = nil,
        userInfo: [AnyHashable: Any]? = nil,
        delayInterval: TimeInterval = 0
    ) {
        Task {
            if delayInterval > 0 {
                try await Task.sleep(for: .seconds(delayInterval))
            }
            shared.post(name: name, object: object, userInfo: userInfo)
        }
    }
}

// MARK: - Remove

extension NotificationCenter {
    /// Removes all entries specifying a given observer from the notification
    /// center's dispatch table.
    public static func remove(_ observers: [NSObjectProtocol?]) {
        observers.forEach {
            shared.remove($0)
        }
    }

    /// Removes all entries specifying a given observer from the notification
    /// center's dispatch table.
    public static func remove(_ observer: NSObjectProtocol?) {
        shared.remove(observer)
    }

    /// Removes all entries specifying a given observer from the notification
    /// center's dispatch table.
    public func remove(_ observer: NSObjectProtocol?) {
        guard let observer else {
            return
        }

        removeObserver(observer)
    }

    private static var shared: NotificationCenter {
        .default
    }
}
