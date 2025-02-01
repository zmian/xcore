//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Random

extension NSError {
    /// Returns an `NSError` instance with a random domain and code.
    ///
    /// This is useful for testing error handling scenarios where a random error is
    /// needed.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let error = NSError.random()
    /// print(error.domain) // Example: "ZXTG9N1J7A"
    /// print(error.code)   // Example: 325
    /// ```
    ///
    /// - Returns: A randomly generated `NSError`.
    public static func random() -> Self {
        .init(domain: .random(), code: .random(), userInfo: nil)
    }
}

// MARK: - UserInfo Merging

extension NSError {
    /// Returns a new `NSError` by merging additional user info into the existing
    /// one.
    ///
    /// This method creates a copy of the current error and appends the given
    /// dictionary to the existing `userInfo` dictionary, replacing any existing
    /// keys with newer values.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let originalError = NSError(domain: "com.example", code: 1, userInfo: ["key": "value"])
    /// let updatedError = originalError.appendingUserInfo(["key": "newValue", "extra": 123])
    ///
    /// print(updatedError.userInfo)
    /// // Output: ["key": "newValue", "extra": 123]
    /// ```
    ///
    /// - Parameter userInfo: The dictionary containing new user info to merge.
    /// - Returns: A new `NSError` with the updated user info.
    public func appendingUserInfo(_ userInfo: [String: Any]) -> NSError {
        var newUserInfo = self.userInfo
        newUserInfo.merge(userInfo, strategy: .replaceExisting)

        return .init(
            domain: domain,
            code: code,
            userInfo: newUserInfo
        )
    }
}

// MARK: - Conversion

extension Error {
    /// Converts the current error to `AppError`, or returns a fallback error.
    ///
    /// If the current error is already an `AppError`, it is returned as is.
    /// Otherwise, the provided fallback error is returned.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// do {
    ///     try someFunctionThatThrows()
    /// } catch {
    ///     let appError = error.asAppError(or: .general)
    /// }
    /// ```
    ///
    /// - Parameter fallbackError: The error to return if the conversion fails.
    /// - Returns: The converted `AppError` instance.
    @_disfavoredOverload
    public func asAppError(or fallbackError: @autoclosure () -> AppError) -> AppError {
        (self as? AppError) ?? fallbackError()
    }
}
