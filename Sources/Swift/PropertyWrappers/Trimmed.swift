//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// credit: https://nshipster.com/propertywrapper/
//
/// Trims whitespaces from wrapped value.
///
/// **Usage**
///
/// ```swift
/// struct Post {
///     @Trimmed var title: String
///     @Trimmed var body: String
/// }
///
/// let quine = Post(title: "  Swift Property Wrappers  ", body: "...")
/// quine.title // "Swift Property Wrappers" (no leading or trailing spaces!)
///
/// quine.title = "      @propertyWrapper     "
/// quine.title // "@propertyWrapper" (still no leading or trailing spaces!)
/// ```
@propertyWrapper
public struct Trimmed {
    private var value: String = ""

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: String {
        get { value }
        set { value = newValue.trimmingCharacters(in: .whitespacesAndNewlines) }
    }
}
