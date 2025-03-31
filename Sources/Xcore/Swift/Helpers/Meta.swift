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
    return description.removingAnonymousContextDescriptor()
}

extension String {
    /// Removes the compiler-generated context information from a string
    /// representation of a type.
    ///
    /// When using `String(reflecting:)` on a type created inside a function, the
    /// result may include an extra substring indicating an "unknown context" due to
    /// a Swift compiler bug.
    ///
    /// This method uses a regular expression to remove that substring from the
    /// resulting string.
    ///
    /// For more information, see [SR-6787](https://github.com/swiftlang/swift/issues/49336).
    func removingAnonymousContextDescriptor() -> String {
        replacingOccurrences(
            of: #"\(unknown context at \$[[:xdigit:]]+\)\."#,
            with: "",
            options: .regularExpression
        )
    }
}
