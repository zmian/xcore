//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

open class Observers {
    /// A list of all observers.
    private var observers = [Observer]()

    public init() {
        // Must have a public init for client code to initialize this class.
    }

    // MARK: - Observer API

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

    // MARK: - Notify API

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

// MARK: - Observer

private final class Observer {
    fileprivate let equals: (AnyObject) -> Bool
    weak var owner: AnyObject?
    var handler: (() -> Void)?

    init<T>(owner: T, handler: @escaping () -> Void) where T: AnyObject, T: Equatable {
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

// MARK: - Observer: Equatable

extension Observer: Equatable {
    static func ==(lhs: Observer, rhs: Observer) -> Bool {
        guard lhs.owner != nil, let rhsOwner = rhs.owner else {
            return false
        }

        return lhs.equals(rhsOwner)
    }

    static func == <T>(lhs: T, rhs: Observer) -> Bool where T: AnyObject, T: Equatable {
        rhs.equals(lhs)
    }

    static func == <T>(lhs: Observer, rhs: T) -> Bool where T: AnyObject, T: Equatable {
        lhs.equals(rhs)
    }

    static func == <T>(lhs: T?, rhs: Observer) -> Bool where T: AnyObject, T: Equatable {
        guard let lhs = lhs else {
            return false
        }

        return rhs.equals(lhs)
    }
}

private func == <T>(lhs: Observer?, rhs: T) -> Bool where T: AnyObject, T: Equatable {
    guard let lhs = lhs else {
        return false
    }

    return lhs.equals(rhs)
}
