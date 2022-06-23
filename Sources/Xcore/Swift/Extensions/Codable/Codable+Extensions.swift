//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Appliable

extension JSONDecoder: Appliable {}
extension JSONEncoder: Appliable {}
extension PropertyListDecoder: Appliable {}
extension PropertyListEncoder: Appliable {}

// MARK: - KeyedDecodingContainer

extension KeyedDecodingContainer {
    /// Decodes a value of the given type for the given key.
    ///
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Returns: A value of the requested type, if present for the given key and
    ///   convertible to the requested type.
    public func decode<T>(_ key: Key) throws -> T where T: Decodable {
        try decode(T.self, forKey: key)
    }

    /// Decodes a value of the given type for the given key, if present.
    ///
    /// - Parameter key: The key that the decoded value is associated with.
    /// - Returns: A decoded value of the requested type, or `nil` if the Decoder
    ///   does not have an entry associated with the given key, or if the value is a
    ///   null value.
    public func decodeIfPresent<T: Decodable>(_ key: Key) throws -> T? {
        try decodeIfPresent(T.self, forKey: key)
    }

    /// Decodes a value of the given type for the given key using format style.
    ///
    /// - Parameters:
    ///   - key: The key that the decoded value is associated with.
    ///   - format: The format style used to decode the given key.
    /// - Returns: A value of the requested type, if present for the given key and
    ///   convertible to the requested type.
    public func decode<F: DecodingFormatStyle>(
        _ key: Key,
        format: F,
        file: StaticString = #fileID,
        line: UInt = #line
    ) throws -> F.Output where F.Input: Decodable {
        let value: F.Input = try decode(key)

        do {
            return try format.decode(value)
        } catch {
            debugLog(value, error, info: "Attempting to decode invalid value for \"\(key.stringValue)\".", file: file, line: line)
            throw error
        }
    }

    /// Decodes a value of the given type for the given key using format style, if
    /// present.
    ///
    /// - Parameters:
    ///   - key: The key that the decoded value is associated with.
    ///   - format: The format style used to decode the given key.
    /// - Returns: A decoded value of the requested type, or `nil` if the Decoder
    ///   does not have an entry associated with the given key, or if the value is a
    ///   null value.
    public func decodeIfPresent<F: DecodingFormatStyle>(
        _ key: Key,
        format: F,
        file: StaticString = #fileID,
        line: UInt = #line
    ) throws -> F.Output? where F.Input: Decodable {
        guard let value: F.Input = try decodeIfPresent(key) else {
            return nil
        }

        do {
            return try format.decode(value)
        } catch {
            debugLog(value, error, info: "Attempting to decode invalid value for \"\(key.stringValue)\".", file: file, line: line)
            throw error
        }
    }
}

// MARK: - KeyedEncodingContainer

extension KeyedEncodingContainer {
    /// Encodes the given value for the given key using format style.
    ///
    /// - Parameters:
    ///   - value: The value to encode.
    ///   - key: The key to associate the value with.
    ///   - format: The format style used to encode the given value.
    public mutating func encode<F: EncodingFormatStyle>(
        _ value: F.Output,
        forKey key: Key,
        format: F,
        file: StaticString = #fileID,
        line: UInt = #line
    ) throws where F.Input: Encodable {
        let formattedValue: F.Input

        do {
            formattedValue = try format.encode(value)
        } catch {
            debugLog(value, error, info: "Attempting to encode invalid value for \"\(key.stringValue)\".", file: file, line: line)
            throw error
        }

        try encode(formattedValue, forKey: key)
    }

    /// Encodes the given value for the given key using format style, if it is not
    /// `nil`.
    ///
    /// - Parameters:
    ///   - value: The value to encode.
    ///   - key: The key to associate the value with.
    ///   - format: The format style used to encode the given value.
    public mutating func encodeIfPresent<F: EncodingFormatStyle>(
        _ value: F.Output?,
        forKey key: Key,
        format: F,
        file: StaticString = #fileID,
        line: UInt = #line
    ) throws where F.Input: Encodable {
        guard let value = value else {
            return
        }

        let formattedValue: F.Input

        do {
            formattedValue = try format.encode(value)
        } catch {
            debugLog(value, error, info: "Attempting to encode invalid value for \"\(key.stringValue)\".", file: file, line: line)
            throw error
        }

        try encodeIfPresent(formattedValue, forKey: key)
    }
}
