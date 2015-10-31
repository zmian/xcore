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

    public static func log(message: String, className: String = __FILE__, lineNumber: Int = __LINE__) {
        let className = extractClassName(className)

        if enableLogLevelDebug && !disableAllLogs {
            print("[\(className):\(lineNumber)] \(message)")
        }
    }

    public static func info(message: String, className: String = __FILE__, lineNumber: Int = __LINE__) {
        let className = extractClassName(className)

        if enableLogLevelInfo && !disableAllLogs {
            print("[\(className):\(lineNumber)] \(message)")
        }
    }

    public static func warn(message: String, className: String = __FILE__, lineNumber: Int = __LINE__) {
        let className = extractClassName(className)

        if enableLogLevelWarn && !disableAllLogs {
            print("[\(className):\(lineNumber)] WARNING: \(message)")
        }
    }

    public static func error(message: String, className: String = __FILE__, lineNumber: Int = __LINE__) {
        let className = extractClassName(className)

        if enableLogLevelError && !disableAllLogs {
            print("[\(className):\(lineNumber)] ERROR: \(message)")
        }
    }

    private static func extractClassName(className: String) -> String {
      return ((className as NSString).lastPathComponent as NSString).stringByDeletingPathExtension
    }
}
