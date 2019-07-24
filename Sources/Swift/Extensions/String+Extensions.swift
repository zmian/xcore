//
// String+Extensions.swift
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

import Foundation

extension StringProtocol {
    /// Returns `true` iff `value` is in `self`.
    public func contains<T: StringProtocol>(_ value: T, options: String.CompareOptions = []) -> Bool {
        return range(of: value, options: options) != nil
    }
}

extension String {
    public var capitalizeFirstCharacter: String {
        return String(prefix(1).capitalized + dropFirst())
    }

    public func urlEscaped() -> String? {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }

    /// Returns an array of strings at new lines.
    public var lines: [String] {
        return components(separatedBy: .newlines)
    }

    /// Normalize multiple whitespaces and trim whitespaces and new line characters in `self`.
    public func trimmed() -> String {
        return replace("[ ]+", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Searches for pattern matches in the string and replaces them with replacement.
    public func replace(_ pattern: String, with: String, options: String.CompareOptions = .regularExpression) -> String {
        return replacingOccurrences(of: pattern, with: with, options: options, range: nil)
    }

    /// Trim whitespaces from start and end and normalize multiple whitespaces into one and then replace them with the given string.
    public func replaceWhitespaces(with string: String) -> String {
        return trimmingCharacters(in: .whitespaces).replace("[ ]+", with: string)
    }

    /// Determine whether the string is a valid url.
    public var isValidUrl: Bool {
        if let url = URL(string: self), url.host != nil {
            return true
        }

        return false
    }

    /// `true` iff `self` contains no characters and blank spaces (e.g., \n, " ").
    public var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Drops the given `prefix` from `self`.
    ///
    /// - Returns: String without the specified `prefix` or nil if `prefix`
    ///            doesn't exists.
    public func stripPrefix(_ prefix: String) -> String? {
        guard hasPrefix(prefix) else { return nil }
        return String(dropFirst(prefix.count))
    }

    /// Take last `x` characters from `self`.
    public func take(last: Int) -> String {
        guard count >= last else {
            return self
        }

        return String(dropFirst(count - last))
    }

    /// Returns a random alphanumeric string of the given length.
    public static func randomAlphanumeric(length: Int) -> String {
        let seed = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in seed.randomElement()! })
    }
}

// MARK: - NSString

extension String {
    private var nsString: NSString {
        return self as NSString
    }

    public var lastPathComponent: String {
        return nsString.lastPathComponent
    }

    public var deletingLastPathComponent: String {
        return nsString.deletingLastPathComponent
    }

    public var deletingPathExtension: String {
        return nsString.deletingPathExtension
    }

    public var pathExtension: String {
        return nsString.pathExtension
    }

    /// Returns a new string made by appending to the receiver a given path component.
    ///
    /// The following table illustrates the effect of this method on a variety of
    /// different paths, assuming that aString is supplied as “`scratch.tiff`”:
    ///
    /// ```
    /// +-----------------------------------------------+
    /// | Receiver’s String Value | Resulting String    |
    /// |-------------------------+---------------------|
    /// | “/tmp”                  | “/tmp/scratch.tiff” |
    /// | “/tmp/”                 | “/tmp/scratch.tiff” |
    /// | “/”                     | “/scratch.tiff”     |
    /// | “” (an empty string)    | “scratch.tiff”      |
    /// +-----------------------------------------------+
    /// ```
    ///
    /// Note that this method only works with file paths (not, for example, string
    /// representations of URLs).
    ///
    /// - Parameter component: The path component to append to the receiver.
    /// - Returns: A new string made by appending `component` to the receiver,
    ///            preceded if necessary by a path separator.
    public func appendingPathComponent(_ component: Any?) -> String {
        guard let component = component else {
            return self
        }

        return nsString.appendingPathComponent(String(describing: component))
    }
}

// MARK: - Range Expressions

extension String {
    // Credit: https://stackoverflow.com/a/27880748

    /// Returns an array of strings matching the given regular expression.
    public func regex(_ pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let results = regex.matches(in: self, range: NSRange(startIndex..., in: self))
            let nsString = self as NSString
            return results.map {
                nsString.substring(with: $0.range)
            }
        } catch let error {
            #if DEBUG
            print("Invalid regex: \(error.localizedDescription)")
            #endif
            return []
        }
    }

    public func isMatch(_ pattern: String) -> Bool {
        return !regex(pattern).isEmpty
    }
}

// MARK: - Base64 Support

extension String {
    /// Creates a new string instance by decoding the given Base64 string.
    ///
    /// - Parameters:
    ///   - base64Encoded: The string instance to decode.
    ///   - options: The options to use for the decoding. The default value is `[]`.
    public init?(base64Encoded: String, options: Data.Base64DecodingOptions = []) {
        guard
            let decodedData = Data(base64Encoded: base64Encoded, options: options),
            let decodedString = String(data: decodedData, encoding: .utf8)
        else {
            return nil
        }

        self = decodedString
    }

    /// Returns Base64 representation of `self`.
    ///
    /// - Parameter options: The options to use for the encoding. The default value
    ///                      is `[]`.
    /// - Returns: The Base-64 encoded string.
    public func base64Encoded(options: Data.Base64EncodingOptions = []) -> String? {
        return data(using: .utf8)?.base64EncodedString(options: options)
    }
}

extension String {
    public func size(withFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [.font: font])
    }

    public func size(withFont font: UIFont, constrainedToSize: CGSize) -> CGSize {
        let expectedRect = (self as NSString).boundingRect(
            with: constrainedToSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        return expectedRect.size
    }

    /// - seealso: http://stackoverflow.com/a/30040937
    public func numberOfLines(_ font: UIFont, constrainedToSize: CGSize) -> (size: CGSize, numberOfLines: Int) {
        let textStorage = NSTextStorage(string: self, attributes: [.font: font])

        let textContainer = NSTextContainer(size: constrainedToSize)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding = 0

        let layoutManager = NSLayoutManager()
        layoutManager.textStorage = textStorage
        layoutManager.addTextContainer(textContainer)

        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange(location: 0, length: 0)
        var size: CGSize = 0

        while index < layoutManager.numberOfGlyphs {
            numberOfLines += 1
            size += layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange).size
            index = NSMaxRange(lineRange)
        }

        return (size, numberOfLines)
    }
}
