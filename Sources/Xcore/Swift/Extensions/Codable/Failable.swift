//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A container that holds failable value.
@dynamicMemberLookup
public struct Failable<Value>: Decodable where Value: Decodable {
    public let value: Value?

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Value.self)
        } catch {
            value = nil
        }
    }

    public subscript<T>(dynamicMember keyPath: KeyPath<Value, T>) -> T? {
        value?[keyPath: keyPath]
    }
}

extension Failable: Encodable where Value: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = value {
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}

// MARK: - Conditional Conformances

extension Failable: Equatable where Value: Equatable {}
extension Failable: Hashable where Value: Hashable {}
extension Failable: Sendable where Value: Sendable {}

extension Failable: Comparable where Value: Comparable {
    public static func <(lhs: Self, rhs: Self) -> Bool {
        guard let lhs = lhs.value else { return false }
        guard let rhs = rhs.value else { return false }
        return lhs < rhs
    }

    public static func >(lhs: Self, rhs: Self) -> Bool {
        guard let lhs = lhs.value else { return false }
        guard let rhs = rhs.value else { return false }
        return lhs > rhs
    }
}

extension Failable: CustomStringConvertible where Value: CustomStringConvertible {
    public var description: String {
        value?.description ?? "Optional(nil)"
    }
}

// MARK: - Array

extension Array {
    public func flatten<Value>() -> [Value] where Element == Failable<Value> {
        compactMap(\.value)
    }
}

// MARK: - JSONDecoder

extension JSONDecoder {
    /// The strategy to use for decoding collections.
    public enum FailableDecodingStrategy {
        /// Throw upon encountering non-decodable values. This is the default strategy.
        case `throw`

        /// Decodes values that are decodable and ignore the non-decodable values.
        case lenient
    }

    /// Decodes a top-level value of the given type from the given JSON representation.
    ///
    /// - Parameters:
    ///   - type: The type of the value to decode.
    ///   - data: The data to decode from.
    ///   - strategy: The strategy used to decode the given data.
    /// - Returns: A value of the requested type.
    /// - Throws: `DecodingError.dataCorrupted` if values requested from the payload
    ///   are corrupted, or if the given data is not valid JSON.
    /// - Throws: An error if any value throws an error during decoding.
    open func decode<T>(
        _ type: T.Type,
        from data: Data,
        strategy: FailableDecodingStrategy
    ) throws -> T where T: Decodable & InitializableBySequence, T.Element: Decodable {
        switch strategy {
            case .throw:
                return try decode(type, from: data)
            case .lenient:
                return T(try decode([Failable<T.Element>].self, from: data).flatten())
        }
    }
}
