//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that passthrough their textual representations.
public struct PassthroughTextFieldFormatter: TextFieldFormatter {
    public init() {}

    public func string(from value: String) -> String {
        value
    }

    public func value(from string: String) -> String {
        string
    }

    public func format(_ string: String) -> String? {
        string
    }

    public func unformat(_ string: String) -> String {
        string
    }
}
