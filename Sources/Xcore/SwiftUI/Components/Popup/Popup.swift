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
    public struct DismissMethods: OptionSet {
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
    public struct Style {
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

        /// A boolean value that indicates whether to enable full screen dimmed
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
        ///   - allowDimming: A boolean value that indicates whether to enable full
        ///     screen dimmed background behind the popup content.
        ///   - dismissAfter: A property indicating whether which view edges expands out
        ///     of its safe area.
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

// MARK: - Style: Built-in

extension Popup.Style {
    /// A style that scale and fades in the popup from the center of the screen.
    public static let alert = Self(
        alignment: .center,
        animation: .spring(),
        transition: .scale(scale: 1.1)
            .combined(with: .opacity)
            .animation(.linear(duration: 0.20))
    )

    /// A style that moves the popup in from the top edge of the screen.
    public static var toast: Self {
        toast(edge: .top)
    }

    /// A style that moves the popup in from the specified edge of the screen.
    public static func toast(edge: Edge) -> Self {
        .init(
            alignment: edge == .top ? .top : .bottom,
            animation: .spring(),
            transition: .move(edge: edge),
            windowStyle: .init(isKey: false, label: "Toast Window"),
            allowDimming: false,
            dismissAfter: 2
        )
    }

    /// A style that moves the popup in from the bottom edge of the screen.
    public static let sheet = Self(
        alignment: .bottom,
        animation: .spring(),
        transition: .move(edge: .bottom)
            .animation(.linear(duration: 0.1)),
        windowStyle: .init(label: "Sheet Window"),
        ignoresSafeAreaEdges: .allButTop
    )
}
