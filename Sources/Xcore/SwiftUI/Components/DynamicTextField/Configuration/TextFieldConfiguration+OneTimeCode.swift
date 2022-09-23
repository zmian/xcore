//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration<MaskingTextFieldFormatter> {
    /// One-Time Code
    public static var oneTimeCode: Self {
        .init(
            id: #function,
            autocapitalization: .none,
            autocorrection: .no,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: .oneTimeCode,
            validation: .oneTimeCode,
            formatter: .init(String(repeating: "#", count: FeatureFlag.oneTimeCodeCharacterLimit))
        )
    }
}
