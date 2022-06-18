//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Provides functionality to keep track of user's session counts.
public protocol SessionCounterClient {
    var count: Int { get }
    func increment()
}

// MARK: - Dependency

extension DependencyValues {
    private struct SessionCounterClientKey: DependencyKey {
        static let defaultValue: SessionCounterClient = .noop
    }

    public var sessionCounter: SessionCounterClient {
        get { self[SessionCounterClientKey.self] }
        set { self[SessionCounterClientKey.self] = newValue }
    }

    @discardableResult
    public static func sessionCounter(_ value: SessionCounterClient) -> Self.Type {
        self[\.sessionCounter] = value
        return Self.self
    }
}
