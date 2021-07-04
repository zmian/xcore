//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Embed this view in navigation controller.
    public func embedInNavigation() -> some View {
        NavigationView { self }
    }

    /// Wraps this view with a type eraser.
    ///
    /// - Returns: An `AnyView` wrapping this view.
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - On Tap

extension View {
    /// Returns a version of `self` that will perform `action` when `self` is
    /// triggered.
    public func onTap(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            self
        }
        .buttonStyle(.scaleEffect)
    }
}

// MARK: - Colors

extension View {
    /// Sets the color that the view uses for foreground elements.
    public func foregroundColor(_ color: UIColor) -> some View {
        foregroundColor(Color(color))
    }

    /// Sets the background color behind this view.
    public func backgroundColor(_ color: UIColor, edgesIgnoringSafeArea: Edge.Set = .all) -> some View {
        background(
            Color(color)
                .edgesIgnoringSafeArea(edgesIgnoringSafeArea)
        )
    }
}

// MARK: - Hidden

extension View {
    /// Hide or show the view based on a boolean value.
    ///
    /// Example for visibility:
    ///
    /// ```
    /// Text("Label")
    ///     .hidden(true)
    /// ```
    ///
    /// Example for complete removal:
    ///
    /// ```
    /// Text("Label")
    ///     .hidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: Boolean value indicating whether or not to remove the view.
    @ViewBuilder
    public func hidden(_ hidden: Bool, remove: Bool = false) -> some View {
        if hidden {
            if !remove {
                self.hidden()
            }
        } else {
            self
        }
    }
}
