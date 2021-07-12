//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public protocol ExtensibleByAssociatedObject {}

extension ExtensibleByAssociatedObject {
    /// Returns the value associated with a given object for a given key.
    ///
    /// - Parameter key: The key for the association.
    /// - Returns: The value associated with the key for object.
    public func associatedObject<T>(_ key: UnsafeRawPointer) -> T? {
        objc_getAssociatedObject(self, key) as? T
    }

    /// Returns the value associated with a given object for a given key.
    ///
    /// - Parameters:
    ///   - key: The key for the association.
    ///   - defaultValue: The default value to return if there is no associated
    ///     value.
    ///   - defaultValueAssociationPolicy: An optional value to save the
    ///     `defaultValue` so the next call will have the associated object.
    /// - Returns: The value associated with the key for object.
    public func associatedObject<T>(
        _ key: UnsafeRawPointer,
        default defaultValue: @autoclosure () -> T,
        policy defaultValueAssociationPolicy: AssociationPolicy? = nil
    ) -> T {
        guard let value = objc_getAssociatedObject(self, key) as? T else {
            let defaultValue = defaultValue()

            if let associationPolicy = defaultValueAssociationPolicy {
                setAssociatedObject(key, value: defaultValue, policy: associationPolicy)
            }

            return defaultValue
        }

        return value
    }

    /// Sets an associated value for a given object using a given key and
    /// association policy.
    ///
    /// - Parameters:
    ///   - key: The key for the association.
    ///   - value: The value to associate with the key for object. Pass `nil` to
    ///     remove an existing association.
    ///   - associationPolicy: The policy for the association. The default value is
    ///     `.strong`.
    public func setAssociatedObject<T>(
        _ key: UnsafeRawPointer,
        value: T?,
        policy associationPolicy: AssociationPolicy = .strong
    ) {
        objc_setAssociatedObject(self, key, value, associationPolicy.rawValue)
    }
}

// MARK: - AssociationPolicy

public enum AssociationPolicy {
    /// Specifies a weak reference to the associated object.
    case weak

    /// Specifies a strong reference to the associated object.
    ///
    /// The association is not made atomically.
    case strong

    /// Specifies a strong reference to the associated object.
    ///
    /// The association is made atomically.
    case strongAtomic

    /// Specifies that the associated object is copied.
    ///
    /// The association is not made atomically.
    case copy

    /// Specifies that the associated object is copied.
    ///
    /// The association is made atomically.
    case copyAtomic

    fileprivate var rawValue: objc_AssociationPolicy {
        switch self {
            case .weak:
                return .OBJC_ASSOCIATION_ASSIGN
            case .strong:
                return .OBJC_ASSOCIATION_RETAIN_NONATOMIC
            case .strongAtomic:
                return .OBJC_ASSOCIATION_RETAIN
            case .copy:
                return .OBJC_ASSOCIATION_COPY_NONATOMIC
            case .copyAtomic:
                return .OBJC_ASSOCIATION_COPY
        }
    }
}

extension NSObject: ExtensibleByAssociatedObject {}
