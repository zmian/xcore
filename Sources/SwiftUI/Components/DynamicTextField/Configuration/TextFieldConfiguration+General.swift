//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration where Formatter == PassthroughTextFieldFormatter {
    /// Freeform text
    public static var text: Self {
        .init(id: #function)
    }

    /// Email
    public static var emailAddress: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .emailAddress,
            textContentType: .emailAddress,
            validation: .email
        )
    }

    /// Phone Number
    public static var phoneNumber: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .phonePad,
            textContentType: .telephoneNumber,
            validation: .isValid(.phoneNumber)
        )
    }
}
