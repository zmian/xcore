//
// Date+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
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
