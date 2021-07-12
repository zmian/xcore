//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public enum Console {
    /// The default value is `.all`.
    public static var levelOptions: LevelOptions = .all

    /// The default value is `.basic`.
    public static var prefixOptions: PrefixOptions = .basic

    /// Writes the textual representations of debug message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - items: Items to write to standard output.
    ///   - condition: To achieve assert like behavior, you can pass condition that
    ///     must be met to write ouput.
    ///   - separator: The separator to use between items.
    ///   - terminator: To print without a trailing newline, pass `terminator: ""`.
    ///   - context: The source where this log is executed.
    public static func log(_ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", context: SourceContext = .init()) {
        internalPrint(level: .debug, items: items, condition: condition, separator: separator, terminator: terminator, context: context)
    }

    /// Writes the textual representations of info message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - items: Items to write to standard output.
    ///   - condition: To achieve assert like behavior, you can pass condition that
    ///     must be met to write ouput.
    ///   - separator: The separator to use between items.
    ///   - terminator: To print without a trailing newline, pass `terminator: ""`.
    ///   - context: The source where this log is executed.
    public static func info(_ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", context: SourceContext = .init()) {
        internalPrint(level: .info, items: items, condition: condition, separator: separator, terminator: terminator, context: context)
    }

    /// Writes the textual representations of warning message, separated by
    /// separator and terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - items: Items to write to standard output.
    ///   - condition: To achieve assert like behavior, you can pass condition that
    ///     must be met to write ouput.
    ///   - separator: The separator to use between items.
    ///   - terminator: To print without a trailing newline, pass `terminator: ""`.
    ///   - context: The source where this log is executed.
    public static func warn(_ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", context: SourceContext = .init()) {
        internalPrint(level: .warn, items: items, condition: condition, separator: separator, terminator: terminator, context: context)
    }

    /// Writes the textual representations of error message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - items: Items to write to standard output.
    ///   - condition: To achieve assert like behavior, you can pass condition that
    ///     must be met to write ouput.
    ///   - separator: The separator to use between items.
    ///   - terminator: To print without a trailing newline, pass `terminator: ""`.
    ///   - context: The source where this log is executed.
    public static func error(_ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", context: SourceContext = .init()) {
        internalPrint(level: .error, items: items, condition: condition, separator: separator, terminator: terminator, context: context)
    }

    /// Writes the textual representations of items, separated by separator and
    /// terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - level: The log level option. The default value is `.debug`.
    ///   - items: Items to write to standard output.
    ///   - condition: To achieve assert like behavior, you can pass condition that
    ///     must be met to write ouput.
    ///   - separator: The separator to use between items.
    ///   - terminator: To print without a trailing newline, pass `terminator: ""`.
    ///   - context: The source where this log is executed.
    public static func print(level: LevelOptions = .debug, _ items: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", context: SourceContext = .init()) {
        internalPrint(level: level, items: items, condition: condition, separator: separator, terminator: terminator, context: context)
    }
}

extension Console {
    /// Writes the textual representations of items, separated by separator and
    /// terminated by terminator, into the standard output.
    ///
    /// - Parameters:
    ///   - level: The log level option.
    ///   - items: Items to write to standard output.
    ///   - condition: To achieve assert like behavior, you can pass condition that
    ///     must be met to write ouput.
    ///   - separator: The separator to use between items.
    ///   - terminator: To print without a trailing newline, pass `terminator: ""`.
    ///   - context: The source where this log is executed.
    private static func internalPrint(level: LevelOptions, items: [Any], condition: Bool = true, separator: String = " ", terminator: String = "\n", context: SourceContext) {
        guard levelOptions.contains(level), condition else { return }

        let items = items.map { "\($0)" }.joined(separator: separator)
        let prefix = prefixOptions(level: level, context: context)

        if prefix.isEmpty {
            Swift.print(items, terminator: terminator)
        } else {
            Swift.print(prefix, items, terminator: terminator)
        }
    }

    private static func prefixOptions(level: LevelOptions, context: SourceContext) -> String {
        var result: String = ""

        if prefixOptions.isEmpty, level.consoleDescription == nil {
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
            result += context.class.lastPathComponent.deletingPathExtension
        }

        if contains(.functionName) {
            let separator = contains(.className) ? "." : ""
            result += "\(separator)\(context.function)"
        }

        if contains(.lineNumber) {
            let separator = contains(.className) || contains(.functionName) ? ":" : ""
            result += "\(separator)\(context.line)"
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

        public static let debug = Self(rawValue: 1 << 0)
        public static let info = Self(rawValue: 1 << 1)
        public static let warn = Self(rawValue: 1 << 2)
        public static let error = Self(rawValue: 1 << 3)
        public static let all: Self = [debug, info, warn, error]

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

        public static let className = Self(rawValue: 1 << 0)
        public static let functionName = Self(rawValue: 1 << 1)
        public static let lineNumber = Self(rawValue: 1 << 2)
        public static let date = Self(rawValue: 1 << 3)
        public static let all: Self = [className, functionName, lineNumber, date]
        public static let basic: Self = [className, lineNumber]
    }
}
