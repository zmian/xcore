//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol Pond {
    typealias Key = PondKey

    func get<T>(_ type: T.Type, _ key: Key) -> T?

    func set<T>(_ key: Key, value: T?)

    /// Returns a boolean value indicating whether the store contains value for the
    /// given key.
    func contains(_ key: Key) -> Bool

    func remove(_ key: Key)
}

// MARK: - Helpers

extension Pond {
    public func set<T>(_ key: Key, value: T?) where T: RawRepresentable, T.RawValue == String {
        set(key, value: value?.rawValue)
    }
}

// MARK: - Helpers: Get

extension Pond {
    private func value(_ key: Key) -> StringConverter? {
        StringConverter(get(key))
    }

    public func get<T>(_ key: Key) -> T? {
        get(T.self, key)
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
        if let data = get(Data.self, key) {
            return StringConverter.get(type, from: data, decoder: decoder)
        }

        if let value = StringConverter(get(String.self, key))?.get(type, decoder: decoder) {
            return value
        }

        return nil
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct XcorePondKey: DependencyKey {
        static let defaultValue: Pond = {
            #if DEBUG
            if ProcessInfo.Arguments.isTesting {
                return .failing
            }
            #endif
            return .empty
        }()
    }

    public var pond: Pond {
        get { self[XcorePondKey.self] }
        set { self[XcorePondKey.self] = newValue }
    }

    @discardableResult
    public static func pond(_ value: Pond) -> Self.Type {
        set(\.pond, value)
        return Self.self
    }
}