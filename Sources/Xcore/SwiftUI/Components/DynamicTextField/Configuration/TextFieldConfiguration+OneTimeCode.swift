//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension TextFieldConfiguration<MaskingTextFieldFormatter> {
    /// Returns a text field configuration preconfigured for one-time code input.
    ///
    /// This configuration sets appropriate content type, disables spell checking,
    /// uses a numeric keyboard, and applies a masking formatter to limit input to a
    /// fixed number of characters.
    ///
    /// - Parameter defaultCharacterLimit: The fallback character limit for the
    ///   one-time code input, used when the feature flag is not set. See
    ///   `FeatureFlag.oneTimeCodeCharacterLimit(default:)` for more information.
    /// - Returns: A `TextFieldConfiguration` suitable for one-time code entry.
    public static func oneTimeCode(limit defaultCharacterLimit: Int = 6) -> Self {
        .init(
            id: #function,
            autocapitalization: .never,
            spellChecking: .no,
            keyboard: .numberPad,
            textContentType: .oneTimeCode,
            validation: .oneTimeCode,
            formatter: .init(
                String(repeating: "#", count: FeatureFlag.oneTimeCodeCharacterLimit(default: defaultCharacterLimit)),
                placeholderCharacter: "#"
            )
        )
    }
}
