//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
@preconcurrency import KeychainAccess

public struct KeychainPond: Pond {
    private let keychain: Keychain
    public let id = "keychain"

    public init(_ keychain: Keychain) {
        self.keychain = keychain
    }

    public func get<T: Codable>(_ type: T.Type, _ key: Key) throws -> T? {
        switch T.self {
            case is Data.Type, is Optional<Data>.Type:
                return try keychain.getData(key.id) as? T
            default:
                if let stringValue = keychain[key.id] {
                    return StringConverter(stringValue)?.get(type)
                }

                if let data = try keychain.getData(key.id) {
                    return try JSONDecoder().decode(T.self, from: data)
                }

                return nil
        }
    }

    public func set<T: Codable>(_ key: Key, value: T?) throws {
        do {
            if value == nil {
                remove(key)
            } else if let value = value as? Data {
                try keychain.set(value, key: key.id)
            } else if let value = StringConverter(value)?.get(String.self) {
                try keychain.set(value, key: key.id)
            } else if let value {
                let data = try JSONEncoder().encode(value)
                try keychain.set(data, key: key.id)
            } else {
                throw PondError.saveFailure(id: key.id, value: value)
            }
        } catch {
            #if DEBUG
            if AppInfo.isDebuggerAttached {
                fatalError(String(describing: error))
            }
            #endif

            throw error
        }
    }

    public func contains(_ key: Key) -> Bool {
        do {
            return try keychain.contains(key.id, withoutAuthenticationUI: true)
        } catch {
            return false
        }
    }

    public func remove(_ key: Key) {
        try? keychain.remove(key.id)
    }

    public func removeAll() {
        try? keychain.removeAll()
    }

    public func allItems() -> [[String: Any]] {
        keychain.allItems()
    }

    public func allKeys() -> [String] {
        keychain.allKeys()
    }
}

// MARK: - Dot Syntax Support

extension Pond where Self == KeychainPond {
    /// Returns `Keychain` variant of `Pond`.
    public static func keychain(_ keychain: Keychain) -> Self {
        .init(keychain)
    }
}
