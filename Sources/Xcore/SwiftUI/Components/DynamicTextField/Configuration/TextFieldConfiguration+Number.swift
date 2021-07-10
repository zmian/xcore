//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Decimal

extension TextFieldConfiguration where Formatter == DecimalTextFieldFormatter {
    /// Decimal type text configuration.
    public static var number: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .decimalPad,
            textContentType: nil,
            validation: .subset(of: .numbersWithDecimal),
            formatter: Formatter()
        )
    }
}

// MARK: - Int

extension TextFieldConfiguration where Formatter == IntegerTextFieldFormatter {
    /// Integer type text configuration.
    public static var number: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: nil,
            validation: .subset(of: .numbers),
            formatter: Formatter()
        )
    }
}
