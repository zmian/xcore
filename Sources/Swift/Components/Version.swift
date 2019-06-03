//
// Version.swift
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

/// A type that can be used to represent a version and compared using the
/// relational operators `<`, `<=`, `>=`, and `>`.
///
/// # Example Usage
///
/// ```swift
/// // Sample code to add an extension to compare operating system version
/// // using semantic versioning.
///
/// extension UIDevice {
///     /// A strongly typed current version of the operating system.
///     ///
///     /// ```swift
///     /// // Accurate version checks.
///     /// if UIDevice.current.osVersion <= "7" {
///     ///     // Less than or equal to iOS 7
///     ///     ...
///     /// }
///     ///
///     /// if UIDevice.current.osVersion > "8" {
///     ///     // Greater than iOS 8
///     ///     ...
///     /// }
///     /// ```
///     public var osVersion: Version {
///         return Version(rawValue: systemVersion)
///     }
/// }
/// ```
public struct Version: RawRepresentable {
    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension Version: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.rawValue = value
    }
}

extension Version: CustomStringConvertible {
    public var description: String {
        return rawValue
    }
}

extension Version: CustomPlaygroundDisplayConvertible {
    public var playgroundDescription: Any {
        return rawValue
    }
}

extension Version: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rawValue)
    }
}

extension Version: Comparable {
    public static func ==(lhs: Version, rhs: Version) -> Bool {
        return lhs.rawValue.compare(rhs.rawValue, options: .numeric) == .orderedSame
    }

    public static func <(lhs: Version, rhs: Version) -> Bool {
        return lhs.rawValue.compare(rhs.rawValue, options: .numeric) == .orderedAscending
    }
}
