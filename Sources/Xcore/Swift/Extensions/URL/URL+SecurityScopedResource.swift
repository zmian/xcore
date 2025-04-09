//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension URL {
    /// Performs an operation with temporary access to a security-scoped resource.
    ///
    /// Use this method to safely access a resource referenced by a security-scoped
    /// URL, such as one obtained by resolving a security-scoped bookmark.
    ///
    /// Security-scoped URLs do not grant immediate access to their resources; you
    /// must explicitly request access to include the resource’s location within
    /// your app’s sandbox. This method starts access, executes the provided
    /// operation, and ensures access is relinquished when the operation completes.
    ///
    /// To use a security-scoped resource:
    /// 1. Obtain a security-scoped URL, typically via a bookmark created with
    ///    ``bookmarkData(options:includingResourceValuesForKeys:relativeTo:)`` or a
    ///    user interaction like ``UIDocumentPickerViewController``.
    /// 2. Call this method with an operation that uses the resource.
    ///
    /// This method automatically balances the call to
    /// `startAccessingSecurityScopedResource()` with a corresponding
    /// `stopAccessingSecurityScopedResource()`, ensuring proper resource cleanup.
    /// If access cannot be granted, it throws an error.
    ///
    /// - Parameter operation: A closure that performs the desired operation with
    ///   the resource. The closure is executed only if access is successfully
    ///   granted.
    /// - Returns: The result of the operation, if access is successfully granted.
    /// - Throws: An error if access cannot be started or any error thrown by the
    ///   operation.
    ///
    /// - SeeAlso: `startAccessingSecurityScopedResource()` and
    ///   `stopAccessingSecurityScopedResource()`
    @discardableResult
    public func withSecurityScopedAccess<T>(_ operation: (URL) throws -> T) throws -> T {
        guard startAccessingSecurityScopedResource() else {
            throw SecurityScopedResourceError(url: self)
        }

        defer { stopAccessingSecurityScopedResource() }
        return try operation(self)
    }

    /// Performs an asynchronous operation with temporary access to a
    /// security-scoped resource.
    ///
    /// Use this method to safely access a resource referenced by a security-scoped
    /// URL, such as one obtained by resolving a security-scoped bookmark.
    ///
    /// Security-scoped URLs do not grant immediate access to their resources; you
    /// must explicitly request access to include the resource’s location within
    /// your app’s sandbox. This method starts access, executes the provided
    /// operation, and ensures access is relinquished when the operation completes.
    ///
    /// To use a security-scoped resource:
    /// 1. Obtain a security-scoped URL, typically via a bookmark created with
    ///    ``bookmarkData(options:includingResourceValuesForKeys:relativeTo:)`` or a
    ///    user interaction like ``UIDocumentPickerViewController``.
    /// 2. Call this method with an operation that uses the resource.
    ///
    /// This method automatically balances the call to
    /// `startAccessingSecurityScopedResource()` with a corresponding
    /// `stopAccessingSecurityScopedResource()`, ensuring proper resource cleanup.
    /// If access cannot be granted, it throws an error.
    ///
    /// - Parameter operation: A closure that performs the desired operation with
    ///   the resource. The closure is executed only if access is successfully
    ///   granted.
    /// - Returns: The result of the operation, if access is successfully granted.
    /// - Throws: An error if access cannot be started or any error thrown by the
    ///   operation.
    ///
    /// - SeeAlso: `startAccessingSecurityScopedResource()` and
    ///   `stopAccessingSecurityScopedResource()`
    @discardableResult
    public func withSecurityScopedAccess<T>(_ operation: (URL) async throws -> T) async throws -> T {
        guard startAccessingSecurityScopedResource() else {
            throw SecurityScopedResourceError(url: self)
        }

        defer { stopAccessingSecurityScopedResource() }
        return try await operation(self)
    }
}

private struct SecurityScopedResourceError: LocalizedError {
    let errorDescription: String?

    init(url: URL) {
        errorDescription = "Unable to gain access to security-scoped resource at \(url.path)"
    }
}
