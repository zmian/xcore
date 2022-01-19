//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A protocol where the conforming types provide functionality for key value
/// storage.
///
/// The library comes with few types out of the box: `UserDefaults`, `Keychain`,
/// `InMemory`, `Failing`, `Empty` and `Composite` types.
///
/// To allow testability, reliability and predictability for persisting various
/// types of data ranging from tokens to perishable user preferences. The
/// library comes with few types out of the box to provide consolidated Key
/// Value Storage API for Keychain (secure storage), In-Memory (ephemeral
/// storage), and UserDefaults (non-sensitive storage).
public protocol Pond {
    typealias Key = PondKey

    /// A unique id for the pond.
    var id: String { get }

    func get<T>(_ type: T.Type, _ key: Key) throws -> T?

    func set<T>(_ key: Key, value: T?) throws

    /// Returns a boolean value indicating whether the store contains value for the
    /// given key.
    func contains(_ key: Key) -> Bool

    func remove(_ key: Key)
}

// MARK: - Helpers

extension Pond {
    public func set<T>(_ key: Key, value: T?) throws where T: RawRepresentable, T.RawValue == String {
        try set(key, value: value?.rawValue)
    }

    public func setCodable<T: Codable>(_ key: Key, value: T?, encoder: JSONEncoder? = nil) {
        do {
            let data = try (encoder ?? JSONEncoder()).encode(value)
            try set(key, value: data)
        } catch {
            #if DEBUG
            if AppInfo.isDebuggerAttached {
                fatalError(String(describing: error))
            }
            #endif
        }
    }
}

// MARK: - Helpers: Get

extension Pond {
    private func value(_ key: Key) throws -> StringConverter? {
        StringConverter(try get(key))
    }

    public func get<T>(_ key: Key) throws -> T? {
        try get(T.self, key)
    }

    public func get<T>(_ key: Key, default defaultValue: @autoclosure () -> T) -> T {
        do {
            return try value(key)?.get() ?? defaultValue()
        } catch {
            return defaultValue()
        }
    }

    public func get<T>(_ key: Key, default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        do {
            return try value(key)?.get() ?? defaultValue()
        } catch {
            return defaultValue()
        }
    }

    /// Returns the value of the key, decoded from a JSON object.
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode from the string.
    ///   - decoder: The decoder used to decode the data. If set to `nil`, it uses
    ///     ``JSONDecoder`` with `convertFromSnakeCase` key decoding strategy.
    /// - Returns: A value of the specified type, if the decoder can parse the data.
    public func getCodable<T>(_ key: Key, type: T.Type = T.self, decoder: JSONDecoder? = nil) -> T? where T: Decodable {
        do {
            if let data = try get(Data.self, key) {
                return StringConverter.get(type, from: data, decoder: decoder)
            }

            if let value = StringConverter(try get(String.self, key))?.get(type, decoder: decoder) {
                return value
            }

            return nil
        } catch {
            return nil
        }
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

    /// Provide functionality for key value storage.
    public var pond: Pond {
        get { self[XcorePondKey.self] }
        set { self[XcorePondKey.self] = newValue }
    }

    /// Provide functionality for key value storage.
    @discardableResult
    public static func pond(_ value: Pond) -> Self.Type {
        set(\.pond, value)
        return Self.self
    }
}
