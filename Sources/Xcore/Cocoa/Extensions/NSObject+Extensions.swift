//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension NSObject {
    var memoryAddress: String {
        String(describing: Unmanaged<NSObject>.passUnretained(self).toOpaque())
    }
}

extension NSObject {
    func synchronized<T>(_ work: () throws -> T) rethrows -> T {
        objc_sync_enter(self)
        defer { objc_sync_exit(self) }
        return try work()
    }
}

extension NSObject {
    /// Returns the value for the property identified by a given key.
    ///
    /// The search pattern that `valueForKey:` uses to find the correct value
    /// to return is described in **Accessor Search Patterns** in **Key-Value Coding
    /// Programming Guide**.
    ///
    /// - Parameter key: The name of one of the receiver's properties.
    /// - Returns: The value for the property identified by key.
    open func safeValue(forKey key: String) -> Any? {
        let mirror = Mirror(reflecting: self)

        for child in mirror.children.makeIterator() where child.label == key {
            return child.value
        }

        return nil
    }

    /// Return `true` if the `self` has the property of given `name`; otherwise,
    /// `false`.
    open func hasProperty(withName name: String) -> Bool {
        safeValue(forKey: name) != nil
    }
}

// MARK: - Lookup Comparison

extension NSObject {
    public enum LookupComparison {
        /// Indicates whether the receiver is an instance of given class or an instance
        /// of any class that inherits from that class.
        case kindOf

        /// The dynamic type.
        case typeOf
    }

    /// - Parameters:
    ///   - aClass: A class object representing the Objective-C class to be tested.
    ///   - comparison: The comparison option to use when comparing `self` to
    ///     `aClass`.
    /// - Returns: When option is `.kindOf` then this method returns true if
    ///   `aClass` is a Class object of the same type; otherwise, `.typeOf` does
    ///   direct check to ensure `aClass` is the same object and not a subclass.
    func isType(of aClass: Swift.AnyClass, comparison: LookupComparison) -> Bool {
        switch comparison {
            case .kindOf:
                return isKind(of: aClass)
            case .typeOf:
                return aClass.self == type(of: self)
        }
    }
}

// MARK: - Property List

extension NSObject {
    /// Returns a dictionary of the properties declared by the object.
    func propertyList() -> [String: String] {
        var count: UInt32 = 0

        guard let properties = class_copyPropertyList(object_getClass(self), &count) else {
            return [:]
        }

        var result = [String: String]()

        for i in 0..<count {
            let property = properties.advanced(by: Int(i)).pointee

            guard
                let cAttributes = property_getAttributes(property),
                let attributes = String(cString: cAttributes).components(separatedBy: ",").first
            else {
                continue
            }

            let name = String(cString: property_getName(property))
            result[name] = attributes.replacing("[\"T@]+", with: "")
        }

        free(properties)
        return result
    }
}
