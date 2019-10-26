//
// AdaptiveURL.swift
//
// Copyright © 2019 Xcore
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

import Foundation

// MARK: - Namespace

public enum Handler { }

// MARK: - Completion

extension Handler {
    public class Completion {
        private let lifecycle = Lifecycle()

        public init() { }

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
        public func onHide(_ callback: @escaping () -> Void) -> Self  {
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

        public init() { }

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

            // If already called start then trigger the callback immediately. This can happen
            // if the start happens before the callback was attached.
            if didNotifyStart {
                callback()
            }

            return self
        }

        @discardableResult
        public func onEnd(_ callback: @escaping () -> Void) -> Self  {
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
