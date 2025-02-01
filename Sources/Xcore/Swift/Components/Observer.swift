//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A container for managing a list of observers, allowing objects to register
/// for notifications and be automatically cleaned up when they are deallocated.
///
/// **Usage**
///
/// ```swift
/// final class ViewModel {
///     private let observers = Observers()
///
///     var count = 0 {
///         didSet {
///             observers.notifyIfNeeded(oldValue, newValue: count)
///         }
///     }
///
///     /// Registers an observer for count changes.
///     func observeCountChanges(for owner: AnyObject, _ handler: @escaping () -> Void) {
///         observers.observe(for: owner, handler)
///     }
///
///     /// Simulates an update to the count value.
///     func incrementCount() {
///         count += 1
///     }
/// }
///
/// // MARK: - Usage Example
///
/// final class ViewController {
///     private let viewModel = ViewModel()
///
///     override func viewDidLoad() {
///         super.viewDidLoad()
///
///         // Register an observer for count changes.
///         viewModel.observeCountChanges(for: self) {
///             print("Count changed to \(self.viewModel.count)")
///         }
///
///         // Simulate updates
///         viewModel.incrementCount() // Output: "Count changed to 1"
///         viewModel.incrementCount() // Output: "Count changed to 2"
///     }
/// }
///
/// // MARK: - Run Example
///
/// let viewController = ViewController()
/// viewController.viewDidLoad() // Trigger the observer example
/// ```
open class Observers {
    /// A list of registered observers.
    private var observers = [Observer]()

    /// Initializes a new instance of `Observers`.
    public init() {
        // Must have a public init for client code to initialize this class.
    }

    // MARK: - Observer API

    /// Registers an observer with a notification handler.
    ///
    /// If the observer already exists, the handler is updated; otherwise, a new
    /// observer is added.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// observers.observe(for: self) {
    ///     print("Notified!")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - owner: The observing object.
    ///   - handler: A closure invoked when the observer is notified.
    open func observe<T>(for owner: T, _ handler: @escaping () -> Void) where T: AnyObject, T: Equatable {
        if let existingObserverIndex = observers.firstIndex(where: { $0 == owner }) {
            observers[existingObserverIndex].handler = handler
        } else {
            observers.append(Observer(owner: owner, handler: handler))
        }
    }

    /// Removes the given owner from the list of observers.
    ///
    /// - Parameter owner: The observing object to be removed.
    open func remove<T>(_ owner: T) where T: AnyObject, T: Equatable {
        guard let index = observers.firstIndex(where: { $0 == owner }) else {
            return
        }

        observers.remove(at: index)
    }

    /// Removes all observers from the list.
    open func removeAll() {
        observers.removeAll(keepingCapacity: false)
    }

    /// Cleans up observers where the `owner` has been deallocated.
    open func compacted() {
        for (index, observer) in observers.enumerated().reversed() where observer.owner == nil {
            observers.remove(at: index)
        }
    }

    /// The number of active observers.
    open var count: Int {
        compacted()
        return observers.count
    }

    /// A Boolean property indicating whether there are no active observers.
    open var isEmpty: Bool {
        compacted()
        return observers.isEmpty
    }

    // MARK: - Notify API

    /// A Boolean property indicating whether notifications should be sent.
    ///
    /// This flag is checked before notifying registered observers.
    open var isNotificationEnabled = true

    /// Notifies observers if `oldValue` is different from `newValue`.
    ///
    /// - Parameters:
    ///   - oldValue: The previous value.
    ///   - newValue: The new value to compare.
    open func notifyIfNeeded<T>(_ oldValue: T, newValue: T) where T: Equatable {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Notifies observers if `oldValue` is different from `newValue` (optional values).
    ///
    /// - Parameters:
    ///   - oldValue: The previous value.
    ///   - newValue: The new value to compare.
    open func notifyIfNeeded<T>(_ oldValue: T?, newValue: T?) where T: Equatable {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Notifies observers if `oldValue` is different from `newValue` (array values).
    ///
    /// - Parameters:
    ///   - oldValue: The previous array value.
    ///   - newValue: The new array value to compare.
    open func notifyIfNeeded<T>(_ oldValue: [T], newValue: [T]) where T: Equatable {
        guard oldValue != newValue else { return }
        notify()
    }

    /// Notifies all registered observers.
    open func notify() {
        compacted()
        guard isNotificationEnabled else { return }
        observers.forEach { $0.handler?() }
    }
}

// MARK: - Observer

/// Represents an individual observer.
private final class Observer {
    fileprivate let isEqual: (AnyObject) -> Bool
    weak var owner: AnyObject?
    var handler: (() -> Void)?

    /// Initializes an `Observer` with an owner and a notification handler.
    ///
    /// - Parameters:
    ///   - owner: The observing object.
    ///   - handler: The closure invoked when the observer is notified.
    init<T>(owner: T, handler: @escaping () -> Void) where T: AnyObject, T: Equatable {
        self.owner = owner
        self.handler = handler
        self.isEqual = { [weak owner] otherOwner in
            guard let owner else {
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

        return lhs.isEqual(rhsOwner)
    }

    static func == <T>(lhs: Observer, rhs: T) -> Bool where T: AnyObject, T: Equatable {
        lhs.isEqual(rhs)
    }
}
