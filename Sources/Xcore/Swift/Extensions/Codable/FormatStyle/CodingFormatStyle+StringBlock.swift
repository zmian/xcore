//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Decoding

/// A structure to decode string to output using block based format style.
public struct StringBlockDecodingFormatStyle<Output>: DecodingFormatStyle {
    private let decode: (String) throws -> Output

    fileprivate init(_ decode: @escaping (String) throws -> Output) {
        self.decode = decode
    }

    public func decode(_ value: AnyCodable) throws -> Output {
        guard let value = value.value as? String else {
            throw CodingFormatStyleError.invalidValue
        }

        return try decode(value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle {
    public static func string<Output>(_ decode: @escaping (String) throws -> Output) -> Self where Self == StringBlockDecodingFormatStyle<Output> {
        Self(decode)
    }
}

// MARK: - Encoding

/// A structure to encode input to string using block based format style.
public struct StringBlockEncodingFormatStyle<Input>: EncodingFormatStyle {
    private let encode: (Input) throws -> String

    fileprivate init(_ encode: @escaping (Input) throws -> String) {
        self.encode = encode
    }

    public func encode(_ value: Input) throws -> String {
        try encode(value)
    }
}

// MARK: - Convenience

extension EncodingFormatStyle {
    public static func string<Input>(_ encode: @escaping (Input) throws -> String) -> Self where Self == StringBlockEncodingFormatStyle<Input> {
        Self(encode)
    }
}
