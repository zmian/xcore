//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct AnyPond<Key>: Pond where Key: Identifiable, Key.ID == String {
    private let base: Any
    private let _remove: (Key) -> Void
    private let _contains: (Key) -> Bool
    private let _get: (Any, Key) -> Any?
    private let _set: (Key, Any) -> Void

    init<P: Pond>(_ pond: P) where P.Key == Key {
        self.base = pond
        self._remove = pond.remove
        self._contains = pond.contains
        self._get = { type, key in
            pond.get(type as! Any.Protocol, key)
        }
        self._set = { key, value in
            pond.set(key, value: value)
        }
    }

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        _get(type, key) as? T
    }

    public func set<T>(_ key: Key, value: T?) {
        _set(key, value as Any)
    }

    public func remove(_ key: Key) {
        _remove(key)
    }

    public func contains(_ key: Key) -> Bool {
        _contains(key)
    }
}
