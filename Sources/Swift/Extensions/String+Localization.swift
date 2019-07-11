//
// String+Localization.swift
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

public struct StringsFile: RawRepresentable, Equatable {
    public let rawValue: String
    public let bundle: Bundle

    /// A convenience initializer for `.strings` file in the `.main` bundle.
    ///
    /// - Parameter rawValue: The name of the `.strings` file.
    public init(rawValue: String) {
        self.rawValue = rawValue
        self.bundle = .main
    }

    /// A convenience initializer for `.strings` file in the `.main` bundle, if the
    /// given `.strings` file is not found in the `.main` bundle then the fall-back
    /// bundle is used instead.
    ///
    /// - Parameters:
    ///   - rawValue: The name of the `.strings` file.
    ///   - fallbackBundle: The bundle to use if the given `.strings` file isn't
    ///                     found in the `.main` bundle.
    public init(rawValue: String, fallback fallbackBundle: Bundle) {
        self.rawValue = rawValue

        if Bundle.main.path(forResource: rawValue, ofType: "strings") != nil {
            bundle = .main
        } else {
            bundle = fallbackBundle
        }
    }
}

extension StringsFile: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(rawValue: value)
    }
}

extension String {
    /// Use this method to localize your strings from a specific file without
    /// arguments.
    ///
    /// - Parameters:
    ///   - file: The name of the `.strings` file.
    ///   - comment: The comment to place above the key-value pair in the strings file.
    /// - Returns: It returns the translation found in the provided `.strings`
    ///            file. If the translation cannot be found it will return its
    ///            own value.
    public func localized(file: StringsFile, comment: String = "") -> String {
        return NSLocalizedString(
            self,
            tableName: file.rawValue,
            bundle: file.bundle,
            comment: comment
        )
    }

    /// Use this method to localize your strings from a specific file with
    /// arguments.
    ///
    /// - Parameters:
    ///   - file: The name of the `.strings` file.
    ///   - comment: The comment to place above the key-value pair in the strings file.
    ///   - arguments: Pass the arguments you want to replace your strings
    ///                placeholders with.
    /// - Returns: It returns the translation found in the provided `.strings`
    ///            file with the arguments inserted. If the translation cannot
    ///            be found it will return its own value.
    public func localized(file: StringsFile, comment: String = "", _ arguments: CVarArg...) -> String {
        return String(
            format: NSLocalizedString(
                self,
                tableName: file.rawValue,
                bundle: file.bundle,
                comment: ""
            ),
            arguments: arguments
        )
    }
}
