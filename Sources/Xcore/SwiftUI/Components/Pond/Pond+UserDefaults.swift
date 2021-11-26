//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public final class UserDefaultsPond: Pond {
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

extension Pond where Self == UserDefaultsPond {
    /// Returns standard `UserDefaults` variant of `Pond`.
    public static var userDefaults: Self { .init() }

    /// Returns `UserDefaults` variant of `Pond`.
    public static func userDefaults(_ userDefaults: UserDefaults) -> Self {
        .init(userDefaults)
    }
}
