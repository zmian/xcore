//
// PredicateQuery.swift
//
// Copyright © 2016 Zeeshan Mian
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

private enum PredicateQueryBuilder {
    case boolEqual(field: String, value: Bool)
    case equal(field: String, values: [Any], caseInsensitive: Bool)
    case notEqual(field: String, values: [Any], caseInsensitive: Bool)
    case lessThanOrEqual(field: String, value: Any)
    case greaterThanOrEqual(field: String, value: Any)
    case beginsWith(field: String, value: Any)
    case endsWith(field: String, value: Any)
    case contains(field: String, value: Any)
    case like(field: String, value: Any)
    case between(field: String, value: (this: Any, andThis: Any))
    case notIn(field: String, values: [Any])
    case isIn(field: String, values: [Any], caseInsensitive: Bool)
    case any(field: String, value: Any)
    case boolAny(field: String, value: Bool)

    var rawValue: NSPredicate {
        switch self {
            case .boolEqual(let (field, value)):
                return NSPredicate(format: "\(field) == \(value ? "YES" : "NO")")
            case .equal(let (field, values, caseInsensitive)):
                if values.count == 1 {
                    let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
                    return NSPredicate(format: "\(field) ==\(caseInsensitiveModifier) %@", argumentArray: [values.first!])
                }

                return PredicateQueryBuilder.isIn(field: field, values: values, caseInsensitive: caseInsensitive).rawValue
            case .notEqual(let (field, values, caseInsensitive)):
                let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
                let formattedString = values.map { NSPredicate(format: "\(field) !=\(caseInsensitiveModifier) %@", argumentArray: [$0]).predicateFormat }.joined(separator: " AND ")
                return NSPredicate(format: formattedString)
            case .lessThanOrEqual(let (field, value)):
                return NSPredicate(format: "\(field) <= %@", argumentArray: [value])
            case .greaterThanOrEqual(let (field, value)):
                return NSPredicate(format: "\(field) >= %@", argumentArray: [value])
            case .beginsWith(let (field, value)):
                return NSPredicate(format: "\(field) BEGINSWITH[c] %@", argumentArray: [value])
            case .endsWith(let (field, value)):
                return NSPredicate(format: "\(field) ENDSWITH[c] %@", argumentArray: [value])
            case .contains(let (field, value)):
                return NSPredicate(format: "\(field) CONTAINS[c] %@", argumentArray: [value])
            case .like(let (field, value)):
                return NSPredicate(format: "\(field) LIKE[c] %@", argumentArray: [value])
            case .between(let (field, value)):
                return NSPredicate(format: "\(field) BETWEEN {%@, %@}", argumentArray: [value.this, value.andThis])
            case .notIn(let (field, values)):
                return NSPredicate(format: "NOT (\(field) IN %@)", argumentArray: [values])
            case .isIn(let (field, values, caseInsensitive)):
                let caseInsensitiveModifier = caseInsensitive ? "[c]" : ""
                return NSPredicate(format: "\(field) IN\(caseInsensitiveModifier) %@", values)
            case .any(let (field, value)):
                return NSPredicate(format: "ANY \(field) = %@", argumentArray: [value])
            case .boolAny(let (field, value)):
                return NSPredicate(format: "ANY \(field) = \(value ? "YES" : "NO")")
        }
    }
}

public struct PredicateQuery: CustomStringConvertible, CustomDebugStringConvertible {
    private let builder: PredicateQueryBuilder

    public init(field: String, equal: Any, caseInsensitive: Bool) {
        builder = PredicateQueryBuilder.equal(field: field, values: [equal], caseInsensitive: caseInsensitive)
    }

    public init(field: String, equal: Any...) {
        builder = PredicateQueryBuilder.equal(field: field, values: equal, caseInsensitive: false)
    }

    public init(field: String, equal: [Any], caseInsensitive: Bool = false) {
        builder = PredicateQueryBuilder.equal(field: field, values: equal, caseInsensitive: caseInsensitive)
    }

    public init(field: String, notEqual: Any, caseInsensitive: Bool) {
        builder = PredicateQueryBuilder.notEqual(field: field, values: [notEqual], caseInsensitive: caseInsensitive)
    }

    public init(field: String, notEqual: Any...) {
        builder = PredicateQueryBuilder.notEqual(field: field, values: notEqual, caseInsensitive: false)
    }

    public init(field: String, notEqual: [Any], caseInsensitive: Bool) {
        builder = PredicateQueryBuilder.notEqual(field: field, values: notEqual, caseInsensitive: caseInsensitive)
    }

    public init(field: String, lessThanOrEqual: Any) {
        builder = PredicateQueryBuilder.lessThanOrEqual(field: field, value: lessThanOrEqual)
    }

    public init(field: String, greaterThanOrEqual: Any) {
        builder = PredicateQueryBuilder.greaterThanOrEqual(field: field, value: greaterThanOrEqual)
    }

    public init(field: String, beginsWith: Any) {
        builder = PredicateQueryBuilder.beginsWith(field: field, value: beginsWith)
    }

    public init(field: String, endsWith: Any) {
        builder = PredicateQueryBuilder.endsWith(field: field, value: endsWith)
    }

    public init(field: String, contains: Any) {
        builder = PredicateQueryBuilder.contains(field: field, value: contains)
    }

    public init(field: String, like: Any) {
        builder = PredicateQueryBuilder.like(field: field, value: like)
    }

    public init(field: String, between: Any, and: Any) {
        builder = PredicateQueryBuilder.between(field: field, value: (between, and))
    }

    public init(field: String, notIn: [Any]) {
        builder = PredicateQueryBuilder.notIn(field: field, values: notIn)
    }

    public init(field: String, isIn: [Any], caseInsensitive: Bool = false) {
        builder = PredicateQueryBuilder.isIn(field: field, values: isIn, caseInsensitive: caseInsensitive)
    }

    public init(field: String, any: Any) {
        builder = PredicateQueryBuilder.any(field: field, value: any)
    }

    public init(field: String, any: Bool) {
        builder = PredicateQueryBuilder.boolAny(field: field, value: any)
    }

    public init(field: String, equal: Bool) {
        builder = PredicateQueryBuilder.boolEqual(field: field, value: equal)
    }

    public var rawValue: NSPredicate {
        return builder.rawValue
    }

    public var description: String {
        return rawValue.description
    }

    public var debugDescription: String {
        return rawValue.debugDescription
    }
}
