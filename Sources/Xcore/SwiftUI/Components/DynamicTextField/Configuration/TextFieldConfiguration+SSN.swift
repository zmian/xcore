//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration<MaskingTextFieldFormatter> {
    /// Social Security Number (SSN)
    public static var ssn: Self {
        .init(
            id: #function,
            autocapitalization: .never,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: nil,
            textEntryMode: .maskedWithToggle,
            validation: .ssn,
            formatter: .init("###-##-####")
        )
    }

    /// Social Security Number (SSN) Last 4 Digits
    public static var ssnLastFour: Self {
        .init(
            id: #function,
            autocapitalization: .never,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: nil,
            textEntryMode: .maskedWithToggle,
            validation: .number(length: 4),
            formatter: .init("####")
        )
    }
}
