//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension TimeInterval {
    /// Initializes a `TimeInterval` instance from a `Duration`.
    ///
    /// This initializer extracts the seconds component from `Duration` to create
    /// a `TimeInterval` value, making it easier to use `Duration` with UIKit or
    /// older APIs expecting `TimeInterval`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let duration = Duration.seconds(2.5)
    /// let timeInterval = TimeInterval(duration)
    /// print(timeInterval) // 2.5
    /// ```
    ///
    /// - Parameter duration: The `Duration` value to convert.
    public init(_ duration: Duration) {
        let (seconds, attoseconds) = duration.components
        let timeInterval = TimeInterval(seconds) + TimeInterval(attoseconds) / 1e18
        self.init(timeInterval)
    }
}
