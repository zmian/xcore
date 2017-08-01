//
// Observer.swift
//
// Copyright © 2017 Zeeshan Mian
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

/// A generic class to hold a weak reference to a type `T`.
/// This is useful for holding a reference to nullable object.
///
/// ```swift
/// let views = [Weak<UIView>]()
/// ```
open class Weak<T: AnyObject>: Equatable {
    open weak var value: T?

    public init (value: T) {
        self.value = value
    }

    open static func ==<T>(lhs: Weak<T>, rhs: Weak<T>) -> Bool {
        return lhs.value === rhs.value
    }
}

public struct Observer<T: AnyObject> {
    public weak var owner: T?
    public var handler: (() -> Void)?

    public init(owner: T, handler: @escaping () -> Void) {
        self.owner = owner
        self.handler = handler
    }
}

open class Observers<T: AnyObject> {
    /// A list of all observers.
    open var observers = [Observer<T>]()

    public init() {
        // Must have a public init for client code to initialize this class.
    }

    // MARK: Observer API

    /// Register an observer.
    open func observe(owner: T, _ handler: @escaping () -> Void) {
        observers.append(Observer(owner: owner, handler: handler))
    }

    /// Remove all observers.
    open func removeObservers() {
        observers.removeAll(keepingCapacity: false)
    }

    /// Removes all observers where the `owner` is deallocated.
    open func flatten() {
        for (index, observer) in observers.enumerated().reversed() {
            if observer.owner == nil {
                observers.remove(at: index)
            }
        }
    }

    // MARK: Notify API

    /// Invokes each registered observer if `oldValue` is different than `newValue`.
    open func notifyIfNeeded<T: Equatable>(_ oldValue: T, newValue: T) {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Invokes each registered observer if `oldValue` is different than `newValue`.
    open func notifyIfNeeded<T: Equatable>(_ oldValue: T?, newValue: T?) {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Invokes each registered observer if `oldValue` is different than `newValue`.
    open func notifyIfNeeded<T: Equatable>(_ oldValue: [T], newValue: [T]) {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Invokes each registered observer.
    open func notify() {
        flatten()
        observers.forEach { $0.handler?() }
    }
}
