//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
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
        processInfo
    }

    public func contains(key: String) -> Bool {
        environment[key] != nil || inMemoryEnvironmentStorage[key] != nil
    }
}

extension ProcessInfo {
    private struct AssociatedKey {
        static var inMemoryEnvironmentStorage = "inMemoryEnvironmentStorage"
    }

    fileprivate var inMemoryEnvironmentStorage: [String: String] {
        get { associatedObject(&AssociatedKey.inMemoryEnvironmentStorage, default: [:]) }
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
            rawValue
        }

        /// A boolean property to indicate whether the variable exists in the
        /// environment from which the process was launched.
        public var exists: Bool {
            ProcessInfo.shared.contains(key: rawValue) || ProcessInfo.shared.inMemoryEnvironmentStorage.keys.contains(rawValue)
        }

        /// The variable value in the environment from which the process was launched.
        private var currentValue: String? {
            var storedValue = ProcessInfo.shared.inMemoryEnvironmentStorage[rawValue]

            if storedValue == nil {
                storedValue = ProcessInfo.shared.environment[rawValue]
            }

            guard let value = storedValue, !value.isBlank else {
                return nil
            }

            return value
        }

        /// Returns the value of the argument.
        public func get<T>() -> T? {
            guard let value = currentValue else {
                switch T.self {
                    case is Bool.Type, is Optional<Bool>.Type:
                        if exists {
                            return true as? T
                        }
                    default:
                        break
                }

                return nil
            }

            return StringConverter(value).get()
        }

        /// Set given value in memory.
        public func set<T>(_ value: T?) {
            var valueToSave: String?

            if let newValue = value {
                valueToSave = String(describing: newValue)
            }

            ProcessInfo.shared.inMemoryEnvironmentStorage[rawValue] = valueToSave
        }
    }
}

// MARK: - ProcessInfo.Argument Convenience

extension ProcessInfo.Argument {
    /// Returns the value of the argument.
    public func get() -> Bool {
        get() ?? false
    }

    /// Returns the value of the argument.
    ///
    /// - Parameter defaultValue: The value returned if the value doesn't exists.
    public func get<T>(default defaultValue: @autoclosure () -> T) -> T {
        get() ?? defaultValue()
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Parameter defaultValue: The value returned if the providers list doesn't
    ///                           contain value.
    /// - Returns: The value for the key.
    public func get<T>(default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        if let rawValue: String = get(), let value = T(rawValue: rawValue) {
            return value
        }

        return defaultValue()
    }
}

// MARK: - Namespace

extension ProcessInfo {
    public enum Arguments { }
}

// MARK: - Built-in Arguments

extension ProcessInfo.Arguments {
    public static var isTesting: Bool {
        ProcessInfo.Argument("XCTestConfigurationFilePath").exists
    }

    public static var isDebug: Bool {
        ProcessInfo.Argument("DEBUG").exists
    }

    public static var isAnalyticsDebugEnabled: (enabled: Bool, contains: String?) {
        guard isDebuggerAttached else {
            return (false, nil)
        }

        let argument = ProcessInfo.Argument("XCAnalyticsDebugEnabled")
        return (argument.exists, argument.get())
    }

    public static var isAllInterstitialsEnabled: Bool {
        get {
            #if DEBUG
                return ProcessInfo.Argument("XCAllInterstitialsEnabled").exists
            #else
                return false
            #endif
        }
        set { ProcessInfo.Argument("XCAllInterstitialsEnabled").set(newValue) }
    }
}
