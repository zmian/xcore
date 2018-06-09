//
// String+Extensions.swift
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

import Foundation

extension String {
    public var capitalizeFirstCharacter: String {
        return String(prefix(1).capitalized + dropFirst())
    }

    public var urlEscaped: String? {
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
    public func replace(_ pattern: String, with: String, options: NSString.CompareOptions = .regularExpression) -> String {
        return replacingOccurrences(of: pattern, with: with, options: options, range: nil)
    }

    /// Trim whitespaces from start and end and normalize multiple whitespaces into one and then replace them with the given string.
    public func replaceWhitespaces(with string: String) -> String {
        return trimmingCharacters(in: .whitespaces).replace("[ ]+", with: string)
    }

    /// Returns `true` iff `value` is in `self`.
    public func contains(_ value: String, options: NSString.CompareOptions = []) -> Bool {
        return range(of: value, options: options) != nil
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
    /// - Returns: String without the specified `prefix` or nil if `prefix` doesn't exists.
    public func stripPrefix(_ prefix: String) -> String? {
        guard let prefixRange = range(of: prefix) else { return nil }
        let attributeRange = Range(prefixRange.upperBound..<endIndex)
        let attributeString = self[attributeRange]
        return String(attributeString)
    }

    /// Take last `x` characters from `self`.
    public func take(last: Int) -> String {
        guard count >= last else {
            return self
        }

        return String(dropFirst(count - last))
    }
}

// MARK: NSString

extension String {
    private var nsString: NSString {
        return self as NSString
    }

    public var lastPathComponent: String {
        return nsString.lastPathComponent
    }

    public var stringByDeletingLastPathComponent: String {
        return nsString.deletingLastPathComponent
    }

    public var stringByDeletingPathExtension: String {
        return nsString.deletingPathExtension
    }

    public var pathExtension: String {
        return nsString.pathExtension
    }
}

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

// MARK: Localization

extension String {
    // TODO: Add more customization to use these methods instead of secondary library
    private var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }

    private func localized(_ comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: comment)
    }
}

// MARK: Base64 Support

extension String {
    /// Decode specified `Base64` string
    public init?(base64: String) {
        guard
            let decodedData = Data(base64Encoded: base64),
            let decodedString = String(data: decodedData, encoding: .utf8)
        else { return nil }
        self = decodedString
    }

    /// Returns `Base64` representation of `self`.
    public var base64: String? {
        return data(using: .utf8)?.base64EncodedString()
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
        var size = CGSize.zero

        while index < layoutManager.numberOfGlyphs {
            numberOfLines += 1
            size += layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange).size
            index = NSMaxRange(lineRange)
        }

        return (size, numberOfLines)
    }
}

// MARK: Range Expressions

extension StringProtocol {
    public func index(from: Int) -> Index? {
        guard from > -1, let index = self.index(startIndex, offsetBy: from, limitedBy: endIndex) else {
            return nil
        }

        return index
    }

    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public func at(_ index: Int) -> String? {
        guard let index = self.index(from: index), let character = at(index) else {
            return nil
        }

        return String(character)
    }
}

extension String {
    /// e.g., `"Hello world"[..<5] // → "Hello"`
    private subscript(range: PartialRangeUpTo<Int>) -> Substring {
        return self[..<index(startIndex, offsetBy: range.upperBound)]
    }

    /// e.g., `"Hello world"[...4] // → "Hello"`
    private subscript(range: PartialRangeThrough<Int>) -> Substring {
        return self[...index(startIndex, offsetBy: range.upperBound)]
    }

    /// e.g., `"Hello world"[0...] // → "Hello world"`
    private subscript(range: PartialRangeFrom<Int>) -> Substring {
        return self[index(startIndex, offsetBy: range.lowerBound)...]
    }

    /// e.g., `"Hello world"[0..<5] // → "Hello"`
    private subscript(range: CountableRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return self[start..<end]
    }

    /// e.g., `"Hello world"[0...4] // → "Hello"`
    private subscript(range: CountableClosedRange<Int>) -> Substring {
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)
        return self[start...end]
    }
}

extension String {
    /// Returns the `Substring` at the specified range iff it is within bounds, otherwise `nil`.
    ///
    /// e.g., `"Hello world"[..<5] // → "Hello"`
    public func at(_ range: PartialRangeUpTo<Int>) -> Substring? {
        return hasIndex(range) ? self[range] : nil
    }

    /// Returns the `Substring` at the specified range iff it is within bounds, otherwise `nil`.
    ///
    /// e.g., `"Hello world"[...4] // → "Hello"`
    public func at(_ range: PartialRangeThrough<Int>) -> Substring? {
        return hasIndex(range) ? self[range] : nil
    }

    /// Returns the `Substring` at the specified range iff it is within bounds, otherwise `nil`.
    ///
    /// e.g., `"Hello world"[0...] // → "Hello world"`
    public func at(_ range: PartialRangeFrom<Int>) -> Substring? {
        return hasIndex(range) ? self[range] : nil
    }

    /// Returns the `Substring` at the specified range iff it is within bounds, otherwise `nil`.
    ///
    /// e.g., `"Hello world"[0..<5] // → "Hello"`
    public func at(_ range: CountableRange<Int>) -> Substring? {
        return hasIndex(range) ? self[range] : nil
    }

    /// Returns the `Substring` at the specified range iff it is within bounds, otherwise `nil`.
    ///
    /// e.g., `"Hello world"[0...4] // → "Hello"`
    public func at(range: CountableClosedRange<Int>) -> Substring? {
        return hasIndex(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeUpTo<Int>) -> Bool {
        return range.upperBound >= startIndex.encodedOffset && range.upperBound < endIndex.encodedOffset
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeThrough<Int>) -> Bool {
        return range.upperBound >= startIndex.encodedOffset && range.upperBound < endIndex.encodedOffset
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeFrom<Int>) -> Bool {
        return range.lowerBound >= startIndex.encodedOffset && range.lowerBound < endIndex.encodedOffset
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: CountableRange<Int>) -> Bool {
        return range.lowerBound >= startIndex.encodedOffset && range.upperBound < endIndex.encodedOffset
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: CountableClosedRange<Int>) -> Bool {
        return range.lowerBound >= startIndex.encodedOffset && range.upperBound < endIndex.encodedOffset
    }
}
