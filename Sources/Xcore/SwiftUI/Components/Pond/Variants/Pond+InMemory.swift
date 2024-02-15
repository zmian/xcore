//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct InMemoryPond: Pond {
    private var storage = MutableBox<[String: Any]>([:])
    public let id = "inMemory"

    public init() {}

    public func get<T: Codable>(_ type: T.Type, _ key: Key) throws -> T? {
        switch T.self {
            case is Data.Type, is Optional<Data>.Type:
                return storage[key.id] as? T
            default:
                if let stringValue = storage[key.id] as? String {
                    return StringConverter(stringValue)?.get(type)
                }

                if let data = storage[key.id] as? Data {
                    return try JSONDecoder().decode(T.self, from: data)
                }

                return nil
        }
    }

    public func set<T: Codable>(_ key: Key, value: T?) throws {
        if value == nil {
            remove(key)
        } else if let value = value as? Data {
            storage[key.id] = value
        } else if let value = StringConverter(value)?.get(String.self) {
            storage[key.id] = value
        } else if let value {
            let data = try JSONEncoder().encode(value)
            storage[key.id] = data
        } else {
            #if DEBUG
            fatalError("Unable to save value for \(key.id): \(String(describing: value))")
            #endif
        }
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

extension Pond where Self == InMemoryPond {
    /// Returns inMemory variant of `Pond`.
    public static var inMemory: Self { .init() }
}
