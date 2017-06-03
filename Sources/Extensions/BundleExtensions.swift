//
// DateExtensions.swift
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
    /// ```
    /// iOS 9.2.1         // OS Version
    /// iPhone 6s         // Device
    /// Version 1.0 (300) // App Version and Build number
    /// ```
    public var info: String {
        var systemName = UIDevice.current.systemName

        if systemName == "iPhone OS" {
            systemName = "iOS"
        }

        return "\(systemName) \(UIDevice.current.systemVersion)\n" +
               "\(UIDevice.current.modelType.description)\n" +
               "Version \(versionNumber) (\(buildNumber))"
    }
}
