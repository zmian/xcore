//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Coding Format Style

public typealias CodingFormatStyle = DecodingFormatStyle & EncodingFormatStyle

// MARK: - Decoding Format Style

public protocol DecodingFormatStyle {
    /// The type of data to format.
    associatedtype Input

    /// The type of the formatted data.
    associatedtype Output

    /// Creates an `Output` instance from `value`.
    func decode(_ value: Input) throws -> Output
}

// MARK: - Encoding Format Style

public protocol EncodingFormatStyle {
    /// The type of data to format.
    associatedtype Input

    /// The type of the formatted data.
    associatedtype Output

    /// Creates an `Input` instance from `value`.
    func encode(_ value: Output) throws -> Input
}

// MARK: - Error

enum CodingFormatStyleError: Error {
    case invalidValue
}
