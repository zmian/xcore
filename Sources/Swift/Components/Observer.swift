//
// Observer.swift
//
// Copyright © 2017 Xcore
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

open class Observers {
    /// A list of all observers.
    private var observers = [Observer]()

    public init() {
        // Must have a public init for client code to initialize this class.
    }

    // MARK: Observer API

    /// Register an observer.
    open func observe<T>(owner: T, _ handler: @escaping () -> Void) where T: AnyObject, T: Equatable {
        if let existingObserverIndex = observers.firstIndex(where: { $0 == owner }) {
            observers[existingObserverIndex].handler = handler
        } else {
            observers.append(Observer(owner: owner, handler: handler))
        }
    }

    /// Remove given observers.
    open func remove<T>(_ owner: T) where T: AnyObject, T: Equatable {
        guard let index = observers.firstIndex(where: { $0 == owner }) else {
            return
        }

        observers.remove(at: index)
    }

    /// Remove all observers.
    open func removeAll() {
        observers.removeAll(keepingCapacity: false)
    }

    /// Removes all observers where the `owner` is deallocated.
    open func flatten() {
        for (index, observer) in observers.enumerated().reversed() where observer.owner == nil {
            observers.remove(at: index)
        }
    }

    open var count: Int {
        flatten()
        return observers.count
    }

    open var isEmpty: Bool {
        flatten()
        return observers.isEmpty
    }

    // MARK: Notify API

    /// A boolean value to determine whether the notifications should be sent.
    /// This flag is checked before firing any notification calls to the registered
    /// observers. The default value is `true`.
    open var isNotificationEnabled = true

    /// Invokes each registered observer if `oldValue` is different than `newValue`.
    open func notifyIfNeeded<T>(_ oldValue: T, newValue: T) where T: Equatable {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Invokes each registered observer if `oldValue` is different than `newValue`.
    open func notifyIfNeeded<T>(_ oldValue: T?, newValue: T?) where T: Equatable {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Invokes each registered observer if `oldValue` is different than `newValue`.
    open func notifyIfNeeded<T>(_ oldValue: [T], newValue: [T]) where T: Equatable {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Invokes each registered observer.
    open func notify() {
        flatten()
        guard isNotificationEnabled else { return }
        observers.forEach { $0.handler?() }
    }
}

// MARK: Observer

private final class Observer {
    fileprivate let equals: (AnyObject) -> Bool
    public weak var owner: AnyObject?
    public var handler: (() -> Void)?

    public init<T>(owner: T, handler: @escaping () -> Void) where T: AnyObject, T: Equatable {
        self.owner = owner
        self.handler = handler
        self.equals = { [weak owner] otherOwner in
            guard let owner = owner else {
                return false
            }

            return otherOwner as? T == owner
        }
    }
}

// MARK: Observer: Equatable

extension Observer: Equatable {
    static func ==(lhs: Observer, rhs: Observer) -> Bool {
        guard lhs.owner != nil, let rhsOwner = rhs.owner else {
            return false
        }

        return lhs.equals(rhsOwner)
    }

    static func ==<T>(lhs: T, rhs: Observer) -> Bool where T: AnyObject, T: Equatable {
        return rhs.equals(lhs)
    }

    static func ==<T>(lhs: Observer, rhs: T) -> Bool where T: AnyObject, T: Equatable {
        return lhs.equals(rhs)
    }

    static func ==<T>(lhs: T?, rhs: Observer) -> Bool where T: AnyObject, T: Equatable {
        guard let lhs = lhs else {
            return false
        }

        return rhs.equals(lhs)
    }
}

private func ==<T>(lhs: Observer?, rhs: T) -> Bool where T: AnyObject, T: Equatable {
    guard let lhs = lhs else {
        return false
    }

    return lhs.equals(rhs)
}
