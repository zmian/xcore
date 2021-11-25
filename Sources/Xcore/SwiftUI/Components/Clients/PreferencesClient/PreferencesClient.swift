//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Client

public protocol PreferencesClient {
    typealias Key = PreferencesClientKey

    func get(_ key: Key) -> String?
    func set(_ key: Key, value: String?)

    func set<T>(_ key: Key, value: T?)
    func contains(_ key: Key) -> Bool
    func remove(_ key: Key)
}

// MARK: - Helpers: Get

extension PreferencesClient {
    private func value(_ key: Key) -> StringConverter? {
        StringConverter(get(key))
    }

    public func get(_ key: Key) -> Bool {
        value(key)?.get() ?? false
    }

    public func get<T>(_ key: Key) -> T? {
        value(key)?.get()
    }

    public func get<T>(_ key: Key, default defaultValue: @autoclosure () -> T) -> T {
        value(key)?.get() ?? defaultValue()
    }

    public func get<T>(_ key: Key, default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        value(key)?.get() ?? defaultValue()
    }

    /// Returns the value of the key, decoded from a JSON object.
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode from the string.
    ///   - decoder: The decoder used to decode the data. If set to `nil`, it uses
    ///     ``JSONDecoder`` with `convertFromSnakeCase` key decoding strategy.
    /// - Returns: A value of the specified type, if the decoder can parse the data.
    public func getDecoded<T>(_ key: Key, type: T.Type = T.self, decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        value(key)?.get(type, decoder: decoder)
    }
}

// MARK: - Helpers: Set

extension PreferencesClient {
    public func set<T>(_ key: Key, value: T?) {
        guard let value = value else {
            return remove(key)
        }

        set(key, value: StringConverter(value)?.get())
    }

    public func set<T>(_ key: Key, value: T?) where T: RawRepresentable, T.RawValue == String {
        set(key, value: value?.rawValue)
    }
}

// MARK: - Helpers

extension PreferencesClient {
    /// Returns a boolean value indicating whether the Preferences contains the
    /// given key.
    public func contains(_ key: Key) -> Bool {
        get(key) != nil
    }

    public func remove(_ key: Key) {
        set(key, value: nil)
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct PreferencesClientKey: DependencyKey {
        static let defaultValue: PreferencesClient = .userDefaults
    }

    public var preferences: PreferencesClient {
        get { self[PreferencesClientKey.self] }
        set { self[PreferencesClientKey.self] = newValue }
    }

    @discardableResult
    public static func preferences<P: PreferencesClient>(_ value: P) -> Self.Type {
        set(\.preferences, value)
        return Self.self
    }
}
