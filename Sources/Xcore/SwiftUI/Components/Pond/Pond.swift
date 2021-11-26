//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol Pond {
    typealias Key = PondKey

    func get(_ key: Key) -> String?
    func set(_ key: Key, value: String?)

    func set<T>(_ key: Key, value: T?)

    /// Returns a boolean value indicating whether the store contains value for the
    /// given key.
    func contains(_ key: Key) -> Bool

    func remove(_ key: Key)
}

// MARK: - Helpers: Get

extension Pond {
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

extension Pond {
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

extension Pond {
    public func contains(_ key: Key) -> Bool {
        get(key) != nil
    }

    public func remove(_ key: Key) {
        set(key, value: nil)
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct PondKey: DependencyKey {
        static let defaultValue: Pond = .userDefaults
    }

    public var pond: Pond {
        get { self[PondKey.self] }
        set { self[PondKey.self] = newValue }
    }

    @discardableResult
    public static func pond<P: Pond>(_ value: P) -> Self.Type {
        set(\.pond, value)
        return Self.self
    }
}
