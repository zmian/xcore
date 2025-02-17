//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension ProcessInfo {
    /// Checks if an environment variable or in-memory stored key exists.
    ///
    /// - Parameter key: The key to check in the environment variables.
    /// - Returns: `true` if the key exists, `false` otherwise.
    public func contains(key: String) -> Bool {
        environment[key] != nil || inMemoryEnvironmentStorage[key] != nil
    }
}

// MARK: - In-Memory Storage

extension ProcessInfo {
    private enum AssociatedKey {
        nonisolated(unsafe) static var inMemoryEnvironmentStorage = "inMemoryEnvironmentStorage"
    }

    /// A dictionary storing in-memory environment values.
    private var inMemoryEnvironmentStorage: [String: String] {
        get { associatedObject(&AssociatedKey.inMemoryEnvironmentStorage, default: [:]) }
        set { setAssociatedObject(&AssociatedKey.inMemoryEnvironmentStorage, value: newValue) }
    }
}

// MARK: - Argument

extension ProcessInfo {
    /// A representation of a process argument, allowing interaction with environment
    /// variables.
    public struct Argument: RawRepresentable, ExpressibleByStringLiteral, CustomStringConvertible, Hashable {
        /// The variable name in the environment from which the process was launched.
        public let rawValue: String

        public init(rawValue: String) {
            self.rawValue = rawValue
        }

        public init(stringLiteral value: String) {
            self.rawValue = value
        }

        public var description: String {
            rawValue
        }

        /// A Boolean property indicating whether the argument exists in the process
        /// environment.
        public var exists: Bool {
            ProcessInfo.processInfo.contains(key: rawValue)
        }

        /// Retrieves the stored value of the argument from memory or the environment.
        private var currentValue: String? {
            guard
                let storedValue =
                    ProcessInfo.processInfo.inMemoryEnvironmentStorage[rawValue]
                    ?? ProcessInfo.processInfo.environment[rawValue],
                !storedValue.isBlank
            else {
                return nil
            }

            return storedValue
        }

        /// Retrieves the value of the argument, automatically converting it to the desired type.
        public func get<T>() -> T? {
            guard let value = currentValue else {
                if T.self == Bool.self || T.self == Optional<Bool>.self, exists {
                    return true as? T
                }

                return nil
            }

            return StringConverter(value).get()
        }

        /// Stores a given value in memory for the argument.
        ///
        /// - Parameter value: The value to store in-memory.
        public func set<T>(_ value: T?) {
            ProcessInfo.processInfo.inMemoryEnvironmentStorage[rawValue] = value.map { String(describing: $0) }
        }
    }
}

// MARK: - Argument Convenience

extension ProcessInfo.Argument {
    /// Retrieves the value of the argument as a `Bool`, returning `false` if not set.
    public func get() -> Bool {
        get() ?? false
    }

    /// Retrieves the value of the argument or returns a provided default value.
    ///
    /// - Parameter defaultValue: The fallback value if the argument is not set.
    public func get<T>(default defaultValue: @autoclosure () -> T) -> T {
        get() ?? defaultValue()
    }

    /// Retrieves the value of the argument as a `RawRepresentable` enum or returns a default value.
    ///
    /// - Parameter defaultValue: The fallback value if conversion fails.
    /// - Returns: The resolved enum value or the fallback.
    public func get<T>(default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        if let rawValue: String = get(), let value = T(rawValue: rawValue) {
            return value
        }

        return defaultValue()
    }
}

// MARK: - Arguments Namespace

extension ProcessInfo {
    /// A namespace for creating process arguments dynamically.
    public enum Arguments {
        /// Creates a new process argument.
        ///
        /// - Parameter flag: The argument name.
        /// - Returns: An `Argument` instance representing the flag.
        public static func argument(_ flag: String) -> Argument {
            Argument(rawValue: flag)
        }
    }
}

// MARK: - Built-in Process Arguments

extension ProcessInfo.Arguments {
    /// A Boolean property indicating whether analytics debug mode is enabled.
    ///
    /// If enabled, analytics events are logged to the console.
    public static var isAnalyticsDebugEnabled: (enabled: Bool, contains: String?) {
        guard AppInfo.isDebuggerAttached else {
            return (false, nil)
        }

        let flag = argument("XCAnalyticsDebugEnabled")
        return (flag.exists, flag.get())
    }
}
