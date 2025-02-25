//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Duration {
    /// Returns the value of duration in fractional seconds.
    ///
    /// This property extracts the seconds component from `Duration` to create a
    /// `TimeInterval` value, making it easier to use `Duration` with UIKit or older
    /// APIs expecting `TimeInterval`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let duration = Duration.seconds(2.5)
    /// let timeInterval = duration.seconds
    /// print(timeInterval) // 2.5
    /// ```
    public var seconds: TimeInterval {
        TimeInterval(components.seconds) + TimeInterval(components.attoseconds) / 1e+18
    }

    /// Returns the value of duration in nanoseconds.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let duration = Duration.nanoseconds(1929)
    /// let ns = duration.nanoseconds
    /// print(ns) // 1929 nanoseconds
    /// ```
    public var nanoseconds: Int64 {
        let scale = Int64(1e+9)
        return (components.seconds * scale) + (components.attoseconds / scale)
    }
}

// MARK: - Minutes

extension Duration {
    /// Construct a `Duration` given a number of minutes represented as a
    /// `BinaryInteger`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let d: Duration = .minutes(5)
    /// ```
    ///
    /// - Returns: A `Duration` representing a given number of minutes.
    @inlinable
    public static func minutes(_ minutes: some BinaryInteger) -> Self {
        .seconds(60 * minutes)
    }

    /// Construct a `Duration` given a number of minutes represented as a `Double`
    /// by converting the value into the closest attosecond scale value.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let d: Duration = .minutes(2.5)
    /// ```
    ///
    /// - Returns: A `Duration` representing a given number of minutes.
    @inlinable
    public static func minutes(_ minutes: Double) -> Self {
        .seconds(60 * minutes)
    }
}
