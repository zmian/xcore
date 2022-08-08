//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Namespace

public enum Popup {}

// MARK: - Dismiss Methods

extension Popup {
    public struct DismissMethods: OptionSet, Hashable {
        public let rawValue: Int

        public init(rawValue: Int) {
            self.rawValue = rawValue
        }

        /// TODO: Swipe to dismiss popup.
        // public static let swipe = Self(rawValue: 1 << 0)

        /// Tap on popup to dismiss.
        public static let tapInside = Self(rawValue: 1 << 1)

        /// Tap outside of the popup content to dismiss.
        public static let tapOutside = Self(rawValue: 1 << 2)

        /// Adds an "x" button that user can tap to dismiss popup.
        public static let xmark = Self(rawValue: 1 << 3)
    }
}

// MARK: - Style

extension Popup {
    /// A structure representing the style of a popup.
    public struct Style: Hashable {
        /// The alignment of the popup inside the resulting view. Alignment applies if
        /// the popup is smaller than the size given by the resulting frame.
        public let alignment: Alignment

        /// The animation applied to all animatable values to the popup content.
        public let animation: Animation

        /// The transition to associates with the popup.
        public let transition: AnyTransition

        /// The style of the presenting window.
        public let windowStyle: WindowStyle

        /// A property indicating whether which view edges expands out of its safe area.
        ///
        /// The default value is `[]`.
        public let ignoresSafeAreaEdges: Edge.Set

        /// A Boolean property indicating whether to enable full screen dimmed
        /// background behind the popup content.
        public let allowDimming: Bool

        /// A property indicating whether to automatically dismiss the popup after given
        /// duration has passed.
        public let dismissAfter: Double?

        /// Creates a popup style.
        ///
        /// - Parameters:
        ///   - alignment: The alignment of the popup inside the resulting view.
        ///     Alignment applies if the popup is smaller than the size given by the
        ///     resulting frame.
        ///   - animation: The animation applied to all animatable values to the popup
        ///     content.
        ///   - transition: The transition to associates with the popup.
        ///   - windowStyle: The style of the presenting window.
        ///   - allowDimming: A Boolean value indicating whether to enable full screen
        ///     dimmed background behind the popup content.
        ///   - dismissAfter: A property indicating whether the popup is automatically
        ///     dismissed after the given duration.
        public init(
            alignment: Alignment,
            animation: Animation,
            transition: AnyTransition,
            windowStyle: WindowStyle = .init(label: "Popup Window"),
            ignoresSafeAreaEdges: Edge.Set = [],
            allowDimming: Bool = true,
            dismissAfter: Double? = nil
        ) {
            self.alignment = alignment
            self.animation = animation
            self.transition = transition
            self.windowStyle = windowStyle
            self.ignoresSafeAreaEdges = ignoresSafeAreaEdges
            self.allowDimming = allowDimming
            self.dismissAfter = dismissAfter
        }
    }
}

// MARK: - Equatable

extension Popup.Style {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.alignment == rhs.alignment &&
        lhs.animation == rhs.animation &&
        lhs.windowStyle == rhs.windowStyle &&
        lhs.ignoresSafeAreaEdges == rhs.ignoresSafeAreaEdges &&
        lhs.allowDimming == rhs.allowDimming &&
        lhs.dismissAfter == rhs.dismissAfter &&
        String(reflecting: lhs.transition) == String(reflecting: rhs.transition)
    }
}

// MARK: - Hashable

extension Popup.Style {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(String(reflecting: alignment))
        hasher.combine(String(reflecting: animation))
        hasher.combine(String(reflecting: transition))
        hasher.combine(windowStyle)
        hasher.combine(String(reflecting: ignoresSafeAreaEdges))
        hasher.combine(allowDimming)
        hasher.combine(dismissAfter)
    }
}

// MARK: - Style: Built-in

extension Popup.Style {
    /// A style that scale and fades in the popup from the center of the screen.
    public static let alert = Self(
        alignment: .center,
        animation: .spring(),
        transition: .scale(scale: 1.1)
            .combined(with: .opacity)
    )

    /// A style that moves the popup in from the top edge of the screen.
    public static var toast: Self {
        toast()
    }

    /// A style that moves the popup in from the specified edge of the screen.
    public static func toast(edge: Edge = .top, dismissAfter duration: Double = 2) -> Self {
        .init(
            alignment: edge == .top ? .top : .bottom,
            animation: .spring(response: 0.6),
            transition: .move(edge: edge)
                .combined(with: .opacity),
            windowStyle: .init(label: "Toast Window", isKey: false),
            allowDimming: false,
            dismissAfter: duration
        )
    }

    /// A style that moves the popup in from the bottom edge of the screen.
    public static let sheet = Self(
        alignment: .bottom,
        animation: .spring(),
        transition: .move(edge: .bottom),
        windowStyle: .init(label: "Sheet Window")
    )
}
