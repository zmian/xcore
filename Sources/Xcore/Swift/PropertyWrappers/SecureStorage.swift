//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import KeychainAccess

/// A property wrapper type that reflects a value from `Keychain` and
/// invalidates a view on a change in value in that keychain.
///
/// ```swift
/// enum Tokens {
///     @SecureStorage("at")
///     static var accessToken: String?
/// }
/// ```
@propertyWrapper
public struct SecureStorage<Value> {
    private let store: Keychain
    private let get: () -> Value?
    private let set: (Value?) -> Void

    public init(wrappedValue: Value, _ key: String, store: Keychain) {
        self.store = store
        self.get = { StringConverter(store[key])?.get() ?? wrappedValue }
        self.set = {
            store[key] = $0.map(StringConverter.init)??.get()
        }
    }

    public var wrappedValue: Value {
        get { get()! }
        set { set(newValue) }
    }
}

extension SecureStorage where Value: ExpressibleByNilLiteral {
    public init(_ key: String, store: Keychain) {
        self.store = store
        self.get = { StringConverter(store[key])?.get() }
        self.set = {
            store[key] = $0.map(StringConverter.init)??.get()
        }
    }

    public var wrappedValue: Value? {
        get { get() }
        set { set(newValue) }
    }
}
