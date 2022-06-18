//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import StoreKit

/// Provides functionality for requesting App Store ratings and reviews from
/// users.
///
/// **Usage**
///
/// ```swift
/// struct ViewModel {
///     @Dependency(\.ratingPrompt) var ratingPrompt
///
///     func requestReview() {
///         ratingPrompt.show()
///     }
/// }
/// ```
public struct RatingPromptClient {
    /// Tells StoreKit to ask the user to rate or review the app.
    ///
    /// - Note: This may or may not show any UI.
    ///
    /// Given this may not successfully present an alert to the user, it is not
    /// appropriate to use from a button or any other user action. For presenting a
    /// write review form, a deep link is available to the App Store by appending
    /// the query params "action=write-review" to a product URL.
    public let showIfNeeded: () -> Void

    public init(showIfNeeded: @escaping () -> Void) {
        self.showIfNeeded = showIfNeeded
    }
}

// MARK: - Variants

extension RatingPromptClient {
    /// Returns noop variant of `RatingPromptClient`.
    public static var noop: Self {
        .init {}
    }

    /// Returns live variant of `RatingPromptClient`.
    public static var live: Self {
        .init {
            guard
                FeatureFlag.ratingPromptEnabled,
                let scene = UIApplication.sharedOrNil?.firstSceneKeyWindow?.windowScene
            else {
                return
            }

            SKStoreReviewController.requestReview(in: scene)
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct RatingPromptClientKey: DependencyKey {
        static let defaultValue: RatingPromptClient = .live
    }

    /// Provides functionality for requesting App Store ratings and reviews from
    /// users.
    public var ratingPrompt: RatingPromptClient {
        get { self[RatingPromptClientKey.self] }
        set { self[RatingPromptClientKey.self] = newValue }
    }

    /// Provides functionality for requesting App Store ratings and reviews from
    /// users.
    @discardableResult
    public static func ratingPrompt(_ value: RatingPromptClient) -> Self.Type {
        self[\.ratingPrompt] = value
        return Self.self
    }
}
