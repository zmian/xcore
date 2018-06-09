//
// DebounceThrottle.swift
// Simon Ljungberg
// License: MIT
//

import Foundation

extension TimeInterval {
    /// Checks if `since` has passed since `self`.
    ///
    /// - Parameter since: The duration of time that needs to have passed for this function to return `true`.
    /// - Returns: `true` if `since` has passed since now.
    fileprivate func hasPassed(since: TimeInterval) -> Bool {
        return Date().timeIntervalSinceReferenceDate - self > since
    }
}

// MARK: Debounce

/// Wraps a function in a new function that will only execute the wrapped
/// function if `delay` has passed without this function being called.
///
/// - Parameters:
///   - delay: A `DispatchTimeInterval` to wait before executing the wrapped function after last invocation.
///   - queue: The queue to perform the action on. The defaults value is `.main`.
///   - action: A function to debounce. Can't accept any arguments.
/// - Returns: A new function that will only call `action` if `delay` time passes between invocations.
public func debounce(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
    var currentWorkItem: DispatchWorkItem?

    return {
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { action() }
        queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}

/// Wraps a function in a new function that will only execute the wrapped function if `delay` has passed without this function being called.
///
/// Accepts an `action` with one argument.
///
/// - Parameters:
///   - delay: A `DispatchTimeInterval` to wait before executing the wrapped function after last invocation.
///   - queue: The queue to perform the action on. The defaults value is `.main`.
///   - action: A function to debounce. Can accept one argument.
/// - Returns: A new function that will only call `action` if `delay` time passes between invocations.
public func debounce<T>(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping ((T) -> Void)) -> (T) -> Void {
    var currentWorkItem: DispatchWorkItem?
    return { (p1: T) in
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { action(p1) }
        queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}

/// Wraps a function in a new function that will only execute the wrapped function if `delay` has passed without this function being called.
///
/// Accepts an `action` with two arguments.
///
/// - Parameters:
///   - delay: A `DispatchTimeInterval` to wait before executing the wrapped function after last invocation.
///   - queue: The queue to perform the action on. The defaults value is `.main`.
///   - action: A function to debounce. Can accept two arguments.
/// - Returns: A new function that will only call `action` if `delay` time passes between invocations.
public func debounce<T, U>(delay: DispatchTimeInterval, queue: DispatchQueue = .main, action: @escaping ((T, U) -> Void)) -> (T, U) -> Void {
    var currentWorkItem: DispatchWorkItem?
    return { (p1: T, p2: U) in
        currentWorkItem?.cancel()
        currentWorkItem = DispatchWorkItem { action(p1, p2) }
        queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}

// MARK: Throttle

/// Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
///
/// - Parameters:
///   - delay: A `TimeInterval` specifying the number of seconds that needs to pass between each execution of `action`.
///   - queue: The queue to perform the action on. The defaults value is `.main`.
///   - action: A function to throttle.
/// - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
public func throttle(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping (() -> Void)) -> () -> Void {
    var currentWorkItem: DispatchWorkItem?
    var lastFire: TimeInterval = 0
    return {
        guard currentWorkItem == nil else { return }
        currentWorkItem = DispatchWorkItem {
            action()
            lastFire = Date().timeIntervalSinceReferenceDate
            currentWorkItem = nil
        }
        delay.hasPassed(since: lastFire) ? queue.async(execute: currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}

/// Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
///
/// Accepts an `action` with one argument.
///
/// - Parameters:
///   - delay: A `TimeInterval` specifying the number of seconds that needs to pass between each execution of `action`.
///   - queue: The queue to perform the action on. The defaults value is `.main`.
///   - action: A function to throttle. Can accept one argument.
/// - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
public func throttle<T>(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping ((T) -> Void)) -> (T) -> Void {
    var currentWorkItem: DispatchWorkItem?
    var lastFire: TimeInterval = 0
    return { (p1: T) in
        guard currentWorkItem == nil else { return }
        currentWorkItem = DispatchWorkItem {
            action(p1)
            lastFire = Date().timeIntervalSinceReferenceDate
            currentWorkItem = nil
        }
        delay.hasPassed(since: lastFire) ? queue.async(execute: currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}

/// Wraps a function in a new function that will throttle the execution to once in every `delay` seconds.
///
/// Accepts an `action` with two arguments.
///
/// - Parameters:
///   - delay: A `TimeInterval` specifying the number of seconds that needs to pass between each execution of `action`.
///   - queue: The queue to perform the action on. The defaults value is `.main`.
///   - action: A function to throttle. Can accept two arguments.
/// - Returns: A new function that will only call `action` once every `delay` seconds, regardless of how often it is called.
public func throttle<T, U>(delay: TimeInterval, queue: DispatchQueue = .main, action: @escaping ((T, U) -> Void)) -> (T, U) -> Void {
    var currentWorkItem: DispatchWorkItem?
    var lastFire: TimeInterval = 0
    return { (p1: T, p2: U) in
        guard currentWorkItem == nil else { return }
        currentWorkItem = DispatchWorkItem {
            action(p1, p2)
            lastFire = Date().timeIntervalSinceReferenceDate
            currentWorkItem = nil
        }
        delay.hasPassed(since: lastFire) ? queue.async(execute: currentWorkItem!) : queue.asyncAfter(deadline: .now() + delay, execute: currentWorkItem!)
    }
}
