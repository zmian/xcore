//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

// MARK: - Decimal

/// A formatter that converts between decimal values and their textual
/// representations.
public struct DecimalTextFieldFormatter: TextFieldFormatter {
    private let numberFormatter = NumberFormatter().apply {
        $0.allowsFloats = true
        $0.numberStyle = .decimal
    }

    public func string(from value: Double) -> String {
        numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }

    public func value(from string: String) -> Double {
        numberFormatter.number(from: string)?.doubleValue ?? 0
    }

    public func shouldChange(to string: String) -> Bool {
        let components = string.components(separatedBy: ".")

        if components.count <= 2 {
            return components.allSatisfy { $0.isEmpty || Int($0) != nil }
        } else {
            return false
        }
    }
}

// MARK: - Int

/// A formatter that converts between integer values and their textual
/// representations.
public struct IntegerTextFieldFormatter: TextFieldFormatter {
    private let numberFormatter = NumberFormatter().apply {
        $0.allowsFloats = false
        $0.numberStyle = .decimal
    }

    public func string(from value: Int) -> String {
        numberFormatter.string(from: NSNumber(value: value)) ?? ""
    }

    public func value(from string: String) -> Int {
        numberFormatter.number(from: string)?.intValue ?? 0
    }

    public func shouldChange(to string: String) -> Bool {
        Int(string) != nil
    }
}
