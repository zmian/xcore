//
// Console.swift
//
// Copyright © 2015 Xcore
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

final public class Console {
    /// The default value is `.all`.
    public static var levelOptions: LevelOptions = .all
    /// The default value is `.basic`.
    public static var prefixOptions: PrefixOptions = .basic

    /// Writes the textual representations of debug message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - items:        Items to write to standard output.
    ///   - condition:    To achieve assert like behavior, you can pass condition that must be met to write ouput.
    ///   - separator:    The separator to use between items. The default value is `" "`.
    ///   - terminator:   To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    ///   - className:    The name of the class where this log is executed. The default value is extracted from `#file`.
    ///   - functionName: The name of the function where this log is executed. The default value is extracted of `#function`.
    ///   - lineNumber:   The line number where this log is executed. The default value is of `#line`.
    public static func log(_ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        internalPrint(level: .debug, items: items, condition: condition, separator: separator, terminator: terminator, className: className, functionName: functionName, lineNumber: lineNumber)
    }

    /// Writes the textual representations of info message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - items:        Items to write to standard output.
    ///   - condition:    To achieve assert like behavior, you can pass condition that must be met to write ouput.
    ///   - separator:    The separator to use between items. The default value is `" "`.
    ///   - terminator:   To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    ///   - className:    The name of the class where this log is executed. The default value is extracted from `#file`.
    ///   - functionName: The name of the function where this log is executed. The default value is extracted of `#function`.
    ///   - lineNumber:   The line number where this log is executed. The default value is of `#line`.
    public static func info(_ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        internalPrint(level: .info, items: items, condition: condition, separator: separator, terminator: terminator, className: className, functionName: functionName, lineNumber: lineNumber)
    }

    /// Writes the textual representations of warning message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - items:        Items to write to standard output.
    ///   - condition:    To achieve assert like behavior, you can pass condition that must be met to write ouput.
    ///   - separator:    The separator to use between items. The default value is `" "`.
    ///   - terminator:   To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    ///   - className:    The name of the class where this log is executed. The default value is extracted from `#file`.
    ///   - functionName: The name of the function where this log is executed. The default value is extracted of `#function`.
    ///   - lineNumber:   The line number where this log is executed. The default value is of `#line`.
    public static func warn(_ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        internalPrint(level: .warn, items: items, condition: condition, separator: separator, terminator: terminator, className: className, functionName: functionName, lineNumber: lineNumber)
    }

    /// Writes the textual representations of error message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - items:        Items to write to standard output.
    ///   - condition:    To achieve assert like behavior, you can pass condition that must be met to write ouput.
    ///   - separator:    The separator to use between items. The default value is `" "`.
    ///   - terminator:   To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    ///   - className:    The name of the class where this log is executed. The default value is extracted from `#file`.
    ///   - functionName: The name of the function where this log is executed. The default value is extracted of `#function`.
    ///   - lineNumber:   The line number where this log is executed. The default value is of `#line`.
    public static func error(_ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        internalPrint(level: .error, items: items, condition: condition, separator: separator, terminator: terminator, className: className, functionName: functionName, lineNumber: lineNumber)
    }

    /// Writes the textual representations of items, separated by separator and terminated by terminator,
    /// into the standard output.
    ///
    /// - Parameters:
    ///   - level:        The log level option. The default value is `.debug`.
    ///   - items:        Items to write to standard output.
    ///   - condition:    To achieve assert like behavior, you can pass condition that must be met to write ouput.
    ///   - separator:    The separator to use between items. The default value is `" "`.
    ///   - terminator:   To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    ///   - className:    The name of the class where this log is executed. The default value is extracted from `#file`.
    ///   - functionName: The name of the function where this log is executed. The default value is extracted of `#function`.
    ///   - lineNumber:   The line number where this log is executed. The default value is of `#line`.
    public static func print(level: LevelOptions = .debug, _ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        internalPrint(level: level, items: items, condition: condition, separator: separator, terminator: terminator, className: className, functionName: functionName, lineNumber: lineNumber)
    }
}

extension Console {
    /// Writes the textual representations of items, separated by separator and terminated by terminator,
    /// into the standard output.
    ///
    /// - Parameters:
    ///   - level:        The log level option.
    ///   - items:        Items to write to standard output.
    ///   - condition:    To achieve assert like behavior, you can pass condition that must be met to write ouput.
    ///   - separator:    The separator to use between items. The default value is `" "`.
    ///   - terminator:   To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    ///   - className:    The name of the class where this log is executed. The default value is extracted from `#file`.
    ///   - functionName: The name of the function where this log is executed. The default value is extracted of `#function`.
    ///   - lineNumber:   The line number where this log is executed. The default value is of `#line`.
    private static func internalPrint(level: LevelOptions, items: [Any], condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = #file, functionName: String = #function, lineNumber: Int = #line) {
        guard levelOptions.contains(level) && condition else { return }

        let items = items.map { "\($0)" }.joined(separator: separator)
        let prefix = prefixOptions(level: level, className: className, functionName: functionName, lineNumber: lineNumber)

        if prefix.isEmpty {
            Swift.print(items, terminator: terminator)
        } else {
            Swift.print(prefix, items, terminator: terminator)
        }
    }

    private static func prefixOptions(level: LevelOptions, className: String, functionName: String, lineNumber: Int) -> String {
        var result: String = ""

        if prefixOptions.isEmpty && level.consoleDescription == nil {
            return result
        }

        let contains = prefixOptions.contains

        if contains(.date) {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ "
            result += formatter.string(from: date)
        }

        if contains(.className) {
            result += className.lastPathComponent.deletingPathExtension
        }

        if contains(.functionName) {
            let separator = contains(.className) ? "." : ""
            result += "\(separator)\(functionName)"
        }

        if contains(.lineNumber) {
            let separator = contains(.className) || contains(.functionName) ? ":" : ""
            result += "\(separator)\(lineNumber)"
        }

        if !prefixOptions.isEmpty {
            result = "[\(result)]"
        }

        if let description = level.consoleDescription {
            let separator = prefixOptions.isEmpty ? "" : " "
            result += "\(separator)\(description):"
        }

        return result
    }
}

extension Console {
    /// A list of log levels available.
    public struct LevelOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let debug = LevelOptions(rawValue: 1 << 0)
        public static let info = LevelOptions(rawValue: 1 << 1)
        public static let warn = LevelOptions(rawValue: 1 << 2)
        public static let error = LevelOptions(rawValue: 1 << 3)
        public static let none: LevelOptions = []
        public static let all: LevelOptions = [debug, info, warn, error]

        fileprivate var consoleDescription: String? {
            switch self {
                case .debug:
                    return nil
                case .info:
                    return "INFO"
                case .warn:
                    return "WARNING"
                case .error:
                    return "ERROR"
                default:
                    return nil
            }
        }
    }

    /// A list of log prefix available.
    public struct PrefixOptions: OptionSet {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        public static let className = PrefixOptions(rawValue: 1 << 0)
        public static let functionName = PrefixOptions(rawValue: 1 << 1)
        public static let lineNumber = PrefixOptions(rawValue: 1 << 2)
        public static let date = PrefixOptions(rawValue: 1 << 3)
        public static let none: PrefixOptions = []
        public static let all: PrefixOptions = [className, functionName, lineNumber, date]
        public static let basic: PrefixOptions = [className, lineNumber]
    }
}
