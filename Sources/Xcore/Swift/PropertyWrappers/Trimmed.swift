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
/// var post = Post(title: "  Swift Property Wrappers  ", body: "...")
/// post.title // "Swift Property Wrappers" (no leading or trailing spaces)
///
/// post.title = "      @propertyWrapper     "
/// post.title // "@propertyWrapper" (still no leading or trailing spaces)
///
/// post.title = "  Swift Property            Wrappers  "
/// post.title // "Swift Property Wrappers" (no leading, trailing or multiple middle spaces)
/// ```
@propertyWrapper
public struct Trimmed {
    private var value = ""

    public init(wrappedValue: String) {
        self.wrappedValue = wrappedValue
    }

    public var wrappedValue: String {
        get { value }
        set { value = newValue.trimmed() }
    }
}
