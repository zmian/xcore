//
// PredicateRepresentable.swift
//
// Copyright © 2016 Xcore
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

extension NSPredicate {
    /// Creates and returns a predicate that never matches any result.
    public static var noMatch: NSPredicate {
        return NSPredicate(value: false)
    }
}

extension Array where Element: NSPredicate {
    /// Returns a new predicate by joining the elements of the sequence by the given
    /// logical type.
    ///
    /// Uses `NSCompoundPredicate` to create an `AND` or `OR` compound predicate of
    /// zero or more other predicates, or the NOT of a single predicate. For the
    /// logical `AND` and `OR` operations:
    ///
    /// - An `AND` predicate with no subpredicates evaluates to `true`.
    /// - An `OR` predicate with no subpredicates evaluates to `false`.
    /// - A compound predicate with one or more subpredicates evaluates to the truth
    ///   of its subpredicates.
    ///
    /// - Parameter type: The logical type used to join the elements in `self`.
    /// - Returns: A specialized predicate that evaluates logical combinations of
    ///            other predicates.
    public func joined(by type: NSCompoundPredicate.LogicalType) -> NSPredicate {
        return NSCompoundPredicate(type: type, subpredicates: self)
    }
}

extension NSPredicate: PredicateRepresentable {}

public protocol PredicateRepresentable {
    init(format predicateFormat: String, argumentArray arguments: [Any]?)
}

extension PredicateRepresentable {
    public init(field: String, equal value: Any, caseInsensitive: Bool = false) {
        let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
        self.init(format: "%K ==\(caseInsensitiveModifier) %@", argumentArray: [field, value])
    }

    public init(field: String, notEqual value: Any, caseInsensitive: Bool = false) {
        let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
        self.init(format: "%K !=\(caseInsensitiveModifier) %@", argumentArray: [field, value])
    }

    public init(field: String, any value: Any) {
        self.init(format: "ANY %K = %@", argumentArray: [field, value])
    }

    public init(field: String, lessThan value: Any) {
        self.init(format: "%K < %@", argumentArray: [field, value])
    }

    public init(field: String, lessThanOrEqual value: Any) {
        self.init(format: "%K <= %@", argumentArray: [field, value])
    }

    public init(field: String, greaterThan value: Any) {
        self.init(format: "%K > %@", argumentArray: [field, value])
    }

    public init(field: String, greaterThanOrEqual value: Any) {
        self.init(format: "%K >= %@", argumentArray: [field, value])
    }

    public init(field: String, beginsWith value: Any) {
        self.init(format: "%K BEGINSWITH[c] %@", argumentArray: [field, value])
    }

    public init(field: String, endsWith value: Any) {
        self.init(format: "%K ENDSWITH[c] %@", argumentArray: [field, value])
    }

    public init(field: String, contains value: Any) {
        self.init(format: "%K CONTAINS[c] %@", argumentArray: [field, value])
    }

    public init(field: String, like value: Any) {
        self.init(format: "%K LIKE[c] %@", argumentArray: [field, value])
    }

    public init(field: String, between this: Any, and that: Any) {
        self.init(format: "%K BETWEEN {%@, %@}", argumentArray: [field, this, that])
    }

    public init(field: String, in values: [Any], caseInsensitive: Bool = false) {
        let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
        self.init(format: "%K IN\(caseInsensitiveModifier) %@", argumentArray: [field, values])
    }

    public init(field: String, notIn values: [Any], caseInsensitive: Bool = false) {
        let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
        self.init(format: "NOT (%K IN\(caseInsensitiveModifier) %@)", argumentArray: [field, values])
    }
}
