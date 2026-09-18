//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Decoding

/// A structure to decode string to output using block based format style.
public struct RawRepresentableDecodingFormatStyle<Output: RawRepresentable<String>>: DecodingFormatStyle, Sendable {
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
        guard let output = try Output(rawValue: format.decode(value)) else {
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
        .init(options: options)
    }
}
