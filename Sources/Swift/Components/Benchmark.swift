//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// Credit: http://stackoverflow.com/a/31412302

/// A convenience function to measure code execution.
///
/// **Asynchronous code:**
///
/// ```swift
/// measure(label: "some title") { finish in
///     myAsyncCall {
///         finish()
///     }
///     // ...
/// }
/// ```
///
/// **Synchronous code:**
///
/// ```swift
/// measure(label: "some title") { finish in
///     // code to benchmark
///     finish()
///     // ...
/// }
/// ```
///
/// - Parameters:
///   - label: Measure block name.
///   - block: Call `finish` block to measure test.
public func measure(label: String, block: (_ finish: () -> Void) -> Void) {
    let startTime = CFAbsoluteTimeGetCurrent()

    block {
        let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime
        print("\(label):: Time: \(timeElapsed)", format(seconds: timeElapsed))
    }
}

private func format(seconds: TimeInterval) -> String {
    let value = Int(seconds)
    let seconds = value % 60
    let minutes = value / 60
    return String(format: "%02d:%02d", minutes, seconds)
}
