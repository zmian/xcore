//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public struct UserDefaultsPond: Pond {
    private let userDefaults: UserDefaults
    public let id = "userDefaults"

    public init(_ userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func get<T: Codable>(_ type: T.Type, _ key: Key) throws -> T? {
        switch T.self {
            case is Data.Type, is Optional<Data>.Type:
                return userDefaults.object(forKey: key.id) as? T
            default:
                if let stringValue = userDefaults.string(forKey: key.id) {
                    return StringConverter(stringValue)?.get(type)
                }

                if let data = userDefaults.data(forKey: key.id) {
                    return try JSONDecoder().decode(T.self, from: data)
                }

                return nil
        }
    }

    public func set<T: Codable>(_ key: Key, value: T?) throws {
        do {
            if value == nil {
                remove(key)
            } else if let value = value as? Data {
                userDefaults.set(value, forKey: key.id)
            } else if let value = StringConverter(value)?.get(String.self) {
                userDefaults.set(value, forKey: key.id)
            } else if let value {
                let data = try JSONEncoder().encode(value)
                userDefaults.set(data, forKey: key.id)
            } else {
                throw PondError.saveFailure(id: key.id, value: value)
            }
        } catch {
            #if DEBUG
            if AppInfo.isDebuggerAttached {
                fatalError(String(describing: error))
            }
            #endif

            throw error
        }
    }

    public func remove(_ key: Key) {
        userDefaults.removeObject(forKey: key.id)
    }

    public func contains(_ key: Key) -> Bool {
        userDefaults.object(forKey: key.id) != nil
    }
}

// MARK: - Dot Syntax Support

extension Pond where Self == UserDefaultsPond {
    /// Returns standard `UserDefaults` variant of `Pond`.
    public static var userDefaults: Self {
        .init()
    }

    /// Returns `UserDefaults` variant of `Pond`.
    public static func userDefaults(_ userDefaults: UserDefaults) -> Self {
        .init(userDefaults)
    }
}
