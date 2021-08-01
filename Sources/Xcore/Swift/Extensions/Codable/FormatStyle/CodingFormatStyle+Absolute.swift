//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Returns the absolute value of the input and output.
public struct AbsoluteValueCodingFormatStyle<Input>: CodingFormatStyle where Input: Comparable, Input: SignedNumeric {
    public typealias Output = Input

    public func decode(_ value: Output) throws -> Input {
        abs(value)
    }

    public func encode(_ value: Input) throws -> Output {
        abs(value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle where Self == AbsoluteValueCodingFormatStyle<Double> {
    /// Returns the absolute value of the input and output.
    public static var absolute: Self { Self() }
}

extension EncodingFormatStyle where Self == AbsoluteValueCodingFormatStyle<Double> {
    /// Returns the absolute value of the input and output.
    public static var absolute: Self { Self() }
}

extension DecodingFormatStyle where Self == AbsoluteValueCodingFormatStyle<Float> {
    /// Returns the absolute value of the input and output.
    public static var absolute: Self { Self() }
}

extension EncodingFormatStyle where Self == AbsoluteValueCodingFormatStyle<Float> {
    /// Returns the absolute value of the input and output.
    public static var absolute: Self { Self() }
}

extension DecodingFormatStyle where Self == AbsoluteValueCodingFormatStyle<Decimal> {
    /// Returns the absolute value of the input and output.
    public static var absolute: Self { Self() }
}

extension EncodingFormatStyle where Self == AbsoluteValueCodingFormatStyle<Decimal> {
    /// Returns the absolute value of the input and output.
    public static var absolute: Self { Self() }
}

extension DecodingFormatStyle where Self == AbsoluteValueCodingFormatStyle<Int> {
    /// Returns the absolute value of the input and output.
    public static var absolute: Self { Self() }
}

extension EncodingFormatStyle where Self == AbsoluteValueCodingFormatStyle<Int> {
    /// Returns the absolute value of the input and output.
    public static var absolute: Self { Self() }
}
