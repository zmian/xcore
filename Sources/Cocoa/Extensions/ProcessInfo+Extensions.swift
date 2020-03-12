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
            ProcessInfo.shared.contains(key: rawValue)
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

    public static var isAnalyticsDebugEnabled: (enabled: Bool, contains: String?) {
        guard isDebuggerAttached else {
            return (false, nil)
        }

        let argument: ProcessInfo.Argument = "XCAnalyticsDebugEnabled"
        return (argument.exists, argument.value)
    }

    public static var isAllInterstitialsEnabled: Bool {
        get {
            #if DEBUG
                let argument: ProcessInfo.Argument = "XCAllInterstitialsEnabled"
                return argument.getValue() == true
            #else
                return false
            #endif
        }
        set {
            let argument: ProcessInfo.Argument = "XCAllInterstitialsEnabled"
            argument.setInMemoryValue(newValue)
        }
    }
}
