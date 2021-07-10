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
    public struct Style {
        public let alignment: Alignment
        public let animation: Animation
        public let transition: AnyTransition
        public let dismissAfter: Double?

        public init(
            alignment: Alignment,
            animation: Animation,
            transition: AnyTransition,
            dismissAfter: Double? = nil
        ) {
            self.alignment = alignment
            self.animation = animation
            self.transition = transition
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
            dismissAfter: 2
        )
    }
}
