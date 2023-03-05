//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Provides functionality to keep track of user's session counts.
public struct SessionCounterClient {
    private let _count: @Sendable () -> Int

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
        self._count = count
        self.increment = increment
    }

    /// Returns user's current session count.
    public var count: Int {
        _count()
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
            XCTFail("\(Self.self).count is unimplemented")
            return 0
        } increment: {
            XCTFail("\(Self.self).increment is unimplemented")
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct SessionCounterClientKey: DependencyKey {
        static var liveValue: SessionCounterClient = .live
        static var testValue: SessionCounterClient = .unimplemented
        static var previewValue: SessionCounterClient = .noop
    }

    /// Provides functionality to keep track of user's session counts.
    public var sessionCounter: SessionCounterClient {
        get { self[SessionCounterClientKey.self] }
        set { self[SessionCounterClientKey.self] = newValue }
    }

    /// Provides functionality to keep track of user's session counts.
    @discardableResult
    public static func sessionCounter(_ value: SessionCounterClient) -> Self.Type {
        SessionCounterClientKey.liveValue = value
        return Self.self
    }
}
