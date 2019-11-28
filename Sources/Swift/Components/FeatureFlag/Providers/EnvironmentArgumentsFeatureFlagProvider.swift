//
// EnvironmentArgumentsFeatureFlagProvider.swift
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

struct EnvironmentArgumentsFeatureFlag: FeatureFlagProvider {
    func value(forKey key: FeatureFlag.Key) -> FeatureFlag.Value? {
        let argument = ProcessInfo.Argument(rawValue: key.rawValue)

        guard argument.exists else {
            return nil
        }

        guard let value = argument.value else {
            // ProcessInfo environment arguments can have value without being enabled.
            // Since, we are here it means the flag is enabled and it doesn't have any
            // value, thus we return `true` to indicate that the flag is enabled to the
            // caller.
            return .init(true)
        }

        // ProcessInfo environment arguments can have value without being enabled.
        // Since, we are here it means the flag is enabled and have value, thus we
        // return the value to the caller.
        return .init(value)
    }
}
