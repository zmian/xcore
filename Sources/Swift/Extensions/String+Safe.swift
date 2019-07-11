//
// String+Safe.swift
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
}

// MARK: - Ranges

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

// MARK: - `hasIndex(:)`

extension String {
    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeUpTo<Int>) -> Bool {
        return range.upperBound >= firstIndex && range.upperBound < lastIndex
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeThrough<Int>) -> Bool {
        return range.upperBound >= firstIndex && range.upperBound < lastIndex
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: PartialRangeFrom<Int>) -> Bool {
        return range.lowerBound >= firstIndex && range.lowerBound < lastIndex
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: CountableRange<Int>) -> Bool {
        return range.lowerBound >= firstIndex && range.upperBound < lastIndex
    }

    /// Return true iff range is in `self`.
    private func hasIndex(_ range: CountableClosedRange<Int>) -> Bool {
        return range.lowerBound >= firstIndex && range.upperBound < lastIndex
    }
}

extension String {
    private var firstIndex: Int {
        return startIndex.utf16Offset(in: self)
    }

    private var lastIndex: Int {
        return endIndex.utf16Offset(in: self)
    }
}
