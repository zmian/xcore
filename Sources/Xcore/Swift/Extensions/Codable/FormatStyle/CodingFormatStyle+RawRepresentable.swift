//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable opening_brace

import Foundation

// MARK: - Decoding

/// A structure to decode string to output using block based format style.
public struct RawRepresentableDecodingFormatStyle<Output>: DecodingFormatStyle
    where Output: RawRepresentable, Output.RawValue == String
{
    public typealias Options = StringCodingFormatStyle.Options

    private let options: Options

    fileprivate init(options: Options) {
        self.options = options
    }

    public func decode(_ value: AnyCodable) throws -> Output {
        // Attempt to construct the value from the given value without any
        // transformation.
        if
            let value = value.value as? Output.RawValue,
            let output = Output(rawValue: value)
        {
            return output
        }

        let format = StringCodingFormatStyle(options: options)
        guard let output = Output(rawValue: try format.decode(value)) else {
            throw CodingFormatStyleError.invalidValue
        }

        return output
    }
}

// MARK: - Convenience

extension DecodingFormatStyle {
    public static func rawValue<Output>(options: Self.Options) -> Self
        where Self == RawRepresentableDecodingFormatStyle<Output>
    {
        Self(options: options)
    }
}
