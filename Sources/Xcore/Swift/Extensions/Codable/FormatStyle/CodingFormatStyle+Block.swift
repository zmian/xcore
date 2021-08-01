//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure to decode given value to output using block based format style.
public struct BlockDecodingFormatStyle<Output>: DecodingFormatStyle {
    private let decode: (Any) throws -> Output

    fileprivate init(_ decode: @escaping (Any) throws -> Output) {
        self.decode = decode
    }

    public func decode(_ value: AnyCodable) throws -> Output {
        try decode(value.value)
    }
}

// MARK: - Convenience

extension DecodingFormatStyle {
    public static func block<Output>(_ decode: @escaping (Any) throws -> Output) -> Self where Self == BlockDecodingFormatStyle<Output> {
        Self(decode)
    }
}

//struct Example: Decodable, Equatable {
//    enum CodingKeys: CodingKey {
//        case value
//    }
//
//    let value: String
//
//    init(value: String) {
//        self.value = value
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        value = try container.decode(.value, format: .block { input in
//            if input.value as? Bool {
//
//            }
//        })
//    }
//}
