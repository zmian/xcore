//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension NSLocking {
    /// Invokes a closure after acquiring the lock by blocking a thread's execution
    /// until the lock can be acquired.
    ///
    /// - Parameter closure: The closure to execute after acquiring the lock.
    public func around(_ closure: () throws -> Void) rethrows {
        lock()
        defer { unlock() }
        try closure()
    }

    /// Invokes a closure returning a value after acquiring the lock by blocking a
    /// thread's execution until the lock can be acquired.
    ///
    /// - Parameter closure: The closure to execute after acquiring the lock.
    /// - Returns: The value returned from the closure.
    public func around<T>(_ closure: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try closure()
    }
}
