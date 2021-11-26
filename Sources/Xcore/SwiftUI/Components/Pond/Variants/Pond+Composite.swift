//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import KeychainAccess

public struct CompositePond<Key>: Pond where Key: Identifiable, Key.ID == String {
    private let pond: (Key) -> AnyPond<Key>

    public init(_ pond: @escaping (Key) -> AnyPond<Key>) {
        self.pond = pond
    }

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        pond(key).get(type, key)
    }

    public func set<T>(_ key: Key, value: T?) {
        pond(key).set(key, value: value)
    }

    public func contains(_ key: Key) -> Bool {
        pond(key).contains(key)
    }

    public func remove(_ key: Key) {
        pond(key).remove(key)
    }
}

// MARK: - Dot Syntax Support

extension Pond {
    /// Returns composite variant of `Pond`.
    public static func composite<Key>(_ pond: @escaping (Key) -> AnyPond<Key>) -> Self where Self == CompositePond<Key> {
        .init(pond)
    }
}
