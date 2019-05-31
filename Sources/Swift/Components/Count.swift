//
// Count.swift
//
// Copyright © 2019 Xcore
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
