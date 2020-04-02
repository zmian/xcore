//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Environment argument wrapped value.
///
/// **Usage:**
///
/// ```swift
/// enum Arguments {
///     @EnvironmentArgument("referral")
///     static var referral: String?
///
///     @EnvironmentArgument("skipOnboarding", default: false)
///     static var skipOnboarding: Bool
/// }
/// ```
@propertyWrapper
public struct EnvironmentArgument<Value> {
    private let argument: ProcessInfo.Argument
    private let defaultValue: (() -> Value)?

    public init(_ argument: ProcessInfo.Argument, default defaultValue: @autoclosure @escaping () -> Value) {
        self.argument = argument
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        get {
            #if DEBUG
            return argument.get(default: defaultValue!())
            #else
                return false
            #endif
        }
        set { argument.set(newValue) }
    }
}

extension EnvironmentArgument where Value: ExpressibleByNilLiteral {
    public init(_ argument: ProcessInfo.Argument) {
        self.argument = argument
        self.defaultValue = nil
    }

    public var wrappedValue: Value? {
        get {
            #if DEBUG
            return argument.get()
            #else
                return false
            #endif
        }
        set { argument.set(newValue) }
    }
}
