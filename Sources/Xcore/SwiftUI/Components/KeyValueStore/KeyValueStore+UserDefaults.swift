//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public final class UserDefaultsKeyValueStore: KeyValueStore {
    private let userDefaults: UserDefaults

    public init(_ userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func get(_ key: Key) -> String? {
        userDefaults.string(forKey: key.id)
    }

    public func set(_ key: Key, value: String?) {
        userDefaults.set(value, forKey: key.id)
    }
}

// MARK: - Dot Syntax Support

extension KeyValueStore where Self == UserDefaultsKeyValueStore {
    /// Returns standard `UserDefaults` variant of `KeyValueStore`.
    public static var userDefaults: Self { .init() }

    /// Returns `UserDefaults` variant of `KeyValueStore`.
    public static func userDefaults(_ userDefaults: UserDefaults) -> Self {
        .init(userDefaults)
    }
}
