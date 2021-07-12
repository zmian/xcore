//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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
    ///     found in the `.main` bundle.
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
    /// Returns a localized string, from a specific file without arguments.
    ///
    /// - Parameters:
    ///   - file: The name of the `.strings` file.
    ///   - comment: The comment to place above the key-value pair in the strings
    ///     file.
    /// - Returns: It returns the translation found in the provided `.strings` file.
    ///   If the translation cannot be found it will return its own value.
    public func localized(file: StringsFile? = nil, comment: String = "") -> String {
        NSLocalizedString(
            self,
            tableName: file?.rawValue,
            bundle: file?.bundle ?? .main,
            comment: comment
        )
    }

    /// Returns a localized string, from a specific file with arguments.
    ///
    /// - Parameters:
    ///   - file: The name of the `.strings` file.
    ///   - comment: The comment to place above the key-value pair in the strings
    ///     file.
    ///   - arguments: Pass the arguments you want to replace your strings
    ///     placeholders with.
    /// - Returns: It returns the translation found in the provided `.strings` file
    ///   with the arguments inserted. If the translation cannot be found it will
    ///   return its own value.
    public func localized(file: StringsFile? = nil, comment: String = "", _ arguments: CVarArg...) -> String {
        String(
            format: NSLocalizedString(
                self,
                tableName: file?.rawValue,
                bundle: file?.bundle ?? .main,
                comment: comment
            ),
            arguments: arguments
        )
    }
}
