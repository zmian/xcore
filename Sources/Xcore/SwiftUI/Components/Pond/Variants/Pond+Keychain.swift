//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import KeychainAccess

public struct KeychainPond: Pond {
    private let keychain: Keychain
    public let id = "keychain"

    public init(_ keychain: Keychain) {
        self.keychain = keychain
    }

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        switch T.self {
            case is Data.Type, is Optional<Data>.Type:
                return try? keychain.getData(key.id) as? T
            default:
                if Mirror.isCollection(T.self) {
                    if let data = try? keychain.getData(key.id) {
                        return try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as? T
                    }
                }
                return StringConverter(keychain[key.id])?.get(type)
        }
    }

    public func set<T>(_ key: Key, value: T?) {
        do {
            if value == nil {
                remove(key)
            } else if let value = value as? Data {
                try keychain.set(value, key: key.id)
            } else if let value = StringConverter(value)?.get(String.self) {
                try keychain.set(value, key: key.id)
            } else if let value = value, Mirror.isCollection(value) {
                let data = try NSKeyedArchiver.archivedData(withRootObject: value, requiringSecureCoding: false)
                try keychain.set(data, key: key.id)
            } else {
                #if DEBUG
                fatalError("Unable to save value for \(key.id): \(String(describing: value))")
                #endif
            }
        } catch {
            #if DEBUG
            if AppInfo.isDebuggerAttached {
                print(String(describing: error))
            }
            #else
            // Return nothing to avoid leaking error details in production.
            #endif
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
