//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct EmptyPond<Key>: Pond where Key: Identifiable, Key.ID == String {
    public init() {}

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        nil
    }

    public func set<T>(_ key: Key, value: T?) {}

    public func remove(_ key: Key) {}

    public func contains(_ key: Key) -> Bool {
        false
    }
}

// MARK: - Dot Syntax Support

extension Pond {
    /// Returns empty variant of `Pond`.
    public static func empty<Key>() -> Self where Self == EmptyPond<Key> {
        .init()
    }
}
