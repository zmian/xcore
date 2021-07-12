//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Namespace

public enum Handler {}

// MARK: - Completion

extension Handler {
    public class Completion {
        private let lifecycle = Lifecycle()

        public init() {}

        public func notifyShow() {
            lifecycle.notifyStart()
        }

        public func notifyHide() {
            lifecycle.notifyEnd()
        }

        @discardableResult
        public func onShow(_ callback: @escaping () -> Void) -> Self {
            lifecycle.onStart(callback)
            return self
        }

        @discardableResult
        public func onHide(_ callback: @escaping () -> Void) -> Self {
            lifecycle.onEnd(callback)
            return self
        }

        /// Forward completion events to given handler.
        ///
        /// - Parameter handler: The handler which should be notified.
        public func forward(to handler: Completion) {
            lifecycle.forward(to: handler.lifecycle)
        }
    }
}

// MARK: - Lifecycle

extension Handler {
    /// A handler that has a start and an end.
    public class Lifecycle {
        private var didNotifyStart = false
        private var didNotifyEnd = false
        private var start: (() -> Void)?
        private var end: (() -> Void)?

        public init() {}

        public func notifyStart() {
            didNotifyStart = true
            start?()
        }

        public func notifyEnd() {
            didNotifyEnd = true
            end?()
        }

        @discardableResult
        public func onStart(_ callback: @escaping () -> Void) -> Self {
            start = callback

            // If already called start then trigger the callback immediately. This can
            // happen if the start happens before the callback was attached.
            if didNotifyStart {
                callback()
            }

            return self
        }

        @discardableResult
        public func onEnd(_ callback: @escaping () -> Void) -> Self {
            end = callback

            // If already called end then trigger the callback immediately. This can happen
            // if the end happens before the callback was attached.
            if didNotifyEnd {
                callback()
            }

            return self
        }

        /// Forward lifecycle events to given handler.
        ///
        /// - Parameter handler: The handler which should be notified.
        public func forward(to handler: Lifecycle) {
            onStart {
                handler.notifyStart()
            }

            onEnd {
                handler.notifyEnd()
            }
        }
    }
}

// MARK: - Convenience

extension Handler.Lifecycle {
    /// Wraps the given `block` and invokes `notifyStart` method on the lifecycle
    /// handler.
    ///
    /// - Note: `onEnd` is never invoked.
    public static func wrap(_ block: () -> Void) -> Handler.Lifecycle {
        let handler = Handler.Lifecycle()
        block()
        handler.notifyStart()
        return handler
    }
}

extension Handler.Completion {
    /// Wraps the given `block` and invokes `notifyStart` method on the completion
    /// handler.
    ///
    /// - Note: `onHide` is never invoked.
    public static func wrap(_ block: () -> Void) -> Handler.Completion {
        let handler = Handler.Completion()
        block()
        handler.notifyShow()
        return handler
    }
}
