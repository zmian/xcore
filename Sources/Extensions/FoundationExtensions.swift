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

public extension Date {
    public func fromNow(style: DateComponentsFormatter.UnitsStyle = .abbreviated, format: String = "%@") -> String? {
        let formatter              = DateComponentsFormatter()
        formatter.unitsStyle       = style
        formatter.maximumUnitCount = 1
        formatter.allowedUnits     = [.year, .month, .day, .hour, .minute, .second]

        guard let timeString = formatter.string(from: self, to: Date()) else {
            return nil
        }

        let formatString = NSLocalizedString(format, comment: "Used to say how much time has passed (e.g. '2 hours ago').")
        return String(format: formatString, timeString)
    }

    /// Reset time to beginning of the day (`12 AM`) of `self` without changing the timezone.
    func stripTime() -> Date {
        let calendar = Calendar.current
        let components = (calendar as NSCalendar).components([.year, .month, .day], from: self)
        return calendar.date(from: components) ?? self
    }

    // MARK: UTC

    fileprivate static let utcDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = .utc
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }()

    var utc: Date {
        let dateString = Date.utcDateFormatter.string(from: self)
        Date.utcDateFormatter.timeZone = .current
        let date = Date.utcDateFormatter.date(from: dateString)!
        Date.utcDateFormatter.timeZone = .utc
        return date
    }
}

private extension TimeZone {
    static let utc: TimeZone = {
        return TimeZone(identifier: "UTC")!
    }()
}

// MARK: NSAttributedString Extension

extension NSAttributedString {

    public func setLineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        let newAttributedString = NSMutableAttributedString(attributedString: self)
        newAttributedString.addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSRange(location: 0, length: string.count))
        return newAttributedString
    }
}

extension NSMutableAttributedString {
    public override func setLineSpacing(_ spacing: CGFloat) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = spacing
        addAttributes([NSParagraphStyleAttributeName: paragraphStyle], range: NSRange(location: 0, length: string.count))
        return self
    }
}

// MARK: NSBundle Extension

public extension Bundle {
    /// The app version number extracted from `CFBundleShortVersionString`.
    public static var appVersionNumber: String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    /// The app build number extracted from `CFBundleVersion`.
    public static var appBuildNumber: String {
        return Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
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
        var systemName = UIDevice.current.systemName

        if systemName == "iPhone OS" {
            systemName = "iOS"
        }

        return "\(systemName) \(UIDevice.current.systemVersion)\n" +
               "\(UIDevice.current.modelType.description)\n" +
               "Version \(Bundle.appVersionNumber) (\(Bundle.appBuildNumber))"
    }
}

// MARK: NSMutableData Extension

public extension NSMutableData {
    /// A convenience method to append string to `NSMutableData` using specified encoding.
    ///
    /// - parameter string:               The string to be added to the `NSMutableData`.
    /// - parameter encoding:             The encoding to use for representing the specified string. The default value is `NSUTF8StringEncoding`.
    /// - parameter allowLossyConversion: A boolean value to determine lossy conversion. The default value is `false`.
    public func append(string: String, encoding: String.Encoding = .utf8, allowLossyConversion: Bool = false) {
        let data = string.data(using: encoding, allowLossyConversion: allowLossyConversion)!
        append(data)
    }
}
