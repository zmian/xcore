//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import OSLog

/// A structure representing a reason why code should abort at runtime.
///
/// - SeeAlso: https://github.com/apple/swift-evolution/pull/861/files
public struct FatalReason: CustomStringConvertible {
    /// A textual representation for a fatal error.
    public let reason: String

    /// Creates a new instance of a `FatalReason` with a string-based explanation.
    public init(_ reason: String) {
        self.reason = reason
    }

    public var description: String {
        reason
    }
}

// MARK: - ExpressibleByStringLiteral

extension FatalReason: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(value)
    }
}

// MARK: - Built-in

extension FatalReason {
    public static let subclassMustImplement: Self = "Must be implemented by subclass."

    static func unknownCaseDetected<T: RawRepresentable>(_ case: T) -> Self {
        .init("Unknown case detected: \(`case`) - (\(`case`.rawValue))")
    }
}

/// Unconditionally prints a given message and stops execution.
///
/// - Parameters:
///   - reason: A predefined `FatalReason`.
///   - function: The name of the calling function to print with `message`. The
///     default is the calling scope where `fatalError(because:, function:, file:, line:)`
///     is called.
///   - file: The filename to print with `message`. The default is the file
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
/// - Parameter value: The unknown value.
public func warnUnknown(_ value: Any) {
    #if DEBUG
    Logger.xc.warning("Unknown value detected: \(String(describing: value), privacy: .public)")
    #endif
}
