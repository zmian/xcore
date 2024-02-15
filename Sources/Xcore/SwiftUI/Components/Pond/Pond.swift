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
/// `InMemory`, `Unimplemented`, `Empty` and `Composite` types.
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

    func get<T: Codable>(_ type: T.Type, _ key: Key) throws -> T?

    func set<T: Codable>(_ key: Key, value: T?) throws

    /// Returns a Boolean value indicating whether the store contains value for the
    /// given key.
    func contains(_ key: Key) -> Bool

    func remove(_ key: Key)
}

// MARK: - Helpers

extension Pond {
    public func set<T>(_ key: Key, value: T?) throws where T: RawRepresentable, T.RawValue == String {
        try set(key, value: value?.rawValue)
    }

    public func set(_ key: Key, value: NSNumber?) throws {
        try set(key, value: value?.stringValue)
    }
}

// MARK: - Helpers: Get

extension Pond {
    private func value(_ key: Key) throws -> StringConverter? {
        StringConverter(try get(String.self, key))
    }

    public func get<T: Codable>(_ key: Key) throws -> T? {
        try get(T.self, key)
    }

    public func get(_ key: Key) throws -> NSNumber? {
        try? value(key)?.get()
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
}

// MARK: - Dependency

extension DependencyValues {
    private struct PondKey: DependencyKey {
        static var liveValue: Pond = .empty
    }

    /// Provide functionality for key value storage.
    public var pond: Pond {
        get { self[PondKey.self] }
        set { self[PondKey.self] = newValue }
    }

    /// Provide functionality for key value storage.
    @discardableResult
    public static func pond(_ value: Pond) -> Self.Type {
        PondKey.liveValue = value
        return Self.self
    }
}
