//
// SwiftExtensions.swift
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

public extension String {
    /// Allows us to use String[index] notation
    public subscript(index: Int) -> String? {
        let array = Array(characters)
        return array.indices ~= index ? String(array[index]) : nil
    }

    /// var string = "abcde"[0...2] // string equals "abc"
    /// var string2 = "fghij"[2..4] // string2 equals "hi"
    public subscript (r: Range<Int>) -> String {
        let start = startIndex.advancedBy(r.startIndex)
        let end   = startIndex.advancedBy(r.endIndex)
        return substringWithRange(Range(start: start, end: end))
    }

    public var count: Int { return characters.count }

    /// Returns an array of strings at new lines.
    public var lines: [String] {
        return componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
    }

    /// Trims white space and new line characters in `self`.
    @warn_unused_result
    public func trim() -> String {
        return replace("[ ]+", replacement: " ").stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
    }

    /// Searches for pattern matches in the string and replaces them with replacement.
    @warn_unused_result
    public func replace(pattern: String, replacement: String, options: NSStringCompareOptions = .RegularExpressionSearch) -> String {
        return stringByReplacingOccurrencesOfString(pattern, withString: replacement, options: options, range: nil)
    }

    /// Returns `true` iff `value` is in `self`.
    @warn_unused_result
    public func contains(value: String, options: NSStringCompareOptions = []) -> Bool {
        return rangeOfString(value, options: options) != nil
    }

    /// Determine whether the string is a valid url.
    public var isValidUrl: Bool {
        if let url = NSURL(string: self) where url.host != nil {
            return true
        }

        return false
    }

    /// `true` iff `self` contains no characters and blank spaces (e.g., \n, " ").
    public var isBlank: Bool {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).isEmpty
    }

    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: "")
    }

    public func localized(comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: NSBundle.mainBundle(), value: "", comment: comment)
    }

    /// Drops the given `prefix` from `self`.
    ///
    /// - returns: String without the specified `prefix` or nil if `prefix` doesn't exists.
    @warn_unused_result
    public func stripPrefix(prefix: String) -> String? {
        guard let prefixRange = rangeOfString(prefix) else { return nil }
        let attributeRange  = Range(start: prefixRange.endIndex, end: endIndex)
        let attributeString = substringWithRange(attributeRange)
        return attributeString
    }

    public var lastPathComponent: String { return (self as NSString).lastPathComponent }
    public var stringByDeletingLastPathComponent: String { return (self as NSString).stringByDeletingLastPathComponent }
    public var stringByDeletingPathExtension: String { return (self as NSString).stringByDeletingPathExtension }
    public var pathExtension: String { return (self as NSString).pathExtension }
    public func sizeWithFont(font: UIFont) -> CGSize {
        return (self as NSString).sizeWithAttributes([NSFontAttributeName: font])
    }

    /// Decode specified `Base64` string
    public init?(base64: String) {
        if let decodedData   = NSData(base64EncodedString: base64, options: NSDataBase64DecodingOptions(rawValue: 0)),
           let decodedString = String(data: decodedData, encoding: NSUTF8StringEncoding) {
            self = decodedString
        } else {
            return nil
        }
    }

    /// Returns `Base64` representation of `self`.
    public var base64: String? {
        return dataUsingEncoding(NSUTF8StringEncoding)?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
}

public extension Int {
    @warn_unused_result
    public func padding(amountToPad: Int) -> String {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.paddingPosition = .BeforePrefix
        numberFormatter.paddingCharacter = "0"
        numberFormatter.minimumIntegerDigits = amountToPad
        return numberFormatter.stringFromNumber(self)!
    }
}

extension Array {
    /// Remove object by value.
    ///
    /// - returns: true if removed; false otherwise
    public mutating func removeObject<U: Equatable>(object: U) -> Bool {
        for (idx, objectToCompare) in enumerate() {
            if let to = objectToCompare as? U where object == to {
                removeAtIndex(idx)
                return true
            }
        }
        return false
    }

    /// Remove objects by value.
    public mutating func removeObjects<U: Equatable>(objects: [U]) {
        objects.forEach { removeObject($0) }
    }

    /// Returns a random subarray of given length
    ///
    /// - parameter size: Length
    /// - returns:        Random subarray of length n
    @warn_unused_result
    public func randomElements(size: Int = 1) -> Array {
        if size >= count {
            return self
        }

        let index = Int(arc4random_uniform(UInt32(count - size)))
        return Array(self[index..<(size + index)])
    }
}

extension CollectionType {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    @warn_unused_result
    public func at(index: Index) -> Generator.Element? {
        return indices.contains(index) ? self[index] : nil
    }
}

extension CollectionType where Index: BidirectionalIndexType {
    /// Returns the `SubSequence` at the specified range iff it is within bounds, otherwise nil.
    @warn_unused_result
    public func at(range: Range<Index>) -> SubSequence? {
        return indices.contains(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    @warn_unused_result
    public func contains(range: Range<Index>) -> Bool {
        return indices.contains(range.startIndex) && indices.contains(range.endIndex.predecessor())
    }
}

extension RangeReplaceableCollectionType {
    public mutating func appendAll(collection: [Generator.Element]) {
        appendContentsOf(collection)
    }
}

extension SequenceType where Generator.Element: Hashable {
    /// Return an `Array` containing only the unique elements of `self` in order.
    @warn_unused_result
    public func unique() -> [Generator.Element] {
        var seen: [Generator.Element: Bool] = [:]
        return filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension SequenceType {
    /// Return an `Array` containing only the unique elements of `self`,
    /// in order, where `unique` criteria is determined by the `uniqueProperty` block.
    ///
    /// - parameter uniqueProperty: `unique` criteria is determined by the value returned by this block.
    ///
    /// - returns: Return an `Array` containing only the unique elements of `self`,
    /// in order, that satisfy the predicate `uniqueProperty`.
    @warn_unused_result
    public func unique<T: Hashable>(uniqueProperty: (Generator.Element) -> T) -> [Generator.Element] {
        var seen: [T: Bool] = [:]
        return filter { seen.updateValue(true, forKey: uniqueProperty($0)) == nil }
    }
}
