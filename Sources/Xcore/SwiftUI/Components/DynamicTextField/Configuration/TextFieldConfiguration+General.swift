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

    /// Similar to text but no spell checking, auto capitalization or auto
    /// correction.
    public static var plain: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no
        )
    }
}

extension TextFieldConfiguration where Formatter == PhoneNumberTextFieldFormatter {
    /// Phone Number
    public static func phoneNumber(countryCode: String = "1", length: Int? = nil) -> Self {
        let length = length.map { $0 + countryCode.count }

        return .init(
            id: "phoneNumber",
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .phonePad,
            textContentType: .telephoneNumber,
            validation: .phoneNumber(length: length),
            formatter: .init(countryCode: countryCode, length: length)
        )
    }
}
