//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension StringProtocol {
    /// Returns `true` iff `value` is in `self`.
    public func contains<T: StringProtocol>(_ value: T, options: String.CompareOptions = []) -> Bool {
        range(of: value, options: options) != nil
    }

    /// A uppercase representation of the first character in string.
    public func uppercasedFirst() -> String {
        prefix(1).uppercased() + dropFirst()
    }

    /// A lowercase representation of the first character in string.
    public func lowercasedFirst() -> String {
        prefix(1).lowercased() + dropFirst()
    }

    /// A camel case representation of the string.
    public func camelcased() -> String {
        parts().lazy.enumerated().map {
            if $0.offset == 0 {
                return $0.element.lowercasedFirst()
            }

            return $0.element.uppercasedFirst()
        }.joined()
    }

    /// A snake case representation of the string.
    public func snakecased() -> String {
        parts().joined(separator: "_")
    }

    private func parts() -> [String] {
        guard !isEmpty else {
            return []
        }

        let normalized: String

        // If all uppercase then lowercase everything.
        if rangeOfCharacter(from: .lowercaseLetters, options: [], range: range) == nil {
            normalized = lowercased()
        } else {
            normalized = replacingOccurrences(of: "(?=\\S)[A-Z]", with: " $0", options: .regularExpression, range: range).lowercased()
        }

        return normalized.components(separatedBy: CharacterSet.alphanumerics.inverted).filter { !$0.isEmpty }
    }

    fileprivate var range: Range<String.Index> {
        Range(uncheckedBounds: (startIndex, endIndex))
    }
}

extension String {
    // Credit: https://gist.github.com/devxoul/a1e6822def36f75d0bc5
    //
    /// A title case representation of the string.
    public func titlecased() -> String {
        if count <= 1 {
            return uppercased()
        }

        // If all uppercase then lowercase everything and title case the first character.
        if rangeOfCharacter(from: .lowercaseLetters, options: [], range: range) == nil {
            return lowercased().uppercasedFirst()
        }

        let regex = try! NSRegularExpression(pattern: "(?=\\S)[A-Z]")
        let range = NSRange(location: 1, length: 1)

        var titlecased = regex.stringByReplacingMatches(in: self, range: range, withTemplate: " $0")

        for i in titlecased.indices {
            if i == titlecased.startIndex || titlecased[titlecased.index(before: i)] == " " {
                titlecased.replaceSubrange(i...i, with: titlecased[i].uppercased())
            }
        }

        return titlecased
    }
}

extension String {
    /// Returns a new string created by replacing all characters in the string not
    /// in the specified set with percent encoded characters.
    ///
    /// The default value is `.urlQueryAllowed`.
    ///
    /// - Parameter allowedCharacters: The allowed character set.
    public func urlEscaped(allowed allowedCharacters: CharacterSet = .urlQueryAllowed) -> String? {
        addingPercentEncoding(withAllowedCharacters: allowedCharacters)
    }

    /// Returns an array of strings at new lines.
    public func lines() -> [String] {
        components(separatedBy: .newlines)
    }

    /// Normalize multiple whitespaces and trim whitespaces and new line characters
    /// in `self`.
    public func trimmed() -> String {
        replacing("[ ]+", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Searches for pattern matches in the string and replaces them with
    /// replacement.
    public func replacing(_ pattern: String, with: String, options: String.CompareOptions = .regularExpression) -> String {
        replacingOccurrences(of: pattern, with: with, options: options, range: nil)
    }

    /// Trim whitespaces from start and end and normalize multiple whitespaces into
    /// one and then replace them with the given string.
    public func replaceWhitespaces(with string: String) -> String {
        trimmingCharacters(in: .whitespaces).replacing("[ ]+", with: string)
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
        trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Drops the given `prefix` from `self`.
    ///
    /// - Returns: String without the specified `prefix` or unmodified `self` if
    ///   `prefix` doesn't exists.
    public func droppingPrefix(_ prefix: String) -> String {
        guard hasPrefix(prefix) else {
            return self
        }

        return String(dropFirst(prefix.count))
    }

    /// Drops the given `suffix` from `self`.
    ///
    /// - Returns: String without the specified `suffix` or unmodified `self` if
    ///   `suffix` doesn't exists.
    public func droppingSuffix(_ suffix: String) -> String {
        guard hasSuffix(suffix) else {
            return self
        }

        return String(dropLast(suffix.count))
    }

    /// Take last `x` characters from `self`.
    public func take(last: Int) -> String {
        guard count >= last else {
            return self
        }

        return String(dropFirst(count - last))
    }
}

// MARK: - Random

extension String {
    /// Returns random elements of the string of the given length.
    ///
    /// - Parameter length: Number of random elements to return.
    public func random(length: Int) -> String {
        String((0..<length).map { _ in randomElement()! })
    }

    /// Returns a random alphanumerics string of the given length.
    public static func randomAlphanumerics(length: Int) -> String {
        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
            .random(length: length)
    }
}

// MARK: - Truncation

extension String {
    public enum TruncationPosition {
        /// Truncate at head: `"...wxyz"`
        case head
        /// Truncate middle: `"ab...yz"`
        case middle
        /// Truncate at tail: `"abcd..."`
        case tail
    }

    /// Truncates the string to the specified length and appends an ellipsis string
    /// at the given truncation position.
    ///
    /// ```swift
    /// let result = "This is a really long string".truncate(10)
    /// print(result)
    /// // "This is a ..."
    /// ```
    ///
    /// - Parameters:
    ///   - length: The maximum length of the string.
    ///   - position: The truncation position option.
    ///   - ellipsis: A `String` that will be appended in the truncation position.
    public func truncate(_ length: Int, position: TruncationPosition = .tail, ellipsis: String = "...") -> String {
        guard count > length else { return self }

        switch position {
            case .head:
                return ellipsis + suffix(length)
            case .middle:
                let count = Double(length - ellipsis.count) / 2
                let headCount = Int(ceil(count))
                let tailCount = Int(floor(count))
                return "\(prefix(headCount))\(ellipsis)\(suffix(tailCount))"
            case .tail:
                return prefix(length) + ellipsis
        }
    }
}

// MARK: - NSString

extension String {
    private var nsString: NSString {
        self as NSString
    }

    public var lastPathComponent: String {
        nsString.lastPathComponent
    }

    public var deletingLastPathComponent: String {
        nsString.deletingLastPathComponent
    }

    public var deletingPathExtension: String {
        nsString.deletingPathExtension
    }

    public var pathExtension: String {
        nsString.pathExtension
    }

    /// Returns a new string made by appending to the receiver a given path
    /// component.
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
    ///   preceded if necessary by a path separator.
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
            return results.map {
                nsString.substring(with: $0.range)
            }
        } catch {
            #if DEBUG
            print("Invalid regex: \(error.localizedDescription)")
            #endif
            return []
        }
    }

    public func isMatch(_ pattern: String) -> Bool {
        !regex(pattern).isEmpty
    }
}

extension String {
    /// Returns the height of string when drawn with the given font.
    public static func height(font: UIFont) -> CGFloat {
        "Sphinx".size(withFont: font).height
    }

    /// Returns the bounding box size the receiver occupies when drawn with the
    /// given font.
    ///
    /// - Parameter font: The font to use for calculating size.
    public func size(withFont font: UIFont) -> CGSize {
        nsString.size(withAttributes: [.font: font])
    }

    /// Returns the height of the string constrained by specified font and size.
    ///
    /// - Note: If you would like to calculate size in one dimension only you can do
    ///   so by using `.greatestFiniteMagnitude` value for the opposite dimension.
    ///
    /// **For example:**
    ///
    /// `CGSize(width: 20, height: .greatestFiniteMagnitude)`
    ///
    /// - Parameters:
    ///   - font: The font to use for calculating size.
    ///   - options: The rendering options for the string when it is drawn.
    ///   - constrainedToSize: The maximum size the string will be drawn in.
    public func size(
        withFont font: UIFont,
        options: NSStringDrawingOptions = .usesLineFragmentOrigin,
        constrainedToSize: CGSize
    ) -> CGSize {
        let expectedRect = nsString.boundingRect(
            with: constrainedToSize,
            options: options,
            attributes: [.font: font],
            context: nil
        )

        return expectedRect.size
    }

    /// - SeeAlso: http://stackoverflow.com/a/30040937
    public func numberOfLines(
        _ font: UIFont,
        constrainedToSize: CGSize
    ) -> (size: CGSize, numberOfLines: Int) {
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
        var size: CGSize = .zero

        while index < layoutManager.numberOfGlyphs {
            numberOfLines += 1
            size += layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange).size
            index = NSMaxRange(lineRange)
        }

        return (size, numberOfLines)
    }
}

extension String {
    /// Returns `nil` if the string is empty.
    public var nilIfEmpty: String? {
        isEmpty ? nil : self
    }

    /// Returns `nil` if the string is blank.
    public var nilIfBlank: String? {
        isBlank ? nil : self
    }
}
