//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing a strings file.
///
/// **Usage**
///
/// ```swift
/// let stringsFile = StringsFile(name: "Localizable", fallback: .module)
/// let greeting = "greetings".localized(file: stringsFile)
/// ```
public struct StringsFile: Sendable, Hashable {
    /// The name of the strings file.
    public let name: String

    /// The bundle containing the strings file.
    public let bundle: Bundle

    /// Creates a reference to the `.strings` file in the `.main` bundle.
    ///
    /// - Parameter name: The name of the `.strings` file.
    public init(name: String) {
        self.name = name
        self.bundle = .main
    }

    /// Creates a reference to the `.strings` file in the `.main` bundle.
    ///
    /// If the given `.strings` file is not found in the `.main` bundle, the
    /// specified fallback bundle is used.
    ///
    /// - Parameters:
    ///   - name: The name of the `.strings` file.
    ///   - fallbackBundle: The bundle to use if the given `.strings` file is not
    ///     found in the `.main` bundle.
    public init(name: String, fallback fallbackBundle: Bundle) {
        self.name = name

        if Bundle.main.path(forResource: name, ofType: "strings") != nil {
            bundle = .main
        } else {
            bundle = fallbackBundle
        }
    }
}

// MARK: - ExpressibleByStringLiteral

extension StringsFile: ExpressibleByStringLiteral {
    public init(stringLiteral value: StringLiteralType) {
        self.init(name: value)
    }
}

// MARK: - String

extension String {
    /// Returns a localized string from the specific strings file without arguments.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let stringsFile = StringsFile(name: "Localizable", fallback: .module)
    /// let greeting = "greetings".localized(file: stringsFile)
    /// ```
    ///
    /// - Parameters:
    ///   - file: The name of the `.strings` file.
    ///   - comment: The comment to place above the key-value pair in the strings
    ///     file. This parameter provides the translator with some context about the
    ///     localized string’s presentation to the user.
    ///
    /// - Returns: It returns the translation found in the provided `.strings` file.
    ///   If the translation cannot be found it will return its own value.
    public func localized(file: StringsFile? = nil, comment: StaticString? = "") -> String {
        String(localized: .init(self), table: file?.name, bundle: file?.bundle, comment: comment)
    }

    /// Returns a localized string from the specific strings file with arguments.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let stringsFile = StringsFile(name: "Localizable", fallback: .module)
    /// let greeting = "greetings".localized(file: stringsFile, "Sam")
    /// ```
    ///
    /// - Parameters:
    ///   - file: The name of the `.strings` file.
    ///   - comment: The comment to place above the key-value pair in the strings
    ///     file. This parameter provides the translator with some context about the
    ///     localized string’s presentation to the user.
    ///   - arguments: Pass the arguments you want to replace your strings
    ///     placeholders with.
    ///
    /// - Returns: It returns the translation found in the provided `.strings` file
    ///   with the arguments inserted. If the translation cannot be found it will
    ///   return its own value.
    public func localized(file: StringsFile? = nil, comment: StaticString? = nil, _ arguments: CVarArg...) -> String {
        String(
            format: localized(file: file, comment: comment),
            arguments: arguments
        )
    }
}
