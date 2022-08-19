//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FeatureFlag {
    public static var oneTimeCodeCharacterLimit: Int {
        key(#function).value(default: 6)
    }
}

// MARK: - App Store Review Prompt

extension FeatureFlag {
    /// A Boolean property indicating whether App Store review prompt is enabled.
    public static var reviewPromptEnabled: Bool {
        key(#function).value()
    }

    /// A property indicating number of user's visits multiple before prompting the
    /// user for the review prompt.
    ///
    /// The default value is `10`, meaning after every 10th visit we ask the user to
    /// review the app. Apple API doesn't guarantee that user will see the prompt.
    ///
    /// - Note: If `reviewPromptEnabled` is `false` this property has no effect.
    ///
    /// If this property value is `0` then it means to never show the review prompt
    /// based on user's visits.
    public static var reviewPromptVisitMultipleOf: Int {
        key(#function).value(default: 10)
    }
}
