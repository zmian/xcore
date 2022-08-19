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

    @inlinable
    @discardableResult
    func synchronized<Result>(_ work: () throws -> Result) rethrows -> Result {
        if let recursiveLock = self as? NSRecursiveLock {
            recursiveLock.lock()
            defer { recursiveLock.unlock() }
            return try work()
        } else {
            objc_sync_enter(self)
            defer { objc_sync_exit(self) }
            return try work()
        }
    }
}

// MARK: - Lookup Comparison

extension NSObject {
    /// An enumeration representing the method for comparison.
    public enum LookupComparison {
        /// Indicates whether the receiver is an instance of given class or an instance
        /// of any class that inherits from that class.
        case kindOf

        /// The dynamic type.
        case typeOf
    }

    /// Returns a Boolean value indicating whether the receiver is a type of given
    /// class using the provided comparison lookup method.
    ///
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
