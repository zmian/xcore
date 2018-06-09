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
    public enum MergingStrategy {
        case replaceExisting
        case keepExisting
    }

    /// Merges the given dictionary into this dictionary, using the given
    /// strategy to determine the value for any duplicate keys.
    ///
    /// Use the given strategy to select a value to use in the updated
    /// dictionary, or to combine existing and new values. As the key-values
    /// pairs in other are merged with this dictionary, the strategy is
    /// used to handle the duplicate keys that are encountered.
    ///
    /// - Parameters:
    ///   - other: A dictionary to merge.
    ///   - strategy: The strategy to use when duplicate keys are encountered. The default value is `.replaceExisting`.
    public mutating func merge(_ other: Dictionary, strategy: MergingStrategy = .replaceExisting) {
        switch strategy {
            case .replaceExisting:
                merge(other) { (_, new) in new }
            case .keepExisting:
                merge(other) { (current, _) in current }
        }
    }

    /// Creates a dictionary by merging the given dictionary into this dictionary,
    /// using the given strategy to determine the value for any duplicate keys.
    ///
    /// Use the given strategy to select a value to use in the returned
    /// dictionary, or to combine existing and new values. As the key-values
    /// pairs in other are merged with this dictionary, the strategy is
    /// used to handle the duplicate keys that are encountered.
    ///
    /// - Parameters:
    ///   - other: A dictionary to merge.
    ///   - strategy: The strategy to use when duplicate keys are encountered. The default value is `.replaceExisting`.
    /// - Returns: A new dictionary with the combined keys and values of this dictionary and other.
    public func merging(_ other: Dictionary, strategy: MergingStrategy = .replaceExisting) -> Dictionary {
        switch strategy {
            case .replaceExisting:
                return merging(other) { (_, new) in new }
            case .keepExisting:
                return merging(other) { (current, _) in current }
        }
    }

    /// Merges the given dictionary into this dictionary, using the given
    /// strategy to determine the value for any duplicate keys.
    ///
    /// Use the given strategy to select a value to use in the updated
    /// dictionary, or to combine existing and new values. As the key-values
    /// pairs in other are merged with this dictionary, the strategy is
    /// used to handle the duplicate keys that are encountered.
    ///
    /// - Parameters:
    ///   - other: A dictionary to merge.
    ///   - strategy: The strategy to use when duplicate keys are encountered. The default value is `.replaceExisting`.
    public mutating func merge(_ other: Dictionary?, strategy: MergingStrategy = .replaceExisting) {
        guard let other = other else {
            return
        }

        merge(other)
    }

    /// Creates a dictionary by merging the given dictionary into this dictionary,
    /// using the given strategy to determine the value for any duplicate keys.
    ///
    /// Use the given strategy to select a value to use in the returned
    /// dictionary, or to combine existing and new values. As the key-values
    /// pairs in other are merged with this dictionary, the strategy is
    /// used to handle the duplicate keys that are encountered.
    ///
    /// - Parameters:
    ///   - other: A dictionary to merge.
    ///   - strategy: The strategy to use when duplicate keys are encountered. The default value is `.replaceExisting`.
    /// - Returns: A new dictionary with the combined keys and values of this dictionary and other.
    public func merging(_ other: Dictionary?, strategy: MergingStrategy = .replaceExisting) -> Dictionary {
        guard let other = other else {
            return self
        }

        return merging(other)
    }
}

extension Dictionary where Key == String {
    /// Accesses the value associated with the given key for reading and writing.
    ///
    /// This *key-based* subscript returns the value for the given key if the key
    /// is found in the dictionary, or `nil` if the key is not found.
    ///
    /// The following example creates a new dictionary and prints the value of a
    /// key found in the dictionary (`"Coral"`) and a key not found in the
    /// dictionary (`"Cerise"`).
    ///
    ///     var hues = ["Heliotrope": 296, "Coral": 16, "Aquamarine": 156]
    ///     print(hues["Coral"])
    ///     // Prints "Optional(16)"
    ///     print(hues["Cerise"])
    ///     // Prints "nil"
    ///
    /// When you assign a value for a key and that key already exists, the
    /// dictionary overwrites the existing value. If the dictionary doesn't
    /// contain the key, the key and value are added as a new key-value pair.
    ///
    /// Here, the value for the key `"Coral"` is updated from `16` to `18` and a
    /// new key-value pair is added for the key `"Cerise"`.
    ///
    ///     hues["Coral"] = 18
    ///     print(hues["Coral"])
    ///     // Prints "Optional(18)"
    ///
    ///     hues["Cerise"] = 330
    ///     print(hues["Cerise"])
    ///     // Prints "Optional(330)"
    ///
    /// If you assign `nil` as the value for the given key, the dictionary
    /// removes that key and its associated value.
    ///
    /// In the following example, the key-value pair for the key `"Aquamarine"`
    /// is removed from the dictionary by assigning `nil` to the key-based
    /// subscript.
    ///
    ///     hues["Aquamarine"] = nil
    ///     print(hues)
    ///     // Prints "["Coral": 18, "Heliotrope": 296, "Cerise": 330]"
    ///
    /// - Parameter key: The key to find in the dictionary.
    /// - Returns: The value associated with `key` if `key` is in the dictionary;
    ///   otherwise, `nil`.
    public subscript<T: RawRepresentable>(key: T) -> Value? where T.RawValue == String {
        get { return self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
}

extension Dictionary where Value: Equatable {
    public func keys(forValue value: Value) -> [Key] {
        return filter { $1 == value }.map { $0.0 }
    }
}

// MARK: Operators

public func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]) -> [Key: Value] {
    return lhs.merging(rhs)
}

public func +<Key, Value> (lhs: [Key: Value], rhs: [Key: Value]?) -> [Key: Value] {
    guard let rhs = rhs else {
        return lhs
    }

    return lhs + rhs
}

public func +=<Key, Value>(lhs: inout [Key: Value], rhs: [Key: Value]) {
    lhs.merge(rhs)
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
