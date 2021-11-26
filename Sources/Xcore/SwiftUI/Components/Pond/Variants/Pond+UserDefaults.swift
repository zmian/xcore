//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UserDefaultsPond: Pond {
    private let userDefaults: UserDefaults

    public init(_ userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        switch T.self {
            case is Data.Type, is Optional<Data>.Type:
                return userDefaults.object(forKey: key.id) as? T
            default:
                if Mirror.isCollection(T.self) {
                    return userDefaults.object(forKey: key.id) as? T
                } else {
                    return StringConverter(userDefaults.string(forKey: key.id))?.get(type)
                }
        }
    }

    public func set<T>(_ key: Key, value: T?) {
        if value == nil {
            remove(key)
        } else if let value = value, Mirror.isCollection(value) {
            userDefaults.set(value, forKey: key.id)
        } else if let value = value as? Data {
            userDefaults.set(value, forKey: key.id)
        } else if let value = StringConverter(value)?.get(String.self) {
            userDefaults.set(value, forKey: key.id)
        } else {
            #if DEBUG
            fatalError("Unable to save value for \(key.id).")
            #endif
        }
    }

    public func remove(_ key: Key) {
        userDefaults.removeObject(forKey: key.id)
    }

    public func contains(_ key: Key) -> Bool {
        userDefaults.object(forKey: key.id) != nil
    }
}

// MARK: - Dot Syntax Support

extension Pond where Self == UserDefaultsPond {
    /// Returns standard `UserDefaults` variant of `Pond`.
    public static var userDefaults: Self {
        .init()
    }

    /// Returns `UserDefaults` variant of `Pond`.
    public static func userDefaults(_ userDefaults: UserDefaults) -> Self {
        .init(userDefaults)
    }
}
