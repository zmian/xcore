//
// Numbers+Extensions.swift
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

// MARK: Int

extension Int {
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

extension Int {
    /// Returns an `Array` containing the results of mapping `transform`
    /// over `self`.
    ///
    /// - complexity: O(N).
    ///
    /// ```swift
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

extension SignedInteger {
    public var digitsCount: Self {
        return numberOfDigits(in: self)
    }

    private func numberOfDigits(in number: Self) -> Self {
        if abs(number) < 10 {
            return 1
        } else {
            return 1 + numberOfDigits(in: number / 10)
        }
    }
}

extension FloatingPoint {
    public static var pi2: Self {
        return .pi / 2
    }

    public static var pi4: Self {
        return .pi / 4
    }
}

/*
extension IntervalType {
    /// Returns a random element from `self`.
    ///
    /// ```swift
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

extension Double {
    // Adopted from: http://stackoverflow.com/a/35504720
    private static let abbrevationNumberFormatter: NumberFormatter = {
        let numberFormatter = NumberFormatter()
        numberFormatter.allowsFloats = true
        numberFormatter.minimumIntegerDigits = 1
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter
    }()
    private typealias Abbrevation = (suffix: String, threshold: Double, divisor: Double)
    private static let abbreviations: [Abbrevation] = [
                                       ("",                0,              1),
                                       ("K",           1_000,          1_000),
                                       ("K",         100_000,          1_000),
                                       ("M",         499_000,      1_000_000),
                                       ("M",     999_999_999,     10_000_000),
                                       ("B",   1_000_000_000,  1_000_000_000),
                                       ("B", 999_999_999_999, 10_000_000_000)]

    /// Abbreviate `self` to smaller format.
    ///
    /// ```swift
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

    private static let testValues: [Double] = [598, -999, 1000, -1284, 9940, 9980, 39900, 99880, 399880, 999898, 999999, 1456384, 12383474, 987, 1200, 12000, 120000, 1200000, 1340, 132456, 9_000_000_000, 16_000_000, 160_000_000, 999_000_000]
}

extension Sequence where Iterator.Element == Double {
    /// ```swift
    /// [1, 1, 1, 1, 1, 1].runningSum() // -> [1, 2, 3, 4, 5, 6]
    /// ```
    public func runningSum() -> [Iterator.Element] {
        return self.reduce([]) { sums, element in
            return sums + [element + (sums.last ?? 0)]
        }
    }
}
