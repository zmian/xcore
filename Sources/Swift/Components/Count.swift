//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A type that can be used to represent a finite or infinite count.
///
/// # Example Usage
///
/// ```swift
/// var count: Count = .infinite
/// // print(count) // infinite
///
/// var count: Count = 1
/// // print(count) // 1
///
/// count -= 1
/// // print(count) // 0
///
/// if count == 0 {
///     print("Remaining count is 0.")
/// }
/// ```
public enum Count: Equatable, ExpressibleByIntegerLiteral, CustomStringConvertible {
    case infinite
    case times(Int)

    public static var once: Self {
        .times(1)
    }

    public init(integerLiteral value: Int) {
        self = .times(value)
    }

    public var description: String {
        switch self {
            case .infinite:
                return "infinite"
            case .times(let count):
                return "\(count)"
        }
    }
}
