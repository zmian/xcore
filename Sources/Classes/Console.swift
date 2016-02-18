//
// Console.swift
//
// Copyright © 2015 Zeeshan Mian
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

public struct console {
    public static var disableAllLogs      = false
    public static var enableLogLevelDebug = true
    public static var enableLogLevelInfo  = true
    public static var enableLogLevelWarn  = true
    public static var enableLogLevelError = true

    /// Writes the textual representations of debug message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - parameter messages:   Messages to write to standard output.
    /// - parameter condition:  To achieve assert like behavior, you can pass condition that must be met to write ouput.
    /// - parameter separator:  The separator to use between messages. The default value is `" "`.
    /// - parameter terminator: To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    /// - parameter className:  The name of the class where this log is executed. The default value is extracted from `#file`.
    /// - parameter lineNumber: The line number where this log is executed. The default value is of `#line`.
    public static func log(messages: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = __FILE__, lineNumber: Int = __LINE__) {
        guard condition && !disableAllLogs && enableLogLevelDebug else { return }

        let messages  = messages.map { String($0) }.joinWithSeparator(separator)
        let className = className.lastPathComponent.stringByDeletingPathExtension
        print("[\(className):\(lineNumber)]", messages, terminator: terminator)
    }

    /// Writes the textual representations of info message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - parameter messages:   Messages to write to standard output.
    /// - parameter condition:  To achieve assert like behavior, you can pass condition that must be met to write ouput.
    /// - parameter separator:  The separator to use between messages. The default value is `" "`.
    /// - parameter terminator: To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    /// - parameter className:  The name of the class where this log is executed. The default value is extracted from `#file`.
    /// - parameter lineNumber: The line number where this log is executed. The default value is of `#line`.
    public static func info(messages: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = __FILE__, lineNumber: Int = __LINE__) {
        guard condition && !disableAllLogs && enableLogLevelInfo else { return }

        let messages  = messages.map { String($0) }.joinWithSeparator(separator)
        let className = className.lastPathComponent.stringByDeletingPathExtension
        print("[\(className):\(lineNumber)]", messages, terminator: terminator)
    }

    /// Writes the textual representations of warning message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - parameter messages:   Messages to write to standard output.
    /// - parameter condition:  To achieve assert like behavior, you can pass condition that must be met to write ouput.
    /// - parameter separator:  The separator to use between messages. The default value is `" "`.
    /// - parameter terminator: To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    /// - parameter className:  The name of the class where this log is executed. The default value is extracted from `#file`.
    /// - parameter lineNumber: The line number where this log is executed. The default value is of `#line`.
    public static func warn(messages: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = __FILE__, lineNumber: Int = __LINE__) {
        guard condition && !disableAllLogs && enableLogLevelWarn else { return }

        let messages  = messages.map { String($0) }.joinWithSeparator(separator)
        let className = className.lastPathComponent.stringByDeletingPathExtension
        print("[\(className):\(lineNumber)] WARNING:", messages, terminator: terminator)
    }

    /// Writes the textual representations of error message, separated by separator
    /// and terminated by terminator, into the standard output.
    ///
    /// - parameter messages:   Messages to write to standard output.
    /// - parameter condition:  To achieve assert like behavior, you can pass condition that must be met to write ouput.
    /// - parameter separator:  The separator to use between messages. The default value is `" "`.
    /// - parameter terminator: To print without a trailing newline, pass `terminator: ""`. The default value is `"\n"`.
    /// - parameter className:  The name of the class where this log is executed. The default value is extracted from `#file`.
    /// - parameter lineNumber: The line number where this log is executed. The default value is of `#line`.
    public static func error(messages: Any..., condition: Bool = true, separator: String = " ", terminator: String = "\n", className: String = __FILE__, lineNumber: Int = __LINE__) {
        guard condition && !disableAllLogs && enableLogLevelError else { return }

        let messages  = messages.map { String($0) }.joinWithSeparator(separator)
        let className = className.lastPathComponent.stringByDeletingPathExtension
        print("[\(className):\(lineNumber)] ERROR:", messages, terminator: terminator)
    }
}
