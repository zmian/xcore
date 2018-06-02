//
// Dictionary+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
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

extension Dictionary {
    public mutating func combine(_ other: Dictionary) {
        other.forEach { updateValue($1, forKey: $0) }
    }

    public func combined(_ other: Dictionary) -> Dictionary {
        var dictionary = self
        dictionary.combine(other)
        return dictionary
    }

    public mutating func combine(_ other: Dictionary?) {
        guard let otherDictionary = other else { return }
        combine(otherDictionary)
    }

    public func combined(_ other: Dictionary?) -> Dictionary {
        var dictionary = self
        dictionary.combine(other)
        return dictionary
    }
}

extension Dictionary where Value: Equatable {
    public func keys(forValue value: Value) -> [Key] {
        return filter { $1 == value }.map { $0.0 }
    }
}

// MARK: Operators

public func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    return lhs.combined(rhs)
}

public func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]?) -> [Key: Value] {
    guard let rhs = rhs else {
        return lhs
    }

    return lhs + rhs
}

public func +=<Key, Value>(lhs: inout [Key: Value], rhs: [Key: Value]) {
    lhs.combine(rhs)
}

// MARK: Equatable

public func ==<Key, Value>(lhs: [Key: Value?], rhs: [Key: Value?]) -> Bool {
    guard let lhs = lhs as? [Key: Value], let rhs = rhs as? [Key: Value] else {
        return false
    }

    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}

// MARK: OptionalType

// Credit: https://stackoverflow.com/a/45462046

public protocol OptionalType {
    associatedtype Wrapped
    var wrapped: Wrapped? { get }
}

extension Optional: OptionalType {
    public var wrapped: Wrapped? {
        return self
    }
}

extension Dictionary where Value: OptionalType {
    /// Removes `nil` values from `self`.
    public func flatten() -> [Key: Value.Wrapped] {
        var result: [Key: Value.Wrapped] = [:]
        for (key, value) in self {
            guard let value = value.wrapped else {
                continue
            }
            result[key] = value
        }
        return result
    }
}
