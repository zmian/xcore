//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration<PassthroughTextFieldFormatter> {
    /// Freeform text
    public static var text: Self {
        .init(id: #function)
    }

    /// Similar to text but no spell checking, auto capitalization or auto
    /// correction.
    public static var plain: Self {
        .init(
            id: #function,
            autocapitalization: .never,
            spellChecking: .no
        )
    }

    /// Email
    public static var emailAddress: Self {
        .init(
            id: #function,
            autocapitalization: .never,
            spellChecking: .no,
            keyboard: .emailAddress,
            textContentType: .emailAddress,
            validation: .email
        )
    }
}

extension TextFieldConfiguration<PhoneNumberTextFieldFormatter> {
    /// Phone Number with 11 character length.
    public static var phoneNumber: Self {
        .phoneNumber(for: .us)
    }

    /// Phone Number
    public static func phoneNumber(for style: Formatter.Style) -> Self {
        .init(
            id: "phoneNumber",
            autocapitalization: .never,
            spellChecking: .no,
            keyboard: .phonePad,
            textContentType: .telephoneNumber,
            validation: .phoneNumber(length: style.length),
            formatter: .init(style: style)
        )
    }
}
