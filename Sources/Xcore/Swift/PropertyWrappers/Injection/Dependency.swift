//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - DependencyKey

/// A key for accessing values in the ``DependencyValues`` container.
///
/// You can create custom dependency values by extending the
/// ``DependencyValues`` structure with new properties. First declare a new
/// dependency key type and specify a value for the required ``defaultValue``
/// property:
///
/// ```swift
/// private struct MyDependencyKey: DependencyKey {
///     static let defaultValue: String = "Default value"
/// }
/// ```
///
/// The Swift compiler automatically infers the associated ``Value`` type as the
/// type you specify for the default value. Then use the key to define a new
/// dependency value property:
///
/// ```swift
/// extension DependencyValues {
///     var myCustomValue: String {
///         get { self[MyDependencyKey.self] }
///         set { self[MyDependencyKey.self] = newValue }
///     }
/// }
///
/// class MyTests: TestCase {
///     // Reset all of the `DependencyValues` storage.
///     func setUp() async throws {
///         DependencyValues.resetAll()
///     }
///
///     func testPasteboard() throws {
///         struct ViewModel {
///             @Dependency(\.myCustomValue) var myCustomValue
///         }
///
///         let viewModel = ViewModel()
///         XCTAssertEqual(viewModel.myCustomValue, "Failing value")
///
///         DependencyValues.set(\.myCustomValue, "hello")
///         XCTAssertEqual(viewModel.myCustomValue, "hello")
///     }
/// }
/// ```
public protocol DependencyKey {
    /// The associated type representing the type of the dependency key's
    /// value.
    associatedtype Value

    /// The default value for the dependency key.
    static var defaultValue: Value { get }
}

// MARK: - Dependency

/// A property wrapper that reads a value from ``DependencyValues`` container.
///
/// Use the `Dependency` property wrapper to read the current value stored in
/// ``DependencyValues`` container. For example, you can create a property that
/// reads the pasteboard using the key path of the
/// ``DependencyValues/myCustomValue`` property:
///
/// ```swift
/// @Dependency(\.myCustomValue) var myCustomValue
/// ```
@propertyWrapper
public struct Dependency<Value> {
    private let keyPath: KeyPath<DependencyValues, Value>

    /// Creates an dependency property to read the specified key path.
    ///
    /// Don’t call this initializer directly. Instead, declare a property
    /// with the ``Dependency`` property wrapper, and provide the key path of
    /// the dependency value that the property should reflect:
    ///
    /// ```swift
    /// struct MyViewModel {
    ///     @Dependency(\.myCustomValue) var myCustomValue
    ///
    ///     // ...
    /// }
    /// ```
    ///
    /// - Parameter keyPath: A key path to a specific resulting value.
    public init(_ keyPath: KeyPath<DependencyValues, Value>) {
        self.keyPath = keyPath
    }

    /// The current value of the dependency property.
    ///
    /// The wrapped value property provides primary access to the value's data.
    /// However, you don't access `wrappedValue` directly. Instead, you read the
    /// property variable created with the ``Dependency`` property wrapper:
    ///
    /// ```swift
    /// @Dependency(\.myCustomValue) var myCustomValue
    ///
    /// func copy() {
    ///     print(myCustomValue) // prints "Default value"
    /// }
    /// ```
    public var wrappedValue: Value {
        DependencyValues.get(keyPath)
    }
}

// MARK: - DependencyValues

/// A collection of dependency values propagated using ``dependency`` property
/// wrapper.
///
/// A collection of values are exposed to your app's in an ``DependencyValues``
/// structure. To read a value from the structure, declare a property using the
/// ``Dependency`` property wrapper and specify the value's key path. For
/// example, you can read the current myCustomValue:
///
/// ```swift
/// @Dependency(\.myCustomValue) var myCustomValue
/// ```
public struct DependencyValues {
    static var shared = Self()
    var storage: [ObjectIdentifier: Any] = [:]

    // Subscripts setter on key-path calls getter of the destination property.
    // https://bugs.swift.org/browse/SR-10203
    private var isSetterOnKeyPathCalled = false

    /// Accesses the dependency value associated with a custom key.
    ///
    /// Create custom dependency values by defining a key that conforms to the
    /// ``DependencyKey`` protocol, and then using that key with the subscript
    /// operator of the ``DependencyValues`` structure to get and set a value for
    /// that key:
    ///
    /// ```swift
    /// extension DependencyValues {
    ///     private struct MyDependencyKey: DependencyKey {
    ///         static let defaultValue: String = "Default value"
    ///     }
    ///
    ///     var myCustomValue: String {
    ///         get { self[MyDependencyKey.self] }
    ///         set { self[MyDependencyKey.self] = newValue }
    ///     }
    /// }
    /// ```
    public subscript<K>(key: K.Type) -> K.Value where K: DependencyKey {
        get {
            let key = ObjectIdentifier(key)

            // If we have stored value for the given key, return and exit.
            if let value = storage[key] as? K.Value {
                return value
            }

            #if DEBUG
            // When we are calling set key path using
            // `DependencyValues.set(\.myCustomValue, "hello")` it invokes the getter first
            // and in testing mode it incorrectly fails the tests when trying to set the
            // dependency explicitly.
            // See: https://bugs.swift.org/browse/SR-10203
            if !isSetterOnKeyPathCalled {
                // If app is running in testing mode fail the test.
                if ProcessInfo.Arguments.isTesting {
                    let dependencyName = "\"\(K.Value.self)\""
                    let example = "\"DependencyValues.set(\\.pasteboard, .stub)\""
                    internal_XCTFail("You are trying to access \(dependencyName) dependency in this test case without assigning it. You can set this dependency as: \(example)")
                    return K.defaultValue
                }
            }
            #endif

            // If app is running in normal mode, return the `default` value.
            return K.defaultValue
        }
        set {
            storage[ObjectIdentifier(key)] = newValue
        }
    }

    @discardableResult
    public static func set<V>(_ keyPath: WritableKeyPath<Self, V>, _ value: V) -> Self {
        shared.isSetterOnKeyPathCalled = true
        shared[keyPath: keyPath] = value
        shared.isSetterOnKeyPathCalled = false
        return shared
    }

    @discardableResult
    public static func get<V>(_ keyPath: KeyPath<Self, V>) -> V {
        shared[keyPath: keyPath]
    }

    /// Reset all of the ``DependencyValues`` storage.
    public static func resetAll() {
        // We are clearing all of the dependencies, which will force next access to go
        // through the `getter` in the `subscript` function above.
        shared.storage = [:]
    }
}
