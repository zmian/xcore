//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FileManager {
    public struct CreationOptions {
        public let resourceValue: URLResourceValues?
        public let attributes: [FileAttributeKey: Any]?

        public init(resourceValue: URLResourceValues?, attributes: [FileAttributeKey: Any]? = nil) {
            self.resourceValue = resourceValue
            self.attributes = attributes
        }

        public static var none: Self {
            .init(resourceValue: nil, attributes: nil)
        }

        /// Excluded from iCloud Backup with `nil` attributes.
        public static var excludedFromBackup: Self {
            // Exclude from iCloud Backup
            var resourceValue = URLResourceValues()
            resourceValue.isExcludedFromBackup = true
            return .init(resourceValue: resourceValue)
        }

        /// Excluded from iCloud Backup with file protection of type `.complete`.
        ///
        /// The file is stored in an encrypted format on disk and cannot be read from or
        /// written to while the device is locked or booting.
        public static var secure: Self {
            // Exclude from iCloud Backup
            var resourceValue = URLResourceValues()
            resourceValue.isExcludedFromBackup = true

            return .init(
                resourceValue: resourceValue,
                attributes: [.protectionKey: FileProtectionType.complete]
            )
        }
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
        options: CreationOptions
    ) throws -> URL {
        var directoryUrl = try url(
            for: directory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        .appendingPathComponent(path, isDirectory: true)

        try createDirectory(
            at: directoryUrl,
            withIntermediateDirectories: true,
            attributes: options.attributes
        )

        if let resourceValue = options.resourceValue {
            try directoryUrl.setResourceValues(resourceValue)
        }

        return directoryUrl
    }
}

extension FileManager {
    open func url(path: String, relativeTo directory: SearchPathDirectory, isDirectory: Bool = true) -> URL? {
        url(for: directory)?
            .appendingPathComponent(path, isDirectory: isDirectory)
    }

    /// Removes the file or directory relative to the given directory.
    @discardableResult
    open func removeItem(_ path: String, relativeTo directory: SearchPathDirectory, isDirectory: Bool = true) -> Bool {
        guard var directoryUrl = url(for: directory) else {
            // No need to remove as it doesn't exists.
            return true
        }

        directoryUrl = directoryUrl.appendingPathComponent(path, isDirectory: isDirectory)

        do {
            try removeItem(at: directoryUrl)
            return true
        } catch {
            return false
        }
    }

    /// Returns the first URL for the specified common directory in the user domain.
    open func url(for directory: SearchPathDirectory) -> URL? {
        urls(for: directory, in: .userDomainMask).first
    }

    /// Remove all cached data from `cachesDirectory`.
    public func removeAllCache() throws {
        try urls(for: .cachesDirectory, in: .userDomainMask).forEach { directory in
            try removeItem(at: directory)
        }
    }
}

extension FileManager {
    var xcoreCacheDirectory: URL? {
        try? appending(
            path: "com.xcore",
            relativeTo: .cachesDirectory,
            options: .secure
        )
    }
}
