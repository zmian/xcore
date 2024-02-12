//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

extension HapticFeedbackClient {
    /// Returns live variant of `HapticFeedbackClient`.
    public static var live: Self {
        .init { style in
            Task { @MainActor in
                switch style {
                    case .selection:
                        LiveHapticFeedbackClient.selection.trigger()
                    case let .impact(style):
                        LiveHapticFeedbackClient.impact(style: style).trigger()
                    case let .notification(type):
                        LiveHapticFeedbackClient.notification(type: type).trigger()
                }
            }
        }
    }
}

// MARK: - Implementation

private final class LiveHapticFeedbackClient {
    private let makeGenerator: () -> UIFeedbackGenerator
    private var generator: UIFeedbackGenerator?
    private var _trigger: () -> Void

    private init<T>(
        _ generator: @autoclosure @escaping () -> T,
        trigger: @escaping (T) -> Void
    ) where T: UIFeedbackGenerator {
        self.makeGenerator = generator
        // Workaround for compiler error (Variable 'self._trigger' used before being
        // initialized).
        self._trigger = {}
        self.setTrigger(trigger)
    }

    private func makeGeneratorIfNeeded() {
        guard generator == nil else {
            return
        }

        generator = makeGenerator()
    }

    /// Prepares the generator to trigger feedback.
    ///
    /// When you call this method, the generator is placed into a prepared state for
    /// a short period of time. While the generator is prepared, you can trigger
    /// feedback with lower latency.
    ///
    /// Think about when you can best prepare your generators. Call `prepare()`
    /// before the event that triggers feedback. The system needs time to prepare
    /// the Taptic Engine for minimal latency. Calling `prepare()` and then
    /// immediately triggering feedback (without any time in between) does not
    /// improve latency.
    ///
    /// To conserve power, the Taptic Engine returns to an idle state after any of
    /// the following events:
    ///
    /// - You trigger feedback on the generator.
    /// - A short period of time passes (typically seconds).
    /// - The generator is deallocated.
    ///
    /// After feedback is triggered, the Taptic Engine returns to its idle state. If
    /// you might trigger additional feedback within the next few seconds,
    /// immediately call `prepare()` to keep the Taptic Engine in the prepared
    /// state.
    ///
    /// You can also extend the prepared state by repeatedly calling the `prepare()`
    /// method. However, if you continue calling `prepare()` without ever triggering
    /// feedback, the system may eventually place the Taptic Engine back in an idle
    /// state and ignore any further `prepare()` calls until after you trigger
    /// feedback at least once.
    ///
    /// If you no longer need a prepared generator, remove all references to the
    /// generator object and let the system deallocate it. This lets the Taptic
    /// Engine return to its idle state.
    ///
    /// - Note: The `prepare()` method is optional; however, it is highly
    ///   recommended. Calling this method helps ensure that your feedback has the
    ///   lowest possible latency.
    func prepare() {
        makeGeneratorIfNeeded()
        generator?.prepare()
    }

    /// Triggers haptic feedback for the generator type.
    func trigger() {
        makeGeneratorIfNeeded()
        _trigger()
    }

    /// This deallocate the generator so that the Taptic Engine can return to its
    /// idle state.
    func sleep() {
        generator = nil
    }

    private func setTrigger<T>(_ trigger: @escaping (T) -> Void) {
        _trigger = { [weak self] in
            guard let generator = self?.generator as? T else {
                return
            }

            trigger(generator)
        }
    }
}

// MARK: - Variants

extension LiveHapticFeedbackClient {
    fileprivate static let selection = LiveHapticFeedbackClient(UISelectionFeedbackGenerator()) {
        $0.selectionChanged()
    }

    fileprivate static func impact(style: UIImpactFeedbackGenerator.FeedbackStyle) -> LiveHapticFeedbackClient {
        switch style {
            case .light:
                return .lightImpactFeedbackGenerator
            case .medium:
                return .mediumImpactFeedbackGenerator
            case .heavy:
                return .heavyImpactFeedbackGenerator
            case .soft:
                return .softImpactFeedbackGenerator
            case .rigid:
                return .rigidImpactFeedbackGenerator
            @unknown default:
                #if DEBUG
                fatalError(because: .unknownCaseDetected(style))
                #else
                return .lightImpactFeedbackGenerator
                #endif
        }
    }

    fileprivate static func notification(type: UINotificationFeedbackGenerator.FeedbackType) -> LiveHapticFeedbackClient {
        notificationFeedbackGenerator.setTrigger { (generator: UINotificationFeedbackGenerator) in
            generator.notificationOccurred(type)
        }

        return notificationFeedbackGenerator
    }
}

// MARK: - UIImpactFeedbackGenerator

extension LiveHapticFeedbackClient {
    private static let lightImpactFeedbackGenerator = makeImpactFeedbackGenerator(style: .light)
    private static let mediumImpactFeedbackGenerator = makeImpactFeedbackGenerator(style: .medium)
    private static let heavyImpactFeedbackGenerator = makeImpactFeedbackGenerator(style: .heavy)
    private static let softImpactFeedbackGenerator = makeImpactFeedbackGenerator(style: .soft)
    private static let rigidImpactFeedbackGenerator = makeImpactFeedbackGenerator(style: .rigid)

    private static func makeImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle) -> LiveHapticFeedbackClient {
        .init(UIImpactFeedbackGenerator(style: .light)) {
            $0.impactOccurred()
        }
    }
}

// MARK: - UINotificationFeedbackGenerator

extension LiveHapticFeedbackClient {
    private static let notificationFeedbackGenerator = LiveHapticFeedbackClient(UINotificationFeedbackGenerator()) { _ in }
}
