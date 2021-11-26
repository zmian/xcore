//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

#if DEBUG
import Foundation

public struct StubPond<Key>: Pond where Key: Identifiable, Key.ID == String {
    private var storage: MutableBox<[String: String]> = .init([:])

    public init() {}

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        StringConverter(storage[key.id])?.get(type)
    }

    public func set<T>(_ key: Key, value: T?) {
        storage[key.id] = StringConverter(value as Any)?.get()
    }

    public func remove(_ key: Key) {
        storage[key.id] = nil
    }

    public func contains(_ key: Key) -> Bool {
        storage.keys.contains(key.id)
    }

    public func removeAll() {
        storage.value.removeAll()
    }
}

// MARK: - Dot Syntax Support

extension Pond {
    /// Returns stub variant of `Pond`.
    public static func stub<Key>() -> Self where Self == StubPond<Key> {
        .init()
    }
}
#endif
