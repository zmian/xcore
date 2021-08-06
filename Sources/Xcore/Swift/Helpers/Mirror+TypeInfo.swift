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
        let isCodable = type is Codable.Type

        var kind: TypeInfo.Kind {
            switch type {
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

private enum RawRepresentableMarker<T> {}
private enum StringRawRepresentableMarker<T> {}
private enum IntRawRepresentableMarker<T> {}
private enum UIntRawRepresentableMarker<T> {}
private enum FloatRawRepresentableMarker<T> {}
private enum DoubleRawRepresentableMarker<T> {}
private enum CGFloatRawRepresentableMarker<T> {}
private enum BoolRawRepresentableMarker<T> {}

// ConformanceMarker
private protocol ConformanceMarker {}
private protocol OptionalConformanceMarker {}
private protocol ConformanceMarker2 {}
private protocol OptionalConformanceMarker2 {}

// MARK: - RawRepresentableMarker

extension RawRepresentableMarker: ConformanceMarker where T: RawRepresentable {}
extension RawRepresentableMarker: OptionalConformanceMarker where T: OptionalType, T.Wrapped: RawRepresentable {}
// StringRawRepresentableMarker
// - enum Color: String { case red, green, blue }
// - StringRawRepresentableMarker<Color>.self
extension StringRawRepresentableMarker: ConformanceMarker where T: RawRepresentable, T.RawValue == String {}
// - struct Color: RawRepresentable { let rawValue: String? }
// - StringRawRepresentableMarker<Color>.self
extension StringRawRepresentableMarker: ConformanceMarker2 where T: RawRepresentable, T.RawValue == String? {}
// - enum Color: String { case red, green, blue }
// - StringRawRepresentableMarker<Optional<Color>>.self
extension StringRawRepresentableMarker: OptionalConformanceMarker where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == String {}
// - struct Color: RawRepresentable { let rawValue: String? }
// - StringRawRepresentableMarker<Optional<Color>>.self
extension StringRawRepresentableMarker: OptionalConformanceMarker2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == String? {}
// IntRawRepresentableMarker
extension IntRawRepresentableMarker: ConformanceMarker where T: RawRepresentable, T.RawValue == Int {}
extension IntRawRepresentableMarker: ConformanceMarker2 where T: RawRepresentable, T.RawValue == Int? {}
extension IntRawRepresentableMarker: OptionalConformanceMarker where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Int {}
extension IntRawRepresentableMarker: OptionalConformanceMarker2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Int? {}
// UIntRawRepresentableMarker
extension UIntRawRepresentableMarker: ConformanceMarker where T: RawRepresentable, T.RawValue == UInt {}
extension UIntRawRepresentableMarker: ConformanceMarker2 where T: RawRepresentable, T.RawValue == UInt? {}
extension UIntRawRepresentableMarker: OptionalConformanceMarker where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == UInt {}
extension UIntRawRepresentableMarker: OptionalConformanceMarker2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == UInt? {}
// FloatRawRepresentableMarker
extension FloatRawRepresentableMarker: ConformanceMarker where T: RawRepresentable, T.RawValue == Float {}
extension FloatRawRepresentableMarker: ConformanceMarker2 where T: RawRepresentable, T.RawValue == Float? {}
extension FloatRawRepresentableMarker: OptionalConformanceMarker where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Float {}
extension FloatRawRepresentableMarker: OptionalConformanceMarker2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Float? {}
// DoubleRawRepresentableMarker
extension DoubleRawRepresentableMarker: ConformanceMarker where T: RawRepresentable, T.RawValue == Double {}
extension DoubleRawRepresentableMarker: ConformanceMarker2 where T: RawRepresentable, T.RawValue == Double? {}
extension DoubleRawRepresentableMarker: OptionalConformanceMarker where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Double {}
extension DoubleRawRepresentableMarker: OptionalConformanceMarker2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Double? {}
// CGFloatRawRepresentableMarker
extension CGFloatRawRepresentableMarker: ConformanceMarker where T: RawRepresentable, T.RawValue == CGFloat {}
extension CGFloatRawRepresentableMarker: ConformanceMarker2 where T: RawRepresentable, T.RawValue == CGFloat? {}
extension CGFloatRawRepresentableMarker: OptionalConformanceMarker where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == CGFloat {}
extension CGFloatRawRepresentableMarker: OptionalConformanceMarker2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == CGFloat? {}
// BoolRawRepresentableMarker
extension BoolRawRepresentableMarker: ConformanceMarker where T: RawRepresentable, T.RawValue == Bool {}
extension BoolRawRepresentableMarker: ConformanceMarker2 where T: RawRepresentable, T.RawValue == Bool? {}
extension BoolRawRepresentableMarker: OptionalConformanceMarker where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Bool {}
extension BoolRawRepresentableMarker: OptionalConformanceMarker2 where T: OptionalType, T.Wrapped: RawRepresentable, T.Wrapped.RawValue == Bool? {}

// swiftlint:disable opening_brace
private func rawRepresentableRawValueType<T>(_ t: T.Type) -> Mirror.TypeInfo.Kind.RawValue? {
    if StringRawRepresentableMarker<T>.self is ConformanceMarker.Type ||
        StringRawRepresentableMarker<T>.self is ConformanceMarker2.Type ||
        StringRawRepresentableMarker<T>.self is OptionalConformanceMarker.Type ||
        StringRawRepresentableMarker<T>.self is OptionalConformanceMarker2.Type
    {
        return .string
    } else if IntRawRepresentableMarker<T>.self is ConformanceMarker.Type ||
        IntRawRepresentableMarker<T>.self is ConformanceMarker2.Type ||
        IntRawRepresentableMarker<T>.self is OptionalConformanceMarker.Type ||
        IntRawRepresentableMarker<T>.self is OptionalConformanceMarker2.Type
    {
        return .numeric(.int)
    } else if UIntRawRepresentableMarker<T>.self is ConformanceMarker.Type ||
        UIntRawRepresentableMarker<T>.self is ConformanceMarker2.Type ||
        UIntRawRepresentableMarker<T>.self is OptionalConformanceMarker.Type ||
        UIntRawRepresentableMarker<T>.self is OptionalConformanceMarker2.Type
    {
        return .numeric(.uint)
    } else if FloatRawRepresentableMarker<T>.self is ConformanceMarker.Type ||
        FloatRawRepresentableMarker<T>.self is ConformanceMarker2.Type ||
        FloatRawRepresentableMarker<T>.self is OptionalConformanceMarker.Type ||
        FloatRawRepresentableMarker<T>.self is OptionalConformanceMarker2.Type
    {
        return .numeric(.float)
    } else if DoubleRawRepresentableMarker<T>.self is ConformanceMarker.Type ||
        DoubleRawRepresentableMarker<T>.self is ConformanceMarker2.Type ||
        DoubleRawRepresentableMarker<T>.self is OptionalConformanceMarker.Type ||
        DoubleRawRepresentableMarker<T>.self is OptionalConformanceMarker2.Type
    {
        return .numeric(.double)
    } else if CGFloatRawRepresentableMarker<T>.self is ConformanceMarker.Type ||
        CGFloatRawRepresentableMarker<T>.self is ConformanceMarker2.Type ||
        CGFloatRawRepresentableMarker<T>.self is OptionalConformanceMarker.Type ||
        CGFloatRawRepresentableMarker<T>.self is OptionalConformanceMarker2.Type
    {
        // Map CGFloat to Double
        // https://github.com/apple/swift-evolution/blob/main/proposals/0307-allow-interchangeable-use-of-double-cgfloat-types.md
        return .numeric(.double)
    } else if BoolRawRepresentableMarker<T>.self is ConformanceMarker.Type ||
        BoolRawRepresentableMarker<T>.self is ConformanceMarker2.Type ||
        BoolRawRepresentableMarker<T>.self is OptionalConformanceMarker.Type ||
        BoolRawRepresentableMarker<T>.self is OptionalConformanceMarker2.Type
    {
        return .bool
    } else if RawRepresentableMarker<T>.self is ConformanceMarker.Type ||
        RawRepresentableMarker<T>.self is OptionalConformanceMarker.Type
    {
        return .some
    } else {
        return nil
    }
}

// swiftlint:enable opening_brace

// MARK: - OptionalMarker

private protocol OptionalMarker {}
extension Optional: OptionalMarker {}
