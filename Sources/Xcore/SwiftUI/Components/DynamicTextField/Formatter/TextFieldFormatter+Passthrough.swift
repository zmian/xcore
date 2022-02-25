//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that passthrough their textual representations.
public struct PassthroughTextFieldFormatter: TextFieldFormatter {
    public init() {}

    public func transformToString(_ value: String) -> String {
        value
    }

    public func transformToValue(_ string: String) -> String {
        string
    }

    public func displayValue(from string: String) -> String {
        string
    }

    public func sanitizeDisplayValue(from string: String) -> String {
        string
    }

    public func shouldChange(to string: String) -> Bool {
        true
    }
}
