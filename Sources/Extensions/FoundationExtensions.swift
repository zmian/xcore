//
// FoundationExtensions.swift
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

// MARK: NSDate Extension

public extension NSDate {
    public func fromNow(unitsStyle: NSDateComponentsFormatterUnitsStyle = .Abbreviated, format: String = "%@") -> String? {
        let formatter              = NSDateComponentsFormatter()
        formatter.unitsStyle       = unitsStyle
        formatter.maximumUnitCount = 1
        formatter.allowedUnits     = [.Year, .Month, .Day, .Hour, .Minute, .Second]

        guard let timeString = formatter.stringFromDate(self, toDate: NSDate()) else {
            return nil
        }

        let formatString = NSLocalizedString(format, comment: "Used to say how much time has passed (e.g. '2 hours ago').")
        return String(format: formatString, timeString)
    }
}

// MARK: NSBundle Extension

public extension NSBundle {
    /// The app version number extracted from `CFBundleShortVersionString`.
    public static var appVersionNumber: String {
        return NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// The app build number extracted from `CFBundleVersion`.
    public static var appBuildNumber: String {
        return NSBundle.mainBundle().infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    /// Returns common app information.
    ///
    /// Sample output:
    /// ```
    /// iOS 9.2.1         // OS Version
    /// iPhone 6s         // Device
    /// Version 1.0 (300) // App Version and Build number
    /// ```
    public static var appInfo: String {
        var systemName = UIDevice.currentDevice().systemName

        if systemName == "iPhone OS" {
            systemName = "iOS"
        }

        return "\(systemName) \(UIDevice.currentDevice().systemVersion)\n" +
               "\(UIDevice.currentDevice().modelType.description)\n" +
               "Version \(NSBundle.appVersionNumber) (\(NSBundle.appBuildNumber))"
    }
}

// MARK: NSMutableData Extension

public extension NSMutableData {
    /// A convenience method to append string to `NSMutableData` using specified encoding.
    ///
    /// - parameter string:               The string to be added to the `NSMutableData`.
    /// - parameter encoding:             The encoding to use for representing the specified string. The default value is `NSUTF8StringEncoding`.
    /// - parameter allowLossyConversion: A boolean value to determine lossy conversion. The default value is `false`.
    public func appendString(string: String, encoding: NSStringEncoding = NSUTF8StringEncoding, allowLossyConversion: Bool = false) {
        let data = string.dataUsingEncoding(encoding, allowLossyConversion: allowLossyConversion)!
        appendData(data)
    }
}
