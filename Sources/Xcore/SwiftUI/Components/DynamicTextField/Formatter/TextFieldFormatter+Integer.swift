//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A formatter that converts between integer values and their textual
/// representations.
public struct IntegerTextFieldFormatter: TextFieldFormatter {
    private let numberFormatter = NumberFormatter().apply {
        $0.allowsFloats = false
        $0.numberStyle = .decimal
    }

    public func string(from value: Int) -> String {
        numberFormatter.string(from: value) ?? ""
    }

    public func value(from string: String) -> Int {
        numberFormatter.number(from: string)?.intValue ?? 0
    }

    public func format(_ string: String) -> String? {
        guard let value = Int(string) else {
            return string.isEmpty ? "" : nil
        }

        return numberFormatter.string(from: value) ?? ""
    }

    public func unformat(_ string: String) -> String {
        string.replacingOccurrences(of: ",", with: "")
    }
}
