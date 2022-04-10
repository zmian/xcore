//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension Text {
    @available(iOS 15, *)
    public init<S>(_ string: S, configure: (inout AttributedString) -> Void) where S: StringProtocol {
        var attributedString = AttributedString(string)
        configure(&attributedString)
        self.init(attributedString)
    }
}

extension Text {
    /// Creates a text view that displays a stored string without localization.
    @_disfavoredOverload
    public init?<S>(_ content: S?) where S: StringProtocol {
        guard let content = content else {
            return nil
        }

        self.init(content)
    }
}

extension Text {
    /// Creates text view that scales the provided portion of the text based on the
    /// font than the rest.
    public init(_ content: String, scale scaledContent: String, font: Font) {
        if #available(iOS 15, *) {
            self.init(content) { str in
                if let range = str.range(of: scaledContent) {
                    str[range].font = font
                }
            }
        } else {
            self.init(content)
        }
    }
}
