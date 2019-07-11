//
// ProcessInfo+Extensions.swift
//
// Copyright © 2017 Xcore
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

extension ProcessInfo {
    /// Returns the process information agent for the process.
    ///
    /// An `ProcessInfo` object is created the first time this method is invoked,
    /// and that same object is returned on each subsequent invocation.
    ///
    /// - Returns: Shared process information agent for the process.
    public static var shared: ProcessInfo {
        return processInfo
    }

    public func contains(key: String) -> Bool {
        return environment[key] != nil || inMemoryEnvironmentStorage[key] != nil
    }
}

extension ProcessInfo {
    private struct AssociatedKey {
        static var inMemoryEnvironmentStorage = "inMemoryEnvironmentStorage"
    }

    fileprivate var inMemoryEnvironmentStorage: [String: String] {
        get { return associatedObject(&AssociatedKey.inMemoryEnvironmentStorage, default: [:]) }
        set { setAssociatedObject(&AssociatedKey.inMemoryEnvironmentStorage, value: newValue) }
    }
}

extension ProcessInfo {
    public struct Argument: RawRepresentable, ExpressibleByStringLiteral, CustomStringConvertible, Equatable {
        /// The variable name in the environment from which the process was launched.
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            self.rawValue = value
        }

        public var description: String {
            return rawValue
        }

        /// A boolean property to indicate whether the variable exists in the
        /// environment from which the process was launched.
        public var exists: Bool {
            return ProcessInfo.shared.contains(key: rawValue)
        }

        /// The variable value in the environment from which the process was launched.
        public var value: String? {
            var storedValue = ProcessInfo.shared.inMemoryEnvironmentStorage[rawValue]

            if storedValue == nil {
                storedValue = ProcessInfo.shared.environment[rawValue]
            }

            guard let value = storedValue, !value.isBlank else {
                return nil
            }

            return value
        }

        public func getValue<T>() -> T? {
            guard let value = value else {
                return nil
            }

            return StringConverter(value).get()
        }

        public func setInMemoryValue<T>(_ value: T?) {
            var valueToSave: String?

            if let newValue = value {
                valueToSave = String(describing: newValue)
            }

            ProcessInfo.shared.inMemoryEnvironmentStorage[rawValue] = valueToSave
        }
    }
}

extension ProcessInfo {
    public enum Arguments { }
}

extension ProcessInfo.Arguments {
    public static var isTesting: Bool {
        let argument: ProcessInfo.Argument = "XCTestConfigurationFilePath"
        return argument.exists
    }

    public static var isDebug: Bool {
        let argument: ProcessInfo.Argument = "DEBUG"
        return argument.exists
    }

    public static var printAnalyticsToDebugger: (enabled: Bool, contains: String?) {
        guard isDebuggerAttached else {
            return (false, nil)
        }

        let argument: ProcessInfo.Argument = "XCPrintAnalyticsToDebugger"
        return (argument.exists, argument.value)
    }
}
