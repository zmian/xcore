//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import KeychainAccess

extension CompositePond {
    /// An enumeration representing the method requesting the pond for the key.
    public enum Method: Hashable {
        case get
        case set
        case contains
        case remove
    }
}

public struct CompositePond: Pond {
    public let id: String

    private let pond: (Method, Key) -> Pond

    public init(id: String, _ pond: @escaping (Method, Key) -> Pond) {
        self.id = "composite:\(id)"
        self.pond = pond
    }

    public func get<T>(_ type: T.Type, _ key: Key) -> T? {
        pond(.get, key).get(type, key)
    }

    public func set<T>(_ key: Key, value: T?) {
        pond(.set, key).set(key, value: value)
    }

    public func contains(_ key: Key) -> Bool {
        pond(.contains, key).contains(key)
    }

    public func remove(_ key: Key) {
        pond(.remove, key).remove(key)
    }
}

// MARK: - Dot Syntax Support

extension Pond where Self == CompositePond {
    /// Returns composite variant of `Pond`.
    public static func composite(id: String, _ pond: @escaping (Self.Method, Key) -> Pond) -> Self {
        .init(id: id, pond)
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
        composite(keychain: .default(accessGroup: accessGroup), suiteName: suiteName)
    }

    /// Returns composite variant of `Pond` with Keychain `accessGroup` and optional
    /// ``UserDefaults`` `suiteName`.
    ///
    /// - Parameters:
    ///   - keychain: The Keychain to use for keys that are marked with `keychain`
    ///     storage. Note, the policy is automatically applied to the given keychain
    ///     to ensure key preference is preserved.
    ///   - suiteName: Creates a user defaults object initialized with the defaults
    ///     for the specified database name. The default value is `.standard`
    /// - Returns: Returns composite variant of `Pond`.
    public static func composite(keychain: Keychain, suiteName: String? = nil) -> Self {
        let defaults = suiteName.map { UserDefaults(suiteName: $0)! } ?? .standard
        let userDefaults = UserDefaultsPond(defaults)

        return composite(id: "keychain:userDefaults") { _, key in
            switch key.storage {
                case .userDefaults:
                    return userDefaults
                case let .keychain(policy):
                    return KeychainPond(keychain.policy(policy))
            }
        }
    }
}
