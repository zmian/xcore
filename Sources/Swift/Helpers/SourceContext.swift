//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure to hold source information.
///
/// **Usage**
///
/// ```swift
/// func greetings(context: SourceContext = .init()) {
///     print("Hello from line \(context.line).)
/// }
/// ```
///
/// - SeeAlso: https://forums.swift.org/t/9505
public struct SourceContext {
    public let file: StaticString
    public let line: UInt
    public let column: UInt
    public let function: StaticString

    public init(
        file: StaticString = #file,
        line: UInt = #line,
        column: UInt = #column,
        function: StaticString = #function
    ) {
        self.file = file
        self.line = line
        self.column = column
        self.function = function
    }

    public var `class`: String {
        "\(file)".lastPathComponent.deletingPathExtension
    }
}
