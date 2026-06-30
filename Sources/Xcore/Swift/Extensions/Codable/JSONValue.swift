//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A JSON leaf or container value used by ``CodingFormatStyle``.
///
/// This type is not re-exported from Xcore. Prefer ``KeyedDecodingContainer`` and
/// ``KeyedEncodingContainer`` format-style APIs instead of using this type directly.
public struct JSONValue: Codable, Sendable, Equatable {
    enum Kind: Equatable {
        case null
        case bool(Bool)
        case int(Int)
        case uint(UInt)
        case double(Double)
        case string(String)
        case array([JSONValue])
        case object([String: JSONValue])
    }

    var kind: Kind

    init(_ value: (some Sendable)?) {
        kind = Self.makeKind(from: value ?? ())
    }

    static func from(_ value: some Sendable) -> Self {
        Self(value)
    }

    /// The underlying value used by flexible format styles such as ``MapDecodingFormatStyle``.
    var anyValue: Any {
        switch kind {
            case .null:
                NSNull()
            case let .bool(value):
                value
            case let .int(value):
                value
            case let .uint(value):
                value
            case let .double(value):
                value
            case let .string(value):
                value
            case let .array(values):
                values.map(\.anyValue)
            case let .object(values):
                values.mapValues(\.anyValue)
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            kind = .null
        } else if let string = try? container.decode(String.self) {
            kind = .string(string)
        } else if let int = try? container.decode(Int.self) {
            kind = .int(int)
        } else if let uint = try? container.decode(UInt.self) {
            kind = .uint(uint)
        } else if let double = try? container.decode(Double.self) {
            kind = .double(double)
        } else if let bool = try? container.decode(Bool.self) {
            kind = .bool(bool)
        } else if let array = try? container.decode([JSONValue].self) {
            kind = .array(array)
        } else if let object = try? container.decode([String: JSONValue].self) {
            kind = .object(object)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "JSONValue cannot be decoded"
            )
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch kind {
            case .null:
                try container.encodeNil()
            case let .bool(value):
                try container.encode(value)
            case let .int(value):
                try container.encode(value)
            case let .uint(value):
                try container.encode(value)
            case let .double(value):
                try container.encode(value)
            case let .string(value):
                try container.encode(value)
            case let .array(values):
                try container.encode(values)
            case let .object(values):
                try container.encode(values)
        }
    }

    private static func makeKind(from value: Any) -> Kind {
        switch value {
            case is Void:
                .null
            case is NSNull:
                .null
            case let value as Bool:
                .bool(value)
            case let value as Int:
                .int(value)
            case let value as Int8:
                .int(Int(value))
            case let value as Int16:
                .int(Int(value))
            case let value as Int32:
                .int(Int(value))
            case let value as Int64:
                .int(Int(value))
            case let value as UInt:
                .uint(value)
            case let value as UInt8:
                .uint(UInt(value))
            case let value as UInt16:
                .uint(UInt(value))
            case let value as UInt32:
                .uint(UInt(value))
            case let value as UInt64:
                .uint(UInt(value))
            case let value as Float:
                .double(Double(value))
            case let value as Double:
                .double(value)
            case let value as Decimal:
                fromEncodable(value).kind
            case let value as String:
                .string(value)
            case let value as URL:
                .string(value.absoluteString)
            case let value as [Any?]:
                .array(value.map { JSONValue($0) })
            case let value as [Any]:
                .array(value.map { JSONValue($0) })
            case let value as [String: Any?]:
                .object(value.mapValues { JSONValue($0) })
            case let value as [String: Any]:
                .object(value.mapValues { JSONValue($0) })
            case let value as Encodable:
                fromEncodable(value).kind
            default:
                .string(String(describing: value))
        }
    }

    private static func fromEncodable(_ value: Encodable) -> Self {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(AnyEncodableBox(value)) else {
            return JSONValue(kind: .string(String(describing: value)))
        }

        return (try? JSONDecoder().decode(JSONValue.self, from: data)) ?? JSONValue(kind: .string(String(describing: value)))
    }

    private init(kind: Kind) {
        self.kind = kind
    }
}

private struct AnyEncodableBox: Encodable {
    let value: Encodable

    init(_ value: Encodable) {
        self.value = value
    }

    func encode(to encoder: Encoder) throws {
        try value.encode(to: encoder)
    }
}

extension JSONValue {
    static var null: Self { JSONValue(kind: .null) }
    static func bool(_ value: Bool) -> Self { JSONValue(kind: .bool(value)) }
    static func int(_ value: Int) -> Self { JSONValue(kind: .int(value)) }
    static func uint(_ value: UInt) -> Self { JSONValue(kind: .uint(value)) }
    static func double(_ value: Double) -> Self { JSONValue(kind: .double(value)) }
    static func string(_ value: String) -> Self { JSONValue(kind: .string(value)) }
    static func array(_ value: [JSONValue]) -> Self { JSONValue(kind: .array(value)) }
    static func object(_ value: [String: JSONValue]) -> Self { JSONValue(kind: .object(value)) }
}
