//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Provides functionality to keep track of user's session counts.
public struct SessionCounterClient: Sendable {
    /// Returns user's current session count.
    public let count: @Sendable () -> Int

    /// Increments user's session count.
    public let increment: @Sendable () -> Void

    /// Creates a client to keep track of user's session counts.
    ///
    /// - Parameters:
    ///   - count: Returns user's current session count.
    ///   - increment: Increments user's session count.
    public init(
        count: @escaping @Sendable() -> Int,
        increment: @escaping @Sendable () -> Void
    ) {
        self.count = count
        self.increment = increment
    }
}

// MARK: - Variants

extension SessionCounterClient {
    /// Returns noop variant of `SessionCounterClient`.
    public static var noop: Self {
        .init { 0 } increment: {}
    }

    /// Returns unimplemented variant of `SessionCounterClient`.
    public static var unimplemented: Self {
        .init {
            reportIssue("\(Self.self).count is unimplemented")
            return 0
        } increment: {
            reportIssue("\(Self.self).increment is unimplemented")
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum SessionCounterClientKey: DependencyKey {
        static let liveValue: SessionCounterClient = .live
        static let testValue: SessionCounterClient = .unimplemented
        static let previewValue: SessionCounterClient = .noop
    }

    /// Provides functionality to keep track of user's session counts.
    public var sessionCounter: SessionCounterClient {
        get { self[SessionCounterClientKey.self] }
        set { self[SessionCounterClientKey.self] = newValue }
    }
}
