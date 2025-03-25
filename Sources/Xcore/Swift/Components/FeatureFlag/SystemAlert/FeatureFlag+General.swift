//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension FeatureFlag {
    /// Returns the maximum number of characters permitted for a one-time code
    /// input.
    ///
    /// If a value is not explicitly provided via the feature flag provider, the
    /// given default value is used.
    ///
    /// - Parameter defaultValue: The fallback value used if the feature flag is not
    ///   set.
    /// - Returns: The maximum number of characters allowed for a one-time code
    ///   input.
    public static func oneTimeCodeCharacterLimit(default defaultValue: Int = 6) -> Int {
        key("one_time_code_character_limit").value(default: defaultValue)
    }
}

// MARK: - App Store Review Prompt

extension FeatureFlag {
    /// A Boolean property indicating whether the App Store review prompt is enabled.
    ///
    /// When this property is `true`, the application can present a prompt
    /// requesting an App Store review.
    public static var reviewPromptEnabled: Bool {
        key(#function).value()
    }

    /// Returns the number of user visits multiple required before prompting for an
    /// App Store review.
    ///
    /// The default value is `10`, meaning that after every 10th visit the user may
    /// be prompted for a review. A value of `0` indicates that the review prompt
    /// should never be shown based on user visits.
    ///
    /// - Note: This property is effective only when `reviewPromptEnabled` is
    ///   `true`.
    ///
    /// - Warning: Apple API doesn't guarantee that user will see the prompt.
    public static var reviewPromptVisitMultipleOf: Int {
        key(#function).value(default: 10)
    }
}
