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

// MARK: - App Store Rating Prompt

extension FeatureFlag {
    /// A boolean property indicating whether App Store rating prompt is enabled.
    public static var ratingPromptEnabled: Bool {
        key(#function).value()
    }

    /// A property indicating number of user visits multiple before auto prompting
    /// the user the rating prompt.
    ///
    /// The default value is `10`, meaning after every 10th visit we ask the user to
    /// rate the app. Apple API doesn't guarantee that user will see the prompt.
    ///
    /// - Note: If `ratingPromptEnabled` is `false` this property has no effect.
    ///
    /// If this property value is `0` then it means to never show the rating prompt
    /// based on user's visits.
    public static var ratingPromptVisitMultipleOf: Int {
        key(#function).value(default: 10)
    }
}
