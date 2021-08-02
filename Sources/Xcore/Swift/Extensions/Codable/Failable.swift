//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing empty value.
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
