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
