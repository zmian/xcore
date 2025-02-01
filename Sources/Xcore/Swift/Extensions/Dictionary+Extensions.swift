//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Typealiases

/// A dictionary where values conform to both `Encodable` and `Sendable`.
public typealias EncodableDictionary = [String: Encodable & Sendable]

// MARK: - Merging

extension Dictionary {
    /// Defines strategies for merging dictionaries when encountering duplicate
    /// keys.
    public enum DuplicateKeyMergeStrategy {
        /// Replaces the existing value with the new value from the merging dictionary.
        case replaceExisting

        /// Keeps the existing value and ignores the new value from the merging
        /// dictionary.
        case keepExisting
    }

    /// Merges another dictionary into `self`, resolving conflicts using the given
    /// strategy.
    ///
    /// - Parameters:
    ///   - other: A dictionary to merge into this dictionary.
    ///   - strategy: The merging strategy to handle duplicate keys.
    public mutating func merge(
        _ other: Dictionary,
        strategy: DuplicateKeyMergeStrategy = .replaceExisting
    ) {
        switch strategy {
            case .replaceExisting:
                merge(other) { _, new in new }
            case .keepExisting:
                merge(other) { current, _ in current }
        }
    }

    /// Returns a new dictionary by merging another dictionary into `self`,
    /// resolving conflicts using the given strategy.
    ///
    /// - Parameters:
    ///   - other: A dictionary to merge.
    ///   - strategy: The merging strategy to handle duplicate keys.
    /// - Returns: A new dictionary containing the merged values.
    public func merging(
        _ other: Dictionary,
        strategy: DuplicateKeyMergeStrategy = .replaceExisting
    ) -> Dictionary {
        switch strategy {
            case .replaceExisting:
                return merging(other) { _, new in new }
            case .keepExisting:
                return merging(other) { current, _ in current }
        }
    }
}

// MARK: - Subscript for RawRepresentable Keys

extension Dictionary {
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
    public subscript<T: RawRepresentable>(key: T) -> Value? where T.RawValue == Key {
        get { self[key.rawValue] }
        set { self[key.rawValue] = newValue }
    }
}

// MARK: - Finding Keys by Value

extension Dictionary where Value: Equatable {
    /// Returns an array of keys that map to a given value.
    ///
    /// - Parameter value: The value to find in the dictionary.
    /// - Returns: An array of keys associated with the given value.
    public func keys(forValue value: Value) -> [Key] {
        filter { $1 == value }.map(\.key)
    }
}

// MARK: - Transforming Dictionary Keys

extension Dictionary where Key: RawRepresentable, Key.RawValue: Hashable {
    /// Returns a dictionary containing the results of mapping over the sequence's
    /// key value pairs.
    ///
    /// In this example, `mapPairs` is used to convert the parameter dictionary keys
    /// to their corresponding raw values.
    ///
    /// ```swift
    /// enum Keys: String {
    ///     case name = "full_name"
    ///     case age
    ///     case language
    /// }
    ///
    /// var parameter: [Keys: Any] = [
    ///     .name: "Vivien",
    ///     .age: 21,
    ///     .language: "English"
    /// ]
    ///
    /// let result = parameter.mapPairs()
    ///
    /// //  'result' [String: Any] = [
    /// //     "full_name": "Vivien",
    /// //     "age": 21,
    /// //     "language": "English"
    /// // ]
    /// ```
    ///
    /// - Returns: A dictionary containing the transformed key value pairs.
    public func mapPairs() -> [Key.RawValue: Value] {
        mapPairs { ($0.key.rawValue, $0.value) }
    }
}

// MARK: - Transform

extension Dictionary {
    /// Returns a dictionary containing the results of mapping the given closure
    /// over the sequence's key value pairs.
    ///
    /// In this example, `mapPairs` is used to convert the parameter dictionary keys
    /// to their corresponding raw values.
    ///
    /// ```swift
    /// enum Keys: String {
    ///     case name = "full_name"
    ///     case age
    ///     case language
    /// }
    ///
    /// let parameter: [Keys: Any] = [
    ///     .name: "Vivien",
    ///     .age: 21,
    ///     .language: "English"
    /// ]
    ///
    /// let result = parameter.mapPairs { ($0.key.rawValue, $0.value) }
    ///
    /// //  'result' [String: Any] = [
    /// //     "full_name": "Vivien",
    /// //     "age": 21,
    /// //     "language": "English"
    /// // ]
    /// ```
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an element of
    ///   this sequence as its parameter and returns a transformed value of the same
    ///   or of a different type.
    /// - Returns: A dictionary containing the transformed key value pairs.
    public func mapPairs<K: Hashable, T>(_ transform: (Element) throws -> (K, T)) rethrows -> [K: T] {
        [K: T](uniqueKeysWithValues: try map(transform))
    }

    /// Returns an array containing the non-nil results of calling the given
    /// transformation with each element of this sequence.
    ///
    /// In this example, `compactMapPairs` is used to convert the parameter
    /// dictionary keys to their corresponding raw values.
    ///
    /// ```swift
    /// enum Keys: String {
    ///     case name = "full_name"
    ///     case age
    ///     case language
    /// }
    ///
    /// let parameter: [Keys: String?] = [
    ///     .name: "Vivien",
    ///     .age: nil,
    ///     .language: "English"
    /// ]
    ///
    /// let result: [String: String?] = parameter.compactMapPairs {
    ///     if $0.value == nil {
    ///         return nil
    ///     }
    ///
    ///     return ($0.key.rawValue, $0.value)
    /// }
    ///
    /// //  'result' [String: String] = [
    /// //     "full_name": "Vivien",
    /// //     "language": "English"
    /// // ]
    /// ```
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as
    ///   its argument and returns an optional value.
    /// - Returns: A dictionary containing the transformed key value pairs.
    public func compactMapPairs<K: Hashable, T>(_ transform: (Element) throws -> (K, T)?) rethrows -> [K: T] {
        [K: T](uniqueKeysWithValues: try compactMap(transform))
    }

    /// Returns a dictionary containing, in order, the elements of the sequence that
    /// satisfy the given predicate.
    ///
    /// In this example, `filterPairs` is used to include filter out key named
    /// `"age"`.
    ///
    /// ```swift
    /// let parameter: [String: Any] = [
    ///     "name": "Vivien",
    ///     "age": 21,
    ///     "language": "English"
    /// ]
    ///
    /// let result = parameter.filterPairs { $0.key != "age" }
    ///
    /// // `result`: [String: Any] = [
    /// //     "name": "Vivien",
    /// //     "language": "English"
    /// // ]
    /// ```
    ///
    /// - Parameter includeElement: A closure that takes an element of the sequence
    ///   as its argument and returns a Boolean value indicating whether the element
    ///   should be included in the returned dictionary.
    /// - Returns: An array of the elements that `isIncluded` allowed.
    /// - Complexity: O(_n_), where _n_ is the length of the sequence.
    public func filterPairs(_ includeElement: (Element) throws -> Bool) rethrows -> [Key: Value] {
        Dictionary(uniqueKeysWithValues: try filter(includeElement))
    }
}

// MARK: - Compacted

extension Dictionary where Value: OptionalProtocol {
    /// Returns a dictionary with non-nil values.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let dict: [String: String?] = ["a": "Hello", "b": nil, "c": "World"]
    /// let compacted = dict.compacted()
    /// print(compacted) // ["a": "Hello", "c": "World"]
    /// ```
    ///
    /// - Returns: A dictionary containing only non-nil values.
    public func compacted() -> [Key: Value.Wrapped] {
        reduce(into: [Key: Value.Wrapped]()) { result, element in
            if let value = element.value.wrapped {
                result[element.key] = value
            }
        }
    }
}

// MARK: - Equatable

public func == <Key, Value>(lhs: [Key: Value?], rhs: [Key: Value?]) -> Bool {
    guard let lhs = lhs as? [Key: Value], let rhs = rhs as? [Key: Value] else {
        return false
    }

    return NSDictionary(dictionary: lhs).isEqual(to: rhs)
}
