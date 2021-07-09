//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// Environment argument wrapped value.
///
/// **Usage**
///
/// ```swift
/// enum Arguments {
///     @ProcessInfoEnvironmentVariable("referral")
///     static var referral: String?
///
///     @ProcessInfoEnvironmentVariable("skipOnboarding", default: false)
///     static var skipOnboarding: Bool
/// }
/// ```
@propertyWrapper
public struct ProcessInfoEnvironmentVariable<Value> {
    private let argument: ProcessInfo.Argument
    private let defaultValue: (() -> Value)?

    public init(_ argument: ProcessInfo.Argument, default defaultValue: @autoclosure @escaping () -> Value) {
        self.argument = argument
        self.defaultValue = defaultValue
    }

    public var wrappedValue: Value {
        get { argument.get(default: defaultValue!()) }
        set { argument.set(newValue) }
    }
}

extension ProcessInfoEnvironmentVariable where Value: ExpressibleByNilLiteral {
    public init(_ argument: ProcessInfo.Argument) {
        self.argument = argument
        self.defaultValue = nil
    }

    public var wrappedValue: Value? {
        get { argument.get() }
        set { argument.set(newValue) }
    }
}
