//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Coding Format Style

/// A formating style that can convert itself into and out of an external
/// representation.
public typealias CodingFormatStyle = DecodingFormatStyle & EncodingFormatStyle

// MARK: - Decoding Format Style

/// A type that decodes a given data type into a representation in another type,
/// such as a string.
public protocol DecodingFormatStyle {
    /// The type of data to format for decoding.
    associatedtype Input

    /// The type of the formatted data after decoding.
    associatedtype Output

    /// Decodes an instance of `Output` from the provided `Input`.
    ///
    /// - Parameter value: The input data to be decoded.
    /// - Returns: The decoded output data.
    /// - Throws: An error if decoding fails, indicating an invalid value.
    func decode(_ value: Input) throws -> Output
}

// MARK: - Encoding Format Style

/// A type that encodes a given data type into a representation in another type,
/// such as a string.
public protocol EncodingFormatStyle {
    /// The type of data to format for encoding.
    associatedtype Input

    /// The type of the formatted data for encoding.
    associatedtype Output

    /// Encodes an instance of `Input` from the provided `Output`.
    ///
    /// - Parameter value: The output data to be encoded.
    /// - Returns: The encoded input data.
    /// - Throws: An error if encoding fails, indicating an invalid value.
    func encode(_ value: Output) throws -> Input
}

// MARK: - Error

/// An enumeration representing errors related to coding format styles.
enum CodingFormatStyleError: Error {
    /// Indicates an invalid value encountered during coding.
    case invalidValue
}
