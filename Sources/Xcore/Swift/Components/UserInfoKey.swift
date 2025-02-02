//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - UserInfoKey

/// A type-safe key for accessing values in a user info dictionary.
///
/// `UserInfoKey` provides a way to associate keys with specific types, ensuring
/// type safety when storing and retrieving values.
///
/// **Usage**
///
/// ```swift
/// struct MyType: UserInfoContainer {
///     var userInfo: UserInfo = [:]
/// }
///
/// extension UserInfoKey<MyType> {
///     static var name: Self { #function }
/// }
///
/// var instance = MyType()
/// instance[userInfoKey: .name] = "Sam"
/// print(instance[userInfoKey: .name]) // Optional("Sam")
///
/// // Optionally, you can create a computed property to make the API more
/// // user-friendly.
/// extension MyType {
///     var name: String? {
///         get { self[userInfoKey: .name] }
///         set { self[userInfoKey: .name] = newValue }
///     }
/// }
///
/// instance.name = "Swift"
/// print(instance.name) // Optional("Swift")
/// ```
public struct UserInfoKey<Type>: RawRepresentable {
    /// The raw string value of the key.
    public let rawValue: String

    /// Creates a new `UserInfoKey` instance with the given raw value.
    ///
    /// - Parameter rawValue: The string representation of the key.
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

// MARK: - Conformance

extension UserInfoKey: ExpressibleByStringLiteral {
    /// Allows initialization of a `UserInfoKey` using a string literal.
    ///
    /// ```swift
    /// let key: UserInfoKey<MyType> = "name"
    /// ```
    ///
    /// - Parameter value: The string literal representing the key.
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension UserInfoKey: CustomStringConvertible {
    public var description: String {
        rawValue
    }
}

extension UserInfoKey: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        rawValue
    }
}

extension UserInfoKey: Sendable {}
extension UserInfoKey: Hashable {}
extension UserInfoKey: Codable {}

// MARK: - UserInfoContainer

/// A protocol for objects that support storing arbitrary user info.
///
/// `UserInfoContainer` provides a generic way to associate metadata with an
/// object using type-safe keys.
///
/// **Usage**
///
/// ```swift
/// struct MyType: UserInfoContainer {
///     var userInfo: UserInfo = [:]
/// }
///
/// extension UserInfoKey<MyType> {
///     static var name: Self { #function }
/// }
///
/// var instance = MyType()
/// instance[userInfoKey: .name] = "Sam"
/// print(instance[userInfoKey: .name]) // Optional("Sam")
///
/// // Optionally, you can create a computed property to make the API more
/// // user-friendly.
/// extension MyType {
///     var name: String? {
///         get { self[userInfoKey: .name] }
///         set { self[userInfoKey: .name] = newValue }
///     }
/// }
///
/// instance.name = "Swift"
/// print(instance.name) // Optional("Swift")
/// ```
public protocol UserInfoContainer {
    /// A type-safe key for accessing user info values.
    typealias UserInfoKey = Xcore.UserInfoKey<Self>

    /// A dictionary storing key-value pairs where the key is a `UserInfoKey`
    /// and the value conforms to `Sendable`.
    typealias UserInfo = [UserInfoKey: any Sendable]

    /// A dictionary storing user-defined metadata.
    var userInfo: UserInfo { get set }
}

// MARK: - UserInfoContainer Default Implementation

extension UserInfoContainer {
    /// Accesses the user info dictionary with a type-safe key.
    ///
    /// - Parameter key: The `UserInfoKey` identifying the stored value.
    /// - Returns: The value associated with `key`, or `nil` if not found.
    public subscript<T: Sendable>(userInfoKey key: UserInfoKey) -> T? {
        get { userInfo[key] as? T }
        set { userInfo[key] = newValue }
    }

    /// Retrieves a value for a given key, returning a default value if the key is not present.
    ///
    /// - Parameters:
    ///   - key: The `UserInfoKey` identifying the stored value.
    ///   - defaultValue: A fallback value to return if the key is not present.
    /// - Returns: The stored value, or `defaultValue` if the key does not exist.
    public subscript<T: Sendable>(userInfoKey key: UserInfoKey, default defaultValue: @autoclosure () -> T) -> T {
        self[userInfoKey: key] ?? defaultValue()
    }
}
