//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration where Formatter == PassthroughTextFieldFormatter {
    /// Social Security Number (SSN)
    public static var ssn: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: nil,
            secureTextEntry: .yesWithToggleButton,
            validation: .ssn
        )
    }

    /// Social Security Number (SSN) Last 4 Digits
    public static var ssnLastFour: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: nil,
            secureTextEntry: .yesWithToggleButton,
            validation: .number(count: 4)
        )
    }
}
