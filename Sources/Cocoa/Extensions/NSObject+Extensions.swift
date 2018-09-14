//
// NSObject+Extensions.swift
//
// Copyright © 2018 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

extension NSObject {
    /// Returns the value for the property identified by a given key.
    ///
    /// The search pattern that `valueForKey:` uses to find the correct value
    /// to return is described in **Accessor Search Patterns** in **Key-Value Coding Programming Guide**.
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

    /// Return `true` if the `self` has the property of given `name`; otherwise, `false`.
    open func hasProperty(withName name: String) -> Bool {
        return safeValue(forKey: name) != nil
    }
}

// MARK: LookupComparison

extension NSObject {
    public enum LookupComparison {
        /// Indicates whether the receiver is an instance of given class or an
        /// instance of any class that inherits from that class.
        case kindOf

        /// The dynamic type.
        case typeOf
    }

    /// - Parameters:
    ///   - aClass: A class object representing the Objective-C class to be tested.
    ///   - comparison: The comparison option to use when comparing `self` to `aClass`.
    ///
    /// - Returns: When option is `.kindOf` then this method returns true if `aClass` is a Class object of the same type.
    ///            Otherwise, `.typeOf` does direct check to ensure `aClass` is the same object and not a subclass.
    public func isType(of aClass: Swift.AnyClass, comparison: LookupComparison) -> Bool {
        switch comparison {
            case .kindOf:
                return isKind(of: aClass)
            case .typeOf:
                return aClass.self == type(of: self)
        }
    }
}

// MARK: Property List

extension NSObject {
    /// Returns a dictionary of the properties declared by the object.
    public func propertyList() -> [String: String] {
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
            result[name] = attributes.replace("[\"T@]+", with: "")
        }

        free(properties)
        return result
    }
}
