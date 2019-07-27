//
// FatalReason.swift
//
// Copyright © 2018 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

// See: https://github.com/apple/swift-evolution/pull/861/files

/// Reasons why code should abort at runtime
public struct FatalReason: CustomStringConvertible {
    /// An underlying string-based cause for a fatal error.
    public let reason: String

    /// Establishes a new instance of a `FatalReason` with a string-based explanation.
    public init(_ reason: String) {
        self.reason = reason
    }

    /// Conforms to CustomStringConvertible, allowing reason to print directly to complaint.
    public var description: String {
        return reason
    }
}

extension FatalReason: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

extension FatalReason {
    public static let subclassMustImplement: FatalReason = "Must be implemented by subclass."
}

// MARK: Xcore Fatal Reasons

extension FatalReason {
    static let unsupportedFallbackFormattingStyle: FatalReason = "Fallback style shouldn't be of type `abbreviationWith`."

    static func unknownCaseDetected<T: RawRepresentable>(_ case: T) -> FatalReason {
        return FatalReason("Unknown case detected: \(`case`) - (\(`case`.rawValue))")
    }

    static func dequeueFailed(for name: String, identifier: String) -> FatalReason {
        return FatalReason("Failed to dequeue \(name) with identifier: \(identifier)")
    }

    static func dequeueFailed(for name: String, kind: String, indexPath: IndexPath) -> FatalReason {
        return FatalReason("Failed to dequeue \(name) for kind: \(kind) at indexPath(\(indexPath.section), \(indexPath.item))")
    }
}

/// Unconditionally prints a given message and stops execution.
///
/// - Parameters:
///   - reason: A predefined `FatalReason`.
///   - function: The name of the calling function to print with `message`. The
///     default is the calling scope where `fatalError(because:, function:, file:, line:)`
///     is called.
///   - file: The file name to print with `message`. The default is the file
///     where `fatalError(because:, function:, file:, line:)` is called.
///   - line: The line number to print along with `message`. The default is the
///     line number where `fatalError(because:, function:, file:, line:)` is called.
@_transparent
public func fatalError(
    because reason: FatalReason,
    function: StaticString = #function,
    file: StaticString = #file,
    line: UInt = #line
) -> Never {
    fatalError("\(function): \(reason)", file: file, line: line)
}

/// Prints a warning message in debug mode.
///
/// - Parameters:
///   - value: The unknown value.
///   - file: The file name to print with `message`. The default is the file
///     where `unknown(:function:file:line:)` is called.
///   - function: The name of the calling function to print with `message`. The
///     default is the calling scope where `unknown(:function:file:line:)` is
///     called.
///   - line: The line number to print along with `message`. The default is the
///     line number where `unknown(:function:file:line:)` is called.
@_transparent
public func warnUnknown(
    _ value: Any,
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    #if DEBUG
    Console.warn("Unknown value detected: \(value)", className: file, functionName: function, lineNumber: line)
    #endif
}
