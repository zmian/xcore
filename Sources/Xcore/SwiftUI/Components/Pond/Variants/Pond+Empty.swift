//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct EmptyPond: Pond {
    public let id = "empty"

    public init() {}

    public func get<T: Codable>(_ type: T.Type, _ key: Key) -> T? {
        nil
    }

    public func set<T: Codable>(_ key: Key, value: T?) {}

    public func remove(_ key: Key) {}

    public func contains(_ key: Key) -> Bool {
        false
    }
}

// MARK: - Dot Syntax Support

extension Pond where Self == EmptyPond {
    /// Returns empty variant of `Pond`.
    public static var empty: Self { .init() }
}
