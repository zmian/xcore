//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that passthrough their textual representations.
public struct PassthroughTextFieldFormatter: TextFieldFormatter {
    public func string(from value: String) -> String {
        value
    }

    public func value(from string: String) -> String {
        string
    }

    public func shouldChange(to string: String) -> Bool {
        true
    }
}
