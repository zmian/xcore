//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Synchronization

@available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
extension Mutex {
    /// Replaces the current protected value with a new value.
    ///
    /// This method acquires an exclusive lock on the protected value and then
    /// assigns it a new value computed from the provided autoclosure. Using
    /// this method ensures that the entire update is performed atomically,
    /// thereby preventing data races.
    ///
    /// ```swift
    /// // Protect an integer for concurrent read/write access:
    /// let count = Mutex(0)
    ///
    /// func reset() {
    ///   // Reset it:
    ///   count.setValue(0)
    /// }
    /// ```
    ///
    /// > Tip: Use ``withLock(_:)`` instead of ``setValue(_:)`` if the value being
    /// > set is derived from the current value. That is, do this:
    /// >
    /// > ```swift
    /// > count.withLock { $0 += 1 }
    /// > ```
    /// >
    /// > ...and not this:
    /// >
    /// > ```swift
    /// > count.setValue(count + 1)
    /// > ```
    /// >
    /// > ``withLock(_:)`` protects the entire transaction and avoids data races
    /// > between reading and writing the value.
    ///
    /// - Parameter newValue: The new value to replace the current protected value.
    public borrowing func setValue(_ newValue: @autoclosure () throws -> sending Value) rethrows {
        try withLock {
            $0 = try newValue()
        }
    }
}
