//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import CoreGraphics

// MARK: - TypeInfo

extension Mirror {
    public struct TypeInfo: Sendable, Hashable {
        public let kind: Kind
        public let isOptional: Bool
        public let isCodable: Bool

        public init(kind: Kind, isOptional: Bool, isCodable: Bool) {
            self.kind = kind
            self.isOptional = isOptional
            self.isCodable = isCodable
        }
    }
}

// MARK: - Kind

extension Mirror.TypeInfo {
    public enum Kind: Sendable, Hashable {
        case void
        case string
        case bool
        case numeric(Numeric)
        case url
        case date
        case data
        case rawRepresentable(RawValue)
        case unknown

        public enum Numeric: Sendable, Hashable {
            case int
            case uint
            case float
            case double
        }

        public enum RawValue: Sendable, Hashable {
            case some
            case string
            case bool
            case numeric(Numeric)
        }
    }
}

// MARK: - Type of function

extension Mirror {
    public static func type<T>(of value: T) -> TypeInfo {
        let type = Swift.type(of: value)
        let anyType = Swift.type(of: value as Any)
        let isCodable = anyType is Codable.Type

        var kind: TypeInfo.Kind {
            switch anyType {
                case is Void.Type, is Void?.Type:
                    return .void
                case is Bool.Type, is Bool?.Type:
                    return .bool
                case is String.Type, is String?.Type:
                    return .string
                case is Int.Type, is Int?.Type,
                     is Int8.Type, is Int8?.Type,
                     is Int16.Type, is Int16?.Type,
                     is Int32.Type, is Int32?.Type,
                     is Int64.Type, is Int64?.Type:
                    return .numeric(.int)
                case is UInt.Type, is UInt?.Type,
                     is UInt8.Type, is UInt8?.Type,
                     is UInt16.Type, is UInt16?.Type,
                     is UInt32.Type, is UInt32?.Type,
                     is UInt64.Type, is UInt64?.Type:
                    return .numeric(.uint)
                case is Float.Type, is Float?.Type:
                    return .numeric(.float)
                case is Double.Type, is Double?.Type, is CGFloat.Type, is CGFloat?.Type:
                    return .numeric(.double)
                case is URL.Type, is URL?.Type:
                    return .url
                case is Date.Type, is Date?.Type:
                    return .date
                case is Data.Type, is Data?.Type:
                    return .data
                default:
                    if let result = rawRepresentableRawValueType(type.self) {
                        return .rawRepresentable(result)
                    }

                    // TODO: Fix
                    // Doesn't work when `rawRepresentable` is a property and the parent children
                    // are returned using `Mirror(reflecting:)`.
                    // See: `MirrorTests.testWithMirror` test case.
                    //
                    // else if let result = rawRepresentableRawValue(anyType) {
                    //     return .rawRepresentable(result)
                    // }

                    return .unknown
            }
        }

        return .init(kind: kind, isOptional: isOptional(value), isCodable: isCodable)
    }

    /// Returns `true` when given value is optional; otherwise, `false`.
    ///
    /// - Parameter value: The value for which to check if is of type ``Optional``.
    public static func isOptional<T>(_ value: T) -> Bool {
        value is OptionalMarker
    }
}

// Credit: https://forums.swift.org/t/35479/36

private protocol Conforming {}
private protocol ConformingOptional {}
private protocol ConformingOptional2 {}
private protocol ConformingOptional2Optional {}

// ConformanceMarker
private protocol ConformanceMarker {}
extension ConformanceMarker {
    static var conforms: Bool {
        Self.self is Conforming.Type ||
            Self.self is ConformingOptional.Type ||
            Self.self is ConformingOptional2.Type ||
            Self.self is ConformingOptional2Optional.Type
    }
}

private enum RawRepresentableMarker<T>: ConformanceMarker {}
private enum StringRawRepresentableMarker<T>: ConformanceMarker {}
private enum IntRawRepresentableMarker<T>: ConformanceMarker {}
private enum UIntRawRepresentableMarker<T>: ConformanceMarker {}
private enum FloatRawRepresentableMarker<T>: ConformanceMarker {}
private enum DoubleRawRepresentableMarker<T>: ConformanceMarker {}
private enum CGFloatRawRepresentableMarker<T>: ConformanceMarker {}
private enum BoolRawRepresentableMarker<T>: ConformanceMarker {}

// MARK: - RawRepresentableMarker

extension RawRepresentableMarker: Conforming where T: RawRepresentable {}
extension RawRepresentableMarker: ConformingOptional2 where T: OptionalType, T.Wrapped: RawRepresentable {}
// StringRawRepresentableMarker
// - enum Color: String { case red, green, blue }
// - StringRawRepresentableMarker<Color>.self
extension StringRawRepresentableMarker: Conforming where T: RawRepresentable, T.RawValue == String {}
// - struct Color: RawRepresentable { let rawValue: String? }
// - StringRawRepresentableMarker<Color>.self
extension StringRawRepresentableMarker: ConformingOptional where T: RawRepresentable, T.RawValue == String? {}
// - enum Color: String { case red, green, blue }
// - StringRawRepresentableMarker<Optional<Color>>.self
extension StringRawRepresentableMarker: ConformingOptional2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == String {}
// - struct Color: RawRepresentable { let rawValue: String? }
// - StringRawRepresentableMarker<Optional<Color>>.self
extension StringRawRepresentableMarker: ConformingOptional2Optional where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == String? {}
// IntRawRepresentableMarker
extension IntRawRepresentableMarker: Conforming where T: RawRepresentable, T.RawValue == Int {}
extension IntRawRepresentableMarker: ConformingOptional where T: RawRepresentable, T.RawValue == Int? {}
extension IntRawRepresentableMarker: ConformingOptional2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Int {}
extension IntRawRepresentableMarker: ConformingOptional2Optional where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Int? {}
// UIntRawRepresentableMarker
extension UIntRawRepresentableMarker: Conforming where T: RawRepresentable, T.RawValue == UInt {}
extension UIntRawRepresentableMarker: ConformingOptional where T: RawRepresentable, T.RawValue == UInt? {}
extension UIntRawRepresentableMarker: ConformingOptional2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == UInt {}
extension UIntRawRepresentableMarker: ConformingOptional2Optional where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == UInt? {}
// FloatRawRepresentableMarker
extension FloatRawRepresentableMarker: Conforming where T: RawRepresentable, T.RawValue == Float {}
extension FloatRawRepresentableMarker: ConformingOptional where T: RawRepresentable, T.RawValue == Float? {}
extension FloatRawRepresentableMarker: ConformingOptional2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Float {}
extension FloatRawRepresentableMarker: ConformingOptional2Optional where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Float? {}
// DoubleRawRepresentableMarker
extension DoubleRawRepresentableMarker: Conforming where T: RawRepresentable, T.RawValue == Double {}
extension DoubleRawRepresentableMarker: ConformingOptional where T: RawRepresentable, T.RawValue == Double? {}
extension DoubleRawRepresentableMarker: ConformingOptional2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Double {}
extension DoubleRawRepresentableMarker: ConformingOptional2Optional where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Double? {}
// CGFloatRawRepresentableMarker
extension CGFloatRawRepresentableMarker: Conforming where T: RawRepresentable, T.RawValue == CGFloat {}
extension CGFloatRawRepresentableMarker: ConformingOptional where T: RawRepresentable, T.RawValue == CGFloat? {}
extension CGFloatRawRepresentableMarker: ConformingOptional2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == CGFloat {}
extension CGFloatRawRepresentableMarker: ConformingOptional2Optional where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == CGFloat? {}
// BoolRawRepresentableMarker
extension BoolRawRepresentableMarker: Conforming where T: RawRepresentable, T.RawValue == Bool {}
extension BoolRawRepresentableMarker: ConformingOptional where T: RawRepresentable, T.RawValue == Bool? {}
extension BoolRawRepresentableMarker: ConformingOptional2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Bool {}
extension BoolRawRepresentableMarker: ConformingOptional2Optional where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Bool? {}

private func rawRepresentableRawValueType<T>(_ t: T.Type) -> Mirror.TypeInfo.Kind.RawValue? {
    if StringRawRepresentableMarker<T>.conforms {
        return .string
    } else if IntRawRepresentableMarker<T>.conforms {
        return .numeric(.int)
    } else if UIntRawRepresentableMarker<T>.conforms {
        return .numeric(.uint)
    } else if FloatRawRepresentableMarker<T>.conforms {
        return .numeric(.float)
    } else if DoubleRawRepresentableMarker<T>.conforms {
        return .numeric(.double)
    } else if CGFloatRawRepresentableMarker<T>.conforms {
        // Map CGFloat to Double
        // https://github.com/apple/swift-evolution/blob/main/proposals/0307-allow-interchangeable-use-of-double-cgfloat-types.md
        return .numeric(.double)
    } else if BoolRawRepresentableMarker<T>.conforms {
        return .bool
    } else if RawRepresentableMarker<T>.conforms {
        return .some
    } else {
        return nil
    }
}

private func rawRepresentableRawValue<T>(_ t: T) -> Mirror.TypeInfo.Kind.RawValue? {
    rawRepresentableRawValueType(type(of: t))
}

// MARK: - OptionalMarker

private protocol OptionalMarker {}
extension Optional: OptionalMarker {}
