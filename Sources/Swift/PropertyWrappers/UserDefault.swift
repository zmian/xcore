//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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

    public var wrappedValue: Value {
        get { UserDefaults.standard.object(forKey: key) as? Value ?? defaultValue }
        set { UserDefaults.standard.set(newValue, forKey: key) }
    }
}
