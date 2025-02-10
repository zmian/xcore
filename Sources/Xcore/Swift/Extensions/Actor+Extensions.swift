//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable opening_brace

import Foundation

extension MainActor {
    /// Executes an operation synchronously on the main actor’s serial executor.
    ///
    /// - Warning: This API is not recommended for general use. Use this function
    ///   only in exceptional cases. In most situations, prefer using the
    ///   `@MainActor` attribute.
    ///
    /// This function checks if the current task is executing on the main actor’s
    /// serial executor. If so, it executes the operation immediately using
    /// `MainActor.assumeIsolated()`. Otherwise, it dispatches the operation
    /// synchronously to the main actor’s serial executor and returns its result.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// // Before
    /// struct Model {
    ///     /// Return true `1` pixel relative to the screen scale.
    ///     @MainActor // 👈 ← Requires @MainActor attribute
    ///     var onePixel: CGFloat {
    ///         1 / UIScreen.main.scale
    ///     }
    /// }
    ///
    /// // After
    /// struct Model {
    ///     /// Return true `1` pixel relative to the screen scale.
    ///     var onePixel: CGFloat {
    ///         // ✅ No longer requires @MainActor attribute as the body has been isolated to MainActor directly.
    ///         MainActor.performIsolated {
    ///             1 / UIScreen.main.scale
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - operation: The operation that will be executed on the main actor that
    ///     returns a value of type `T`.
    ///   - file: The file name to print if the assertion fails.
    ///   - line: The line number to print if the assertion fails.
    /// - Returns: The return value of the `operation`.
    /// - Throws: Rethrows the `Error` thrown by the operation.
    @_spi(Internal)
    public static func performIsolated<T: Sendable>(
        _ operation: @MainActor () throws -> T,
        file: StaticString = #fileID,
        line: UInt = #line
    ) rethrows -> T {
        if Thread.isMainThread {
            // Execute immediately if already on the main thread.
            return try MainActor.assumeIsolated(
                { try operation() },
                file: file,
                line: line
            )
        }

        // Otherwise, dispatch synchronously to the main queue.
        return try DispatchQueue.main.sync {
            try operation()
        }
    }
}
