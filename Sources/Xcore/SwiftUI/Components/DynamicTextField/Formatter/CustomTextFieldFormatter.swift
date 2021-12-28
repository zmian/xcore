//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that passthrough their textual representations.
public struct CustomTextFieldFormatter: TextFieldFormatter {
    private let mask: Mask

    public init(_ mask: Mask) {
        self.mask = mask
    }

    public func string(from value: String) -> String {
        mask.string(from: value)
    }

    public func value(from string: String) -> String {
        mask.value(from: string)
    }

    public func shouldChange(to string: String) -> Bool {
        true
    }
}
