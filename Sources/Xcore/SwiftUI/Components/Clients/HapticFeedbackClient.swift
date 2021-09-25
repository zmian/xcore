//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension HapticFeedbackClient {
    public enum Style: Hashable {
        case selection
        case impact(UIImpactFeedbackGenerator.FeedbackStyle)
        case notification(UINotificationFeedbackGenerator.FeedbackType)
    }
}

/// Provides functionality for haptic feedback.
///
/// **Usage**
///
/// ```swift
/// struct ViewModel {
///     @Dependency(\.hapticFeedback) var hapticFeedback
///
///     func triggerSelectionFeedback() {
///         hapticFeedback(.selection)
///     }
/// }
/// ```
public struct HapticFeedbackClient {
    private let trigger: (_ style: Style) -> Void

    public init(trigger: @escaping (_ style: Style) -> Void) {
        self.trigger = trigger
    }

    /// Trigger the given style of haptic feedback.
    public func callAsFunction(_ style: Style) {
        trigger(style)
    }
}

// MARK: - Variants

extension HapticFeedbackClient {
    /// Returns live variant of `HapticFeedbackClient`.
    public static var live: Self {
        .init { style in
            DispatchQueue.main.async {
                switch style {
                    case .selection:
                        HapticFeedback.selection.trigger()
                    case let .impact(style):
                        HapticFeedback.impact(style: style).trigger()
                    case let .notification(type):
                        HapticFeedback.notification(type: type).trigger()
                }
            }
        }
    }

    /// Returns noop variant of `HapticFeedbackClient`.
    public static var noop: Self {
        .init { _ in }
    }
}

// MARK: - Dependency

extension DependencyValues {
    private struct HapticFeedbackClientKey: DependencyKey {
        static let defaultValue: HapticFeedbackClient = .live
    }

    public var hapticFeedback: HapticFeedbackClient {
        get { self[HapticFeedbackClientKey.self] }
        set { self[HapticFeedbackClientKey.self] = newValue }
    }

    @discardableResult
    public static func hapticFeedback(_ value: HapticFeedbackClient) -> Self.Type {
        set(\.hapticFeedback, value)
        return Self.self
    }
}
