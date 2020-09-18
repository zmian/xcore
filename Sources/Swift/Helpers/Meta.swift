//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import Swift

/// Returns the name of a `type` as a string.
///
/// - Parameter value: The value for which to get the dynamic type name.
/// - Returns: A string containing the name of `value`'s dynamic type.
public func name(of value: Any) -> String {
    let kind = value is Any.Type ? value : Swift.type(of: value)
    let description = String(reflecting: kind)

    // Swift compiler bug causing unexpected result when getting a String describing
    // a type created inside a function.
    //
    // https://bugs.swift.org/browse/SR-6787
    let unwantedResult = "(unknown context at "

    guard description.contains(unwantedResult) else {
        return description
    }

    return description
        .split(separator: ".")
        .lazy
        .filter { !$0.hasPrefix(unwantedResult) }
        .joined(separator: ".")
}
