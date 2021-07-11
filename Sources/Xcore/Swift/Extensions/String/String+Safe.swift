//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension StringProtocol {
    public func index(from: Int) -> Index? {
        guard
            from > -1,
            let index = self.index(startIndex, offsetBy: from, limitedBy: endIndex)
        else {
            return nil
        }

        return index
    }

    /// Returns the element at the specified `index` iff it is within bounds,
    /// otherwise `nil`.
    public func at(_ index: Int) -> String? {
        guard let index = self.index(from: index), let character = at(index) else {
            return nil
        }

        return String(character)
    }
}

// MARK: - `at(:)`

extension String {
    /// Returns the `Substring` at the specified range iff it is within bounds;
    /// otherwise, `nil`.
    ///
    /// e.g., `"Hello world"[..<5] // → "Hello"`
    public func at(_ range: PartialRangeUpTo<Int>) -> Substring? {
        hasIndex(range) ? self[range] : nil
    }

    /// Returns the `Substring` at the specified range iff it is within bounds;
    /// otherwise, `nil`.
    ///
    /// e.g., `"Hello world"[...4] // → "Hello"`
    public func at(_ range: PartialRangeThrough<Int>) -> Substring? {
        hasIndex(range) ? self[range] : nil
    }

    /// Returns the `Substring` at the specified range iff it is within bounds;
    /// otherwise, `nil`.
    ///
    /// e.g., `"Hello world"[0...] // → "Hello world"`
    public func at(_ range: PartialRangeFrom<Int>) -> Substring? {
        hasIndex(range) ? self[range] : nil
    }

    /// Returns the `Substring` at the specified range iff it is within bounds;
    /// otherwise, `nil`.
    ///
    /// e.g., `"Hello world"[0..<5] // → "Hello"`
    public func at(_ range: CountableRange<Int>) -> Substring? {
        hasIndex(range) ? self[range] : nil
    }

    /// Returns the `Substring` at the specified range iff it is within bounds;
    /// otherwise, `nil`.
    ///
    /// e.g., `"Hello world"[0...4] // → "Hello"`
    public func at(range: CountableClosedRange<Int>) -> Substring? {
        hasIndex(range) ? self[range] : nil
    }
}

// MARK: - Ranges

extension String {
    /// e.g., `"Hello world"[..<5] // → "Hello"`
    private subscript(range: PartialRangeUpTo<Int>) -> Substring {
        self[..<index(startIndex, offsetBy: range.upperBound)]
    }

    /// e.g., `"Hello world"[...4] // → "Hello"`
    private subscript(range: PartialRangeThrough<Int>) -> Substring {
        self[...index(startIndex, offsetBy: range.upperBound)]
    }

    /// e.g., `"Hello world"[0...] // → "Hello world"`
    private subscript(range: PartialRangeFrom<Int>) -> Substring {
        self[index(startIndex, offsetBy: range.lowerBound)...]
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

// MARK: - `hasIndex(:)`

extension String {
    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeUpTo<Int>) -> Bool {
        range.upperBound >= firstIndex && range.upperBound < lastIndex
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeThrough<Int>) -> Bool {
        range.upperBound >= firstIndex && range.upperBound < lastIndex
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeFrom<Int>) -> Bool {
        range.lowerBound >= firstIndex && range.lowerBound < lastIndex
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: CountableRange<Int>) -> Bool {
        range.lowerBound >= firstIndex && range.upperBound < lastIndex
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: CountableClosedRange<Int>) -> Bool {
        range.lowerBound >= firstIndex && range.upperBound < lastIndex
    }
}

extension String {
    private var firstIndex: Int {
        startIndex.utf16Offset(in: self)
    }

    private var lastIndex: Int {
        endIndex.utf16Offset(in: self)
    }
}
