//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import KeychainAccess

public struct CompositePond: Pond {
    private let pond: (Key) -> Pond

    public init(_ pond: @escaping (Key) -> Pond) {
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

extension Pond where Self == CompositePond {
    /// Returns composite variant of `Pond`.
    public static func composite(_ pond: @escaping (Key) -> Pond) -> Self {
        .init(pond)
    }

    /// Returns composite variant of `Pond` with Keychain `accessGroup` and optional
    /// ``UserDefaults`` `suiteName`.
    ///
    /// - Parameters:
    ///   - accessGroup: A string indicating the access group for the Keychain
    ///     items.
    ///   - suiteName: Creates a user defaults object initialized with the defaults
    ///     for the specified database name. The default value is `.standard`
    /// - Returns: Returns composite variant of `Pond`.
    public static func composite(accessGroup: String, suiteName: String? = nil) -> Self {
        let defaults = suiteName.map { UserDefaults.init(suiteName: $0)! } ?? .standard
        let userDefaults = UserDefaultsPond(defaults)

        return composite { key in
            switch key.storage {
                case .userDefaults:
                    return userDefaults
                case let .keychain(policy):
                    return KeychainPond(.keychain(accessGroup: accessGroup, policy: policy))
            }
        }
    }
}
