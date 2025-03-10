//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that converts between integer values and their textual
/// representations.
public struct IntegerTextFieldFormatter: TextFieldFormatter {
    public func string(from value: Int?) -> String {
        value?.formatted(.number) ?? ""
    }

    public func value(from string: String) -> Int? {
        try? Int(string, format: .number)
    }

    public func format(_ string: String) -> String? {
        guard let value = value(from: string) else {
            return string.isEmpty ? "" : nil
        }

        return self.string(from: value)
    }

    public func unformat(_ string: String) -> String {
        string.filter { $0.isNumber || $0 == "." }
    }
}
