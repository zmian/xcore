//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Text {
    /// Creates an attributed string by looking up a localized string from the app’s
    /// bundle, with app's custom attribute scope to handle *inline foreground
    /// color*.
    ///
    /// Usage:
    ///
    /// ```swift
    /// Text(appMarkdown: "Hello ^[world!](color: '#ff0000')")
    /// ```
    ///
    /// It uses [AttributedString's syntax](syntax) for defining custom tags.
    ///
    /// [syntax]: https://developer.apple.com/documentation/foundation/data_formatting/building_a_localized_food-ordering_app#see-also
    public init(appMarkdown: String.LocalizationValue) {
        var attributedString = AttributedString(localized: appMarkdown, including: \.customApp)

        // See also: https://fatbobman.com/en/posts/attributedstring
        for (color, range) in attributedString.runs[\.color] {
            if let color {
                attributedString[range].foregroundColor = Color(hex: color)
            }
        }

        self.init(attributedString)
    }
}

extension AttributeScopes {
    fileprivate struct CustomAppAttributes: AttributeScope {
        let color: ForegroundColorAttribute

        enum ForegroundColorAttribute: CodableAttributedStringKey, MarkdownDecodableAttributedStringKey {
            typealias Value = String
            static let name = "color"
        }
    }

    fileprivate var customApp: CustomAppAttributes.Type {
        CustomAppAttributes.self
    }
}

extension AttributeDynamicLookup {
    fileprivate subscript<T: AttributedStringKey>(dynamicMember keyPath: KeyPath<AttributeScopes.CustomAppAttributes, T>) -> T {
        self[T.self]
    }
}
