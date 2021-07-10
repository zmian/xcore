//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that stores a property marked with an attribute to user default.
///
/// ```swift
/// enum GlobalSettings {
///     @UserDefault(key: "is_first_launch", defaultValue: false)
///     static var isFirstLaunch: Bool
/// }
/// ```
@propertyWrapper
public struct UserDefault<Value> {
    public let key: String
    public let defaultValue: Value
    public let storage: UserDefaults

    public init(key: String, defaultValue: Value, storage: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.storage = storage
    }

    public var wrappedValue: Value {
        get { storage.object(forKey: key) as? Value ?? defaultValue }
        set { storage.set(newValue, forKey: key) }
    }
}
