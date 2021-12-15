//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration where Formatter == CustomTextFieldFormatter {
    /// Phone Number
    public static var phoneNumber: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .phonePad,
            textContentType: .telephoneNumber,
            validation: .phoneNumber,
            mask: .phoneNumber
        )
    }

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
            validation: .ssn,
            mask: .ssn
        )
    }
}
