//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Decimal

extension TextFieldConfiguration<DecimalTextFieldFormatter> {
    /// Decimal type text configuration.
    public static var number: Self {
        number(style: .decimal)
    }

    /// Currency type text configuration.
    public static var currency: Self {
        number(style: .currency)
    }

    /// Decimal type text configuration.
    private static func number(style: DecimalTextFieldFormatter.Style) -> Self {
        .init(
            id: #function,
            autocapitalization: .never,
            spellChecking: .no,
            keyboard: .decimalPad,
            textContentType: nil,
            validation: .subset(of: .numbersWithDecimal),
            formatter: .init(style: style)
        )
    }
}

// MARK: - Int

extension TextFieldConfiguration<IntegerTextFieldFormatter> {
    /// Integer type text configuration.
    public static var number: Self {
        .init(
            id: #function,
            autocapitalization: .never,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: nil,
            validation: .subset(of: .numbers),
            formatter: .init()
        )
    }
}
