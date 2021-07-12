//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FileManager {
    /// Returns the first URL for the specified common directory in the user domain.
    open func url(for directory: SearchPathDirectory) -> URL? {
        urls(for: directory, in: .userDomainMask).first
    }
}

extension FileManager {
    public enum Options {
        case none
        /// An option to create url if it does not already exist.
        case createIfNotExists(_ resourceValue: URLResourceValues?)

        public static var createIfNotExists: Self {
            createIfNotExists(nil)
        }
    }

    enum Error: Swift.Error {
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
    ///     `FileManager.Options` for possible values. The default value is `.none`.
    /// - Returns: Returns a `URL` constructed by appending the given path component
    ///   relative to the specified directory.
    open func appending(
        path: String,
        relativeTo directory: SearchPathDirectory,
        options: Options = .none
    ) throws -> URL {
        guard var directoryUrl = url(for: directory) else {
            throw Error.relativeDirectoryNotFound
        }

        directoryUrl = directoryUrl.appendingPathComponent(path, isDirectory: true)

        if case let .createIfNotExists(resourceValue) = options {
            try createIfNotExists(directoryUrl, resourceValue: resourceValue)
        }

        if fileExists(atPath: directoryUrl.path) {
            return directoryUrl
        }

        throw Error.pathNotFound
    }
}

extension FileManager {
    /// Creates the given url if it does not already exist.
    open func createIfNotExists(_ url: URL, resourceValue: URLResourceValues? = nil) throws {
        guard !fileExists(atPath: url.path) else {
            return
        }

        guard url.hasDirectoryPath else {
            throw Error.onlyDirectoryCreationSupported
        }

        var url = url
        try createDirectory(at: url, withIntermediateDirectories: true, attributes: nil)

        if let resourceValue = resourceValue {
            try url.setResourceValues(resourceValue)
        }
    }
}

extension FileManager {
    /// Remove all cached data from `cachesDirectory`.
    public func removeAllCache() throws {
        try urls(for: .cachesDirectory, in: .userDomainMask).forEach { directory in
            try removeItem(at: directory)
        }
    }
}

extension FileManager {
    var xcoreCacheDirectory: URL? {
        var resourceValue = URLResourceValues()
        resourceValue.isExcludedFromBackup = true

        return try? appending(
            path: "com.xcore",
            relativeTo: .cachesDirectory,
            options: .createIfNotExists(resourceValue)
        )
    }
}
