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
