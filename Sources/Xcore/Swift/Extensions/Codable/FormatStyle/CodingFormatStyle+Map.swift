//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure to decode given value to output using block based format style.
public struct MapDecodingFormatStyle<Output>: DecodingFormatStyle, Sendable {
    private let decode: @Sendable (Any) throws -> Output?

    fileprivate init(_ decode: @escaping @Sendable (Any) throws -> Output?) {
        self.decode = decode
    }

    public func decode(_ value: AnyCodable) throws -> Output {
        guard let result = try decode(value.value) else {
            throw CodingFormatStyleError.invalidValue
        }

        return result
    }
}

// MARK: - Convenience

extension DecodingFormatStyle {
    public static func map<Output>(_ decode: @escaping @Sendable (Any) throws -> Output?) -> Self where Self == MapDecodingFormatStyle<Output> {
        .init(decode)
    }
}
