//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UserDefaultsPond<Key>: Pond where Key: Identifiable, Key.ID == String {
    private let userDefaults: UserDefaults

    public init(_ userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        StringConverter(userDefaults.string(forKey: key.id))?.get(type)
    }

    public func set<T>(_ key: Key, value: T?) {
        userDefaults.set(value, forKey: key.id)
    }

    public func remove(_ key: Key) {
        userDefaults.removeObject(forKey: key.id)
    }
}

// MARK: - Dot Syntax Support

extension Pond {
    /// Returns standard `UserDefaults` variant of `Pond`.
    public static func userDefaults<Key>() -> Self where Self == UserDefaultsPond<Key> {
        .init()
    }

    /// Returns `UserDefaults` variant of `Pond`.
    public static func userDefaults<Key>(_ userDefaults: UserDefaults) -> Self where Self == UserDefaultsPond<Key> {
        .init(userDefaults)
    }
}
