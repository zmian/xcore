//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension HapticFeedbackClient {
    /// An enumeration representing the style of haptic feedback.
    public enum Style: Sendable, Hashable {
        /// Creates haptics to indicate a change in selection.
        case selection

        /// Creates haptics to simulate physical impacts.
        ///
        /// - Parameter style: A value representing the mass of the colliding objects.
        case impact(UIImpactFeedbackGenerator.FeedbackStyle)

        /// Creates haptics to communicate successes, failures, and warnings.
        ///
        /// - Parameter type: The type of notification feedback.
        case notification(UINotificationFeedbackGenerator.FeedbackType)
    }
}

/// Provides functionality for haptic feedback.
///
/// Haptic feedback provides a tactile response, such as a tap, that draws
/// attention and reinforces both actions and events. While many system-provided
/// interface elements (for example, pickers, switches, and sliders)
/// automatically provide haptic feedback, you can use feedback generators to
/// add your own feedback to custom views and controls.
///
/// **Usage**
///
/// ```swift
/// class ViewModel {
///     @Dependency(\.hapticFeedback) var hapticFeedback
///
///     func triggerSelectionFeedback() {
///         hapticFeedback(.selection)
///     }
/// }
/// ```
public struct HapticFeedbackClient: Sendable {
    private let trigger: @Sendable (Style) -> Void

    /// Creates a client that generates haptic feedback for the given style.
    ///
    /// - Parameter trigger: The closure to trigger haptic feedback for the given
    ///   style.
    public init(trigger: @escaping @Sendable (_ style: Style) -> Void) {
        self.trigger = trigger
    }

    /// Trigger haptic feedback for the given style.
    public func callAsFunction(_ style: Style) {
        trigger(style)
    }
}

// MARK: - Variants

extension HapticFeedbackClient {
    /// Returns noop variant of `HapticFeedbackClient`.
    public static var noop: Self {
        .init { _ in }
    }

    /// Returns unimplemented variant of `HapticFeedbackClient`.
    public static var unimplemented: Self {
        .init { _ in
            reportIssue(#"Unimplemented: @Dependency(\.hapticFeedback)"#)
        }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private enum HapticFeedbackClientKey: DependencyKey {
        static let liveValue: HapticFeedbackClient = .live
        static let testValue: HapticFeedbackClient = .unimplemented
        static let previewValue: HapticFeedbackClient = .noop
    }

    /// Provides functionality for haptic feedback.
    ///
    /// Haptic feedback provides a tactile response, such as a tap, that draws
    /// attention and reinforces both actions and events. While many system-provided
    /// interface elements (for example, pickers, switches, and sliders)
    /// automatically provide haptic feedback, you can use feedback generators to
    /// add your own feedback to custom views and controls.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// class ViewModel {
    ///     @Dependency(\.hapticFeedback) var hapticFeedback
    ///
    ///     func triggerSelectionFeedback() {
    ///         hapticFeedback(.selection)
    ///     }
    /// }
    /// ```
    public var hapticFeedback: HapticFeedbackClient {
        get { self[HapticFeedbackClientKey.self] }
        set { self[HapticFeedbackClientKey.self] = newValue }
    }
}
