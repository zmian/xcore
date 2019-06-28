//
// FeatureFlag+Providers.swift
//
// Copyright © 2019 Xcore
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

// MARK: - Registration

extension FeatureFlag {
    /// The registered list of providers.
    private static let provider = CompositeFeatureFlagProvider([
        EnvironmentArgumentsFeatureFlag()
    ])

    /// Register the given provider if it's not already registered.
    ///
    /// - Note: This method ensures there are no duplicate providers.
    public static func register(_ provider: FeatureFlagProvider) {
        self.provider.add(provider)
    }
}

// MARK: - FeatureFlag.Key Convenience

extension FeatureFlag.Key {
    private var currentValue: FeatureFlag.Value? {
        return FeatureFlag.provider.value(forKey: self)
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Returns: The value for the key.
    public func value() -> Bool {
        return currentValue?.get() ?? false
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Returns: The value for the key.
    public func value<T>() -> T? {
        return currentValue?.get()
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Parameter defaultValue: The value returned if the providers list doesn't
    ///                           contain value.
    /// - Returns: The value for the key.
    public func value<T>(default defaultValue: @autoclosure () -> T) -> T {
        return currentValue?.get() ?? defaultValue()
    }

    /// Returns the value of the key from registered list of feature flag providers.
    ///
    /// - Parameter defaultValue: The value returned if the providers list doesn't
    ///                           contain value.
    /// - Returns: The value for the key.
    public func value<T>(default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        return currentValue?.get() ?? defaultValue()
    }
}
