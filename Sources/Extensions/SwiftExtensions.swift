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
    /// var string2 = "fghij"[2..<4] // string2 equals "hi"
    public subscript (r: Range<Int>) -> String {
        let start = characters.index(startIndex, offsetBy: r.lowerBound)
        let end   = characters.index(startIndex, offsetBy: r.upperBound)
        return substring(with: Range(start..<end))
    }

    public var count: Int { return characters.count }

    /// Returns an array of strings at new lines.
    public var lines: [String] {
        return components(separatedBy: .newlines)
    }

    /// Trims white space and new line characters in `self`.
    public func trim() -> String {
        return replace("[ ]+", replacement: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Searches for pattern matches in the string and replaces them with replacement.
    public func replace(_ pattern: String, replacement: String, options: NSString.CompareOptions = .regularExpression) -> String {
        return replacingOccurrences(of: pattern, with: replacement, options: options, range: nil)
    }

    /// Returns `true` iff `value` is in `self`.
    public func contains(_ value: String, options: NSString.CompareOptions = []) -> Bool {
        return range(of: value, options: options) != nil
    }

    /// Determine whether the string is a valid url.
    public var isValidUrl: Bool {
        if let url = URL(string: self) , url.host != nil {
            return true
        }

        return false
    }

    /// `true` iff `self` contains no characters and blank spaces (e.g., \n, " ").
    public var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    public var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }

    public func localized(_ comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: comment)
    }

    /// Drops the given `prefix` from `self`.
    ///
    /// - returns: String without the specified `prefix` or nil if `prefix` doesn't exists.
    public func stripPrefix(_ prefix: String) -> String? {
        guard let prefixRange = range(of: prefix) else { return nil }
        let attributeRange  = Range(prefixRange.upperBound..<endIndex)
        let attributeString = substring(with: attributeRange)
        return attributeString
    }

    public var lastPathComponent: String { return (self as NSString).lastPathComponent }
    public var stringByDeletingLastPathComponent: String { return (self as NSString).deletingLastPathComponent }
    public var stringByDeletingPathExtension: String { return (self as NSString).deletingPathExtension }
    public var pathExtension: String { return (self as NSString).pathExtension }

    /// Decode specified `Base64` string
    public init?(base64: String) {
        if let decodedData   = Data(base64Encoded: base64, options: Data.Base64DecodingOptions(rawValue: 0)),
           let decodedString = String(data: decodedData, encoding: .utf8) {
            self = decodedString
        } else {
            return nil
        }
    }

    /// Returns `Base64` representation of `self`.
    public var base64: String? {
        return data(using: .utf8)?.base64EncodedString(options: Data.Base64EncodingOptions(rawValue: 0))
    }
}

public extension String {
    public func sizeWithFont(_ font: UIFont) -> CGSize {
        return (self as NSString).size(attributes: [NSFontAttributeName: font])
    }

    public func sizeWithFont(_ font: UIFont, constrainedToSize: CGSize) -> CGSize {
        let expectedRect = (self as NSString).boundingRect(with: constrainedToSize, options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: font], context: nil)
        return expectedRect.size
    }

    /// - seealso: http://stackoverflow.com/a/30040937
    public func numberOfLines(_ font: UIFont, constrainedToSize: CGSize) -> (size: CGSize, numberOfLines: Int) {
        let textStorage = NSTextStorage(string: self, attributes: [NSFontAttributeName: font])

        let textContainer                  = NSTextContainer(size: constrainedToSize)
        textContainer.lineBreakMode        = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding  = 0

        let layoutManager = NSLayoutManager()
        layoutManager.textStorage = textStorage
        layoutManager.addTextContainer(textContainer)

        var numberOfLines = 0
        var index         = 0
        var lineRange     = NSRange(location: 0, length: 0)
        var size          = CGSize.zero

        while index < layoutManager.numberOfGlyphs {
            numberOfLines += 1
            size += layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange).size
            index = NSMaxRange(lineRange)
        }

        return (size, numberOfLines)
    }
}

public extension Int {
    private static let numberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.paddingPosition = .beforePrefix
        numberFormatter.paddingCharacter = "0"
        return numberFormatter
    }()

    public func pad(by amount: Int) -> String {
        Int.numberFormatter.minimumIntegerDigits = amount
        return Int.numberFormatter.string(from: NSNumber(value: self))!
    }
}

/*
extension IntervalType {
    /// Returns a random element from `self`.
    ///
    /// ```
    /// (0.0...1.0).random()   // 0.112358
    /// (-1.0..<68.5).random() // 26.42
    /// ```
    public func random() -> Bound {
        guard
            let start = self.start as? Double,
            let end = self.end as? Double
        else {
            return self.start
        }

        let range = end - start
        return ((Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)) * range + start) as! Bound
    }
}
*/

extension Int {
    /// Returns an `Array` containing the results of mapping `transform`
    /// over `self`.
    ///
    /// - complexity: O(N).
    ///
    /// ```
    /// let values = 10.map { $0 * 2 }
    /// print(values)
    ///
    /// // prints
    /// [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
    /// ```
    public func map<T>(transform: (Int) throws -> T) rethrows -> [T] {
        var results = [T]()
        for i in 0..<self {
            try results.append(transform(i + 1))
        }
        return results
    }
}

extension Array {
    /// Returns a random subarray of given length.
    ///
    /// - parameter size: Length
    /// - returns:        Random subarray of length n.
    public func randomElements(_ size: Int = 1) -> Array {
        if size >= count {
            return self
        }

        let index = Int(arc4random_uniform(UInt32(count - size)))
        return Array(self[index..<(size + index)])
    }

    /// Returns a random element from `self`.
    public func randomElement() -> Element {
        let randomIndex = Int(arc4random()) % count
        return self[randomIndex]
    }

    /// Split array by chunks of given size.
    ///
    /// ```
    /// let arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]
    /// let chunks = arr.splitBy(5)
    /// print(chunks) // [[1, 2, 3, 4, 5], [6, 7, 8, 9, 10], [11, 12]]
    /// ```
    /// - seealso: https://gist.github.com/ericdke/fa262bdece59ff786fcb
    public func splitBy(_ subSize: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: subSize).map { startIndex in
            let endIndex = index(startIndex, offsetBy: subSize, limitedBy: count) ?? startIndex + (count - startIndex)
            return Array(self[startIndex..<endIndex])
        }
    }
}

public extension Array where Element: Equatable {
    /// Remove element by value.
    ///
    /// - returns: true if removed; false otherwise
    @discardableResult
    public mutating func remove(_ element: Element) -> Bool {
        for (index, elementToCompare) in enumerated() {
            if element == elementToCompare {
                self.remove(at: index)
                return true
            }
        }
        return false
    }

    /// Remove elements by value.
    public mutating func remove(_ elements: [Element]) {
        elements.forEach { remove($0) }
    }

    /// Move an element in `self` to a specific index.
    ///
    /// - parameter element: The element in `self` to move.
    /// - parameter toIndex: An index locating the new location of the element in `self`.
    ///
    /// - returns: true if moved; false otherwise.
    @discardableResult
    public mutating func move(_ element: Element, toIndex index: Int) -> Bool {
        guard remove(element) else { return false }
        insert(element, at: index)
        return true
    }
}

extension Collection {
    /// Returns the element at the specified index iff it is within bounds, otherwise nil.
    public func at(_ index: Index) -> Iterator.Element? {
        return contains(index) ? self[index] : nil
    }

    /// Return true iff index is in `self`.
    public func contains(_ index: Index) -> Bool {
        return index >= startIndex && index < endIndex
    }
}

extension Collection where Index: Comparable {
    /// Returns the `SubSequence` at the specified range iff it is within bounds, otherwise nil.
    public func at(_ range: Range<Index>) -> SubSequence? {
        return contains(range) ? self[range] : nil
    }

    /// Return true iff range is in `self`.
    public func contains(_ range: Range<Index>) -> Bool {
        return range.lowerBound >= startIndex && range.upperBound <= endIndex
    }
}

extension RangeReplaceableCollection {
    public mutating func appendAll(_ collection: [Iterator.Element]) {
        append(contentsOf: collection)
    }
}

extension Sequence where Iterator.Element: Hashable {
    /// Return an `Array` containing only the unique elements of `self` in order.
    public func unique() -> [Iterator.Element] {
        var seen: [Iterator.Element: Bool] = [:]
        return filter { seen.updateValue(true, forKey: $0) == nil }
    }
}

extension Sequence {
    /// Return an `Array` containing only the unique elements of `self`,
    /// in order, where `unique` criteria is determined by the `uniqueProperty` block.
    ///
    /// - parameter uniqueProperty: `unique` criteria is determined by the value returned by this block.
    ///
    /// - returns: Return an `Array` containing only the unique elements of `self`,
    /// in order, that satisfy the predicate `uniqueProperty`.
    public func unique<T: Hashable>(_ uniqueProperty: (Iterator.Element) -> T) -> [Iterator.Element] {
        var seen: [T: Bool] = [:]
        return filter { seen.updateValue(true, forKey: uniqueProperty($0)) == nil }
    }
}

public extension Array where Element: Hashable {
    /// Modify `self` in-place such that only the unique elements of `self` in order are remaining.
    public mutating func uniqueInPlace() {
        self = unique()
    }

    /// Modify `self` in-place such that only the unique elements of `self` in order are remaining,
    /// where `unique` criteria is determined by the `uniqueProperty` block.
    ///
    /// - parameter uniqueProperty: `unique` criteria is determined by the value returned by this block.
    public mutating func uniqueInPlace<T: Hashable>(_ uniqueProperty: (Element) -> T) {
        self = unique(uniqueProperty)
    }
}

public extension Dictionary {
    public mutating func unionInPlace(_ dictionary: Dictionary) {
        dictionary.forEach { updateValue($1, forKey: $0) }
    }

    public func union(_ dictionary: Dictionary) -> Dictionary {
        var dictionary = dictionary
        dictionary.unionInPlace(self)
        return dictionary
    }
}

extension Double {
    // Adopted from: http://stackoverflow.com/a/35504720
    fileprivate static let abbrevationNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()
    fileprivate typealias Abbrevation = (suffix: String, threshold: Double, divisor: Double)
    fileprivate static let abbreviations: [Abbrevation] = [
                                       ("",                0,              1),
                                       ("K",           1_000,          1_000),
                                       ("K",         100_000,          1_000),
                                       ("M",         499_000,      1_000_000),
                                       ("M",     999_999_999,     10_000_000),
                                       ("B",   1_000_000_000,  1_000_000_000),
                                       ("B", 999_999_999_999, 10_000_000_000)]

    /// Abbreviate `self` to smaller format.
    ///
    /// ```
    /// 987     // -> 987
    /// 1200    // -> 1.2K
    /// 12000   // -> 12K
    /// 120000  // -> 120K
    /// 1200000 // -> 1.2M
    /// 1340    // -> 1.3K
    /// 132456  // -> 132.5K
    /// ```
    /// - returns: Abbreviated version of `self`.
    public func abbreviate() -> String {
        let startValue = abs(self)

        let abbreviation: Abbrevation = {
            var prevAbbreviation = Double.abbreviations[0]

            for tmpAbbreviation in Double.abbreviations {
                if startValue < tmpAbbreviation.threshold {
                    break
                }
                prevAbbreviation = tmpAbbreviation
            }
            return prevAbbreviation
        }()

        let value = self / abbreviation.divisor
        Double.abbrevationNumberFormatter.positiveSuffix = abbreviation.suffix
        Double.abbrevationNumberFormatter.negativeSuffix = abbreviation.suffix
        return Double.abbrevationNumberFormatter.string(from: NSNumber(value: value)) ?? "\(self)"
    }

    fileprivate static let testValues: [Double] = [598, -999, 1000, -1284, 9940, 9980, 39900, 99880, 399880, 999898, 999999, 1456384, 12383474, 987, 1200, 12000, 120000, 1200000, 1340, 132456, 9_000_000_000, 16_000_000, 160_000_000, 999_000_000]
}

extension Sequence where Iterator.Element == Double {
    /// ```
    /// [1, 1, 1, 1, 1, 1].runningSum() // -> [1, 2, 3, 4, 5, 6]
    /// ```
    public func runningSum() -> [Iterator.Element] {
        return self.reduce([]) { sums, element in
            return sums + [element + (sums.last ?? 0)]
        }
    }
}
