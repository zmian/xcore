//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Int

extension Int {
    /// Returns a string representation of the integer, padded with leading zeros to
    /// reach a specified minimum length.
    ///
    /// ```swift
    /// 42.padded(length: 5)  // "00042"
    /// ```
    ///
    /// - Parameter length: The minimum number of digits the resulting string should
    ///   contain.
    /// - Returns: A zero-padded string of the integer.
    public func padded(length: Int) -> String {
        formatted(.number.precision(.integerLength(length...)).grouping(.never))
    }

    /// Returns a random value from `0` to the specified range upper bound.
    public static func random(limit upperBound: Int = .max) -> Self {
        .random(in: 0...upperBound)
    }
}

// MARK: - Map

extension FixedWidthInteger {
    /// Returns an array containing the results of mapping the given closure over
    /// `self`.
    ///
    /// ```swift
    /// let values = 10.map { $0 * 2 }
    /// print(values)
    ///
    /// // prints
    /// [2, 4, 6, 8, 10, 12, 14, 16, 18, 20]
    /// ```
    ///
    /// - Parameter transform: A mapping closure. `transform` accepts an element of
    ///   `self` as its parameter and returns a transformed value of the same or of
    ///   a different type.
    /// - Returns: An array containing the transformed elements of `self`.
    /// - Complexity: O(_n_).
    public func map<T>(transform: (Self) throws -> T) rethrows -> [T] {
        var results = [T]()
        for i in 0..<self {
            try results.append(transform(i + 1))
        }
        return results
    }
}

// MARK: - DigitsCount

extension BinaryInteger {
    /// The number of digits in the integer.
    ///
    /// Returns the count of digits in the absolute value of `self`, ignoring the
    /// negative sign (if present).
    ///
    /// **Usage**
    ///
    /// ```swift
    /// print(12345.digitsCount) // 5
    /// print(0.digitsCount)     // 1 (zero has one digit)
    /// print((-9876).digitsCount) // 4 (negative sign is ignored)
    /// ```
    ///
    /// - Complexity: `O(log n)`, where `n` is the absolute value of `self`.
    public var digitsCount: Int {
        /// Special case: Zero has exactly **one** digit.
        guard self != 0 else {
            return 1
        }

        /// Ignore the negative sign by working with the magnitude.
        var number = magnitude

        /// Counter to keep track of the number of digits.
        var count = 0

        // Iteratively divide `number` by 10, increasing `count` each time,
        // until `number` is reduced to zero.
        while number > 0 {
            number /= 10
            count += 1
        }

        return count
    }
}

// MARK: - Sum

extension Sequence where Iterator.Element: AdditiveArithmetic {
    /// Returns the running sum of all elements in the collection.
    ///
    /// ```swift
    /// [1, 1, 1, 1, 1, 1].runningSum() // -> [1, 2, 3, 4, 5, 6]
    /// ```
    public func runningSum() -> [Iterator.Element] {
        reduce([]) { sums, element in
            sums + [element + (sums.last ?? .zero)]
        }
    }

    /// Returns the sum of all elements in the collection.
    public func sum() -> Element {
        reduce(.zero, +)
    }
}

extension Sequence {
    /// Returns the sum of all elements in the collection using the given closure.
    ///
    /// ```swift
    /// struct Expense {
    ///     let title: String
    ///     let amount: Double
    /// }
    ///
    /// let expenses = [
    ///     Expense(title: "Laptop", amount: 1200),
    ///     Expense(title: "Chair", amount: 1000)
    /// ]
    ///
    /// let totalCost = expenses.sum(\.amount)
    /// print(totalCost)
    ///
    /// // prints
    /// 2200.0
    /// ```
    public func sum<T: AdditiveArithmetic>(_ transform: (Element) throws -> T) rethrows -> T {
        try reduce(T.zero) { sum, element in
            sum + (try transform(element))
        }
    }
}

// MARK: - Average

extension Collection where Iterator.Element: BinaryInteger {
    /// Returns the average of all elements in the collection.
    public func average() -> Double {
        isEmpty ? 0 : Double(sum()) / Double(count)
    }
}

extension Collection where Element: BinaryFloatingPoint {
    /// Returns the average of all elements in the collection.
    public func average() -> Element {
        isEmpty ? 0 : sum() / Element(count)
    }
}

extension Collection<Decimal> {
    /// Returns the average of all elements in the collection.
    public func average() -> Decimal {
        isEmpty ? 0 : sum() / Decimal(count)
    }
}

// MARK: - Comparable

extension Comparable {
    /// Returns a copy of `self` clamped to the given limiting range.
    ///
    /// ```swift
    /// 30.clamped(to: 0...10) // returns 10
    /// 3.0.clamped(to: 0.0...10.0) // returns 3.0
    /// "z".clamped(to: "a"..."x") // returns "x"
    /// ```
    public func clamped(to limits: ClosedRange<Self>) -> Self {
        min(max(self, limits.lowerBound), limits.upperBound)
    }
}

// MARK: - Pi

extension FloatingPoint {
    public static var pi2: Self {
        .pi / 2
    }

    public static var pi4: Self {
        .pi / 4
    }
}

// MARK: - Integral & Fractional Parts

extension FloatingPoint {
    /// The whole part of the floating point.
    ///
    /// ```swift
    /// let amount = 120.30
    /// // 120 - integral part
    /// // 30 - fractional part
    /// ```
    public var integralPart: Self {
        rounded(.towardZero)
    }

    /// The fractional part of the floating point.
    ///
    /// ```swift
    /// let amount = 120.30
    /// // 120 - integral part
    /// // 30 - fractional part
    /// ```
    public  var fractionalPart: Self {
        self - integralPart
    }

    /// A Boolean property indicating whether the fractional part of the floating
    /// point is `0`.
    ///
    /// ```swift
    /// print(120.30.isFractionalPartZero)
    /// // Prints "false"
    ///
    /// print(120.00.isFractionalPartZero)
    /// // Prints "true"
    /// ```
    public var isFractionalPartZero: Bool {
        truncatingRemainder(dividingBy: 1) == 0
    }
}

// MARK: - Rounded with fractionDigits

extension BinaryFloatingPoint {
    /// Returns `self` rounded to an integral value using the specified rounding
    /// fraction digits.
    ///
    /// ```swift
    /// 1      → "1.00"
    /// 1.09   → "1.09"
    /// 1.9    → "1.90"
    /// 2.1345 → "2.13"
    /// 2.1355 → "2.14"
    /// ```
    ///
    /// - Parameters:
    ///   - rule: The rounding rule to use.
    ///   - fractionDigits: The number of digits result can have after its decimal
    ///     point.
    public func rounded(
        _ rule: FloatingPointRoundingRule = .toNearestOrAwayFromZero,
        fractionDigits: Int
    ) -> Self {
        let multiplier: Self = pow_xc(10.0, fractionDigits)
        return (self * multiplier).rounded(rule) / multiplier
    }
}

// MARK: - Largest Remainder Round

extension Sequence where Element: BinaryFloatingPoint {
    /// Rounds a list of percentage values (0...1) while keeping it's sum equal to
    /// one.
    ///
    /// ```swift
    /// [0.42857, 0.28571, 0.28571].largestRemainderRound() // [0.43, 0.29, 0.28]
    /// ```
    public func largestRemainderRound() -> [Element] {
        let percentages = self

        func getRemainder(value: Element) -> Element {
            value - floor(value)
        }

        /// 1. Transform each value into `Remainder` struct calculating
        /// integer value and decimal part.
        /// Add index for later sort
        var result: [PercentageItem<Element>] =
            percentages
                .enumerated()
                .map { idx, percentage in
                    let percentageBase = percentage * 100
                    return PercentageItem(
                        floor: floor(percentageBase),
                        remainder: getRemainder(value: percentageBase),
                        index: idx
                    )
                }
                .sorted {
                    $0.remainder > $1.remainder
                }

        /// 2. Calculate sum of the integral part of each value and the delta
        /// to 100.
        let delta = 100 - Int(result.sum(\.floor))

        /// 3. Based on the remainder sort (starting by highest remainder)
        /// keep adding 1 until we reach sum of 100
        for idx in 0..<delta where idx < result.count - 1 {
            result[idx].floor += 1
        }

        /// 4. Return integer values dividing by 100 to return to 0...1 percentage
        /// notation
        return
            result
                .sorted { $0.index < $1.index }
                .map { $0.floor / 100 }
    }
}

private struct PercentageItem<Element> {
    var floor: Element
    let remainder: Element
    let index: Int
}
