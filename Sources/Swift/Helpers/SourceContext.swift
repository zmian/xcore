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
public struct SourceContext: CustomStringConvertible {
    public let file: StaticString
    public let fileId: StaticString
    public let filePath: StaticString
    public let function: StaticString
    public let line: UInt
    public let column: UInt

    public init(
        file: StaticString = #file,
        fileId: StaticString = #fileID,
        filePath: StaticString = #filePath,
        function: StaticString = #function,
        line: UInt = #line,
        column: UInt = #column
    ) {
        self.file = file
        self.fileId = fileId
        self.filePath = filePath
        self.function = function
        self.line = line
        self.column = column
    }

    public var `class`: String {
        "\(file)".lastPathComponent.deletingPathExtension
    }

    public var description: String {
        """
        file:     "\(file)"
        fileId:   "\(fileId)"
        filePath: "\(filePath)"
        function: "\(function)"
        line:     \(line)
        column:   \(column)
        """
    }
}
