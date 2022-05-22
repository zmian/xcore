//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension JSONDecoder {
    /// Returns a value of the type you specify, decoded from a JSON object at the
    /// given key path.
    ///
    /// If the data isn’t valid JSON, this method throws the
    /// ``DecodingError.dataCorrupted(_:)`` error. If a value within the JSON fails
    /// to decode, this method throws the corresponding error.
    ///
    /// ```swift
    /// struct Person: Codable {
    ///     let name: String
    ///     let age: Int
    /// }
    ///
    /// let json = """
    /// {
    ///     "nested": {
    ///         "person": {
    ///             "name": "Sam",
    ///             "age": 8
    ///         }
    ///     }
    /// }
    /// """.data(using: .utf8)!
    ///
    /// let person = try JSONDecoder().decode(
    ///     Person.self, from: json, keyPath: "nested.person"
    /// )
    /// print(person.name) // Sam
    /// print(person.age) // 8
    /// ```
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode from the supplied JSON object.
    ///   - data: The JSON object to decode.
    ///   - keyPath: The JSON keypath of the type.
    /// - Returns: A value of the specified type, if the decoder can parse the data.
    public func decode<T>(
        _ type: T.Type,
        from data: Data,
        keyPath: KeyPathRepresentation
    ) throws -> T where T: Decodable {
        userInfo[.keyPath] = ArraySlice(keyPath.rawValue.components(separatedBy: keyPath.separator))
        return try decode(ValueWrapper<T>.self, from: data).value
    }
}

// MARK: - ValueWrapper

extension JSONDecoder {
    /// - SeeAlso: https://github.com/0111b/JSONDecoder-Keypath
    private final class ValueWrapper<T: Decodable>: Decodable {
        private typealias Container = KeyedDecodingContainer<Key>

        private enum Error: Swift.Error {
            case `internal`
        }

        private struct Key: CodingKey {
            let intValue: Int?
            let stringValue: String

            init?(intValue: Int) {
                self.intValue = intValue
                stringValue = String(intValue)
            }

            init?(stringValue: String) {
                self.stringValue = stringValue
                intValue = nil
            }
        }

        let value: T

        init(from decoder: Decoder) throws {
            guard
                let keyPath = decoder.userInfo[.keyPath] as? ArraySlice<String>,
                !keyPath.isEmpty
            else
            {
                throw Error.internal
            }

            func firstKey(from keyPath: ArraySlice<String>) throws -> Key {
                guard
                    let first = keyPath.first,
                    let key = Key(stringValue: first)
                else {
                    throw Error.internal
                }

                return key
            }

            /// Treverse the JSON object and return the key and container located at the
            /// last key path for the value.
            func valueContainer(
                for keyPath: ArraySlice<String>,
                in currentContainer: Container,
                key currentKey: Key
            ) throws -> (Container, Key) {
                guard !keyPath.isEmpty else {
                    return (currentContainer, currentKey)
                }

                let nextContainer = try currentContainer
                    .nestedContainer(keyedBy: Key.self, forKey: currentKey)
                let nextKey = try firstKey(from: keyPath)

                // Recursively find the last key path
                return try valueContainer(for: keyPath.dropFirst(), in: nextContainer, key: nextKey)
            }

            let rootKey = try firstKey(from: keyPath)
            let rootContainer = try decoder.container(keyedBy: Key.self)
            let (container, key) = try valueContainer(for: keyPath.dropFirst(), in: rootContainer, key: rootKey)
            value = try container.decode(T.self, forKey: key)
        }
    }
}

// MARK: - UserInfo

extension CodingUserInfoKey {
    fileprivate static var keyPath: Self {
        CodingUserInfoKey(rawValue: "xcore.keyPath")!
    }
}
