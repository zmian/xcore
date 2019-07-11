//
// Date+Extensions.swift
//
// Copyright © 2014 Xcore
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

import UIKit

extension Bundle {
    /// Returns the `Bundle` object with which the specified class name is associated.
    ///
    /// The `Bundle` object that dynamically loaded `forClassName` (a loadable bundle),
    /// the `Bundle` object for the framework in which `forClassName` is defined, or the
    /// main bundle object if `forClassName` was not dynamically loaded or is not defined
    /// in a framework.
    ///
    /// This method creates and returns a new `Bundle` object if there is no existing
    /// bundle associated with `forClassName`. Otherwise, the existing instance is returned.
    public convenience init?(forClassName className: String) {
        guard let aClass = NSClassFromString(className) else {
            return nil
        }

        self.init(for: aClass)
    }
}

extension Bundle {
    /// The identifier string for the bundle extracted from `CFBundleIdentifier`.
    public var identifier: String {
        return infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }

    /// The release-version-number string for the bundle extracted from `CFBundleShortVersionString`.
    public var versionNumber: String {
        return infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// The build-version-number string for the bundle extracted from `CFBundleVersion`.
    public var buildNumber: String {
        return infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    /// Returns common bundle information.
    ///
    /// Sample output:
    /// ```swift
    /// iOS 12.1.0        // OS Version
    /// iPhone X          // Device
    /// Version 1.0 (300) // App Version and Build number
    /// ```
    public var info: String {
        var systemName = UIDevice.current.systemName

        if systemName == "iPhone OS" {
            systemName = "iOS"
        }

        return """
        \(systemName) \(UIDevice.current.systemVersion)
        \(UIDevice.current.modelType)
        Version \(versionNumber) (\(buildNumber))"
        """
    }
}

extension Bundle {
    /// Returns the first URL for the specified common directory in the user domain.
    public static func url(for directory: FileManager.SearchPathDirectory) -> URL? {
        return FileManager.default.url(for: directory)
    }
}

extension FileManager {
    /// Returns the first URL for the specified common directory in the user domain.
    open func url(for directory: SearchPathDirectory) -> URL? {
        return urls(for: directory, in: .userDomainMask).first
    }
}

extension FileManager {
    public enum Options {
        case none
        /// An option to create url if it does not already exist.
        case createIfNotExistsWith(_ resourceValue: URLResourceValues?)

        public static var createIfNotExists: Options {
            return createIfNotExistsWith(nil)
        }
    }

    enum FileManagerError: Error {
        case relativeDirectoryNotFound
        case pathNotFound
        case onlyDirectoryCreationSupported
    }

    /// Returns a `URL` constructed by appending the given path component relative
    /// to the specified directory.
    ///
    /// - Parameters:
    ///   - path: The path component to add.
    ///   - directory: The directory in which the given `path` is constructed.
    ///   - options: The options that are applied to when appending path. See
    ///                 `FileManager.Options` for possible values. The default value is `.none`.
    /// - Returns: Returns a `URL` constructed by appending the given path component
    ///            relative to the specified directory.
    open func appending(path: String, relativeTo directory: SearchPathDirectory, options: Options = .none) throws -> URL {
        guard var directoryUrl = url(for: directory) else {
            throw FileManagerError.relativeDirectoryNotFound
        }

        directoryUrl = directoryUrl.appendingPathComponent(path, isDirectory: true)

        if case .createIfNotExistsWith(let resourceValue) = options {
            try createIfNotExists(directoryUrl, resourceValue: resourceValue)
        }

        if fileExists(atPath: directoryUrl.path) {
            return directoryUrl
        }

        throw FileManagerError.pathNotFound
    }
}

extension FileManager {
    /// Creates the given url if it does not already exist.
    open func createIfNotExists(_ url: URL, resourceValue: URLResourceValues? = nil) throws {
        guard !fileExists(atPath: url.path) else {
            return
        }

        guard url.hasDirectoryPath else {
            throw FileManagerError.onlyDirectoryCreationSupported
        }

        var url = url
        try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

        if let resourceValue = resourceValue {
            try url.setResourceValues(resourceValue)
        }
    }
}
