//
// PredicateRepresentable.swift
// Copyright © 2016 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

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

// MARK: - Array

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
        NSCompoundPredicate(type: type, subpredicates: self)
    }
}

// MARK: - No Match

extension NSPredicate {
    /// Creates and returns a predicate that never matches any result.
    public static var noMatch: NSPredicate {
        .init(value: false)
    }
}

extension NSPredicate: PredicateRepresentable {}
