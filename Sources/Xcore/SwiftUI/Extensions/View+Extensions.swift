//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Embed

extension View {
    /// Wraps this view with a type eraser.
    ///
    /// - Returns: An `AnyView` wrapping this view.
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }

    /// Embed this view in `Link` if `url` isn't nil.
    @ViewBuilder
    public func embedInLink(_ url: URL?) -> some View {
        if let url {
            Link(destination: url) {
                self
            }
        } else {
            self
        }
    }

    /// Embed this view in a navigation view.
    ///
    /// - Note: This method is internal on purpose to allow the app target to
    ///   declare their own variant in case they want to use this method name to
    ///   apply any additional modifications (e.g., setting the navigation view style
    ///   `.navigationViewStyle(.stack)`).
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
}

// MARK: - ForegroundColor

extension View {
    /// Sets the color of the foreground elements displayed by this view.
    ///
    /// - Parameter color: A closure to return foreground color to use when
    ///   displaying this view. Return `nil` to remove any custom foreground color
    ///   and to allow the system or the container to provide its own foreground
    ///   color. If a container-specific override doesn’t exist, the system uses the
    ///   primary color.
    /// - Returns: A view that uses the foreground color you supply.
    public func foregroundColor(_ color: () -> Color?) -> some View {
        foregroundColor(color())
    }
}

// MARK: - ForegroundColor: Text

extension Text {
    /// Sets the color of the text displayed by this view.
    ///
    /// Use this method to change the color of the text rendered by a text view.
    ///
    /// For example, you can display the names of the color red based on some
    /// condition:
    ///
    /// ```swift
    /// Text("Red")
    ///     .foregroundColor {
    ///         isActive ? .red : nil
    ///     }
    /// ```
    ///
    /// - Parameter color: The color to use when displaying this text.
    /// - Returns: A text view that uses the color value you supply.
    public func foregroundColor(_ color: () -> Color?) -> Text {
        foregroundColor(color())
    }
}

// MARK: - ColorScheme

extension View {
    /// Conditionally sets this view’s color scheme.
    ///
    /// Use `colorScheme(_:)` to set the color scheme for the view to which you
    /// apply it and any subviews.
    ///
    /// - Parameter colorScheme: The color scheme for this view.
    /// - Returns: A view that sets this view’s color scheme.
    public func colorScheme(_ colorScheme: ColorScheme?) -> some View {
        unwrap(colorScheme) { content, colorScheme in
            content
                .colorScheme(colorScheme)
        }
    }
}

// MARK: - Shadow

extension View {
    func floatingShadow() -> some View {
        shadow(color: Color(white: 0, opacity: 0.08), radius: 8, x: 0, y: 4)
    }
}

// MARK: - Hidden

extension View {
    /// Hide or show the view based on a Boolean value.
    ///
    /// Example for visibility:
    ///
    /// ```swift
    /// Text("Label")
    ///     .hidden(true)
    /// ```
    ///
    /// Example for complete removal:
    ///
    /// ```swift
    /// Text("Label")
    ///     .hidden(true, remove: true)
    /// ```
    ///
    /// - Parameters:
    ///   - hidden: Set to `false` to show the view. Set to `true` to hide the view.
    ///   - remove: A Boolean value indicating whether to remove the view.
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

// MARK: - Accessibility

extension View {
    /// Adds a label to the view that describes its contents.
    ///
    /// Use this method to provide an accessibility label for a view that doesn’t
    /// display text, like an icon. For example, you could use this method to label
    /// a button that plays music with the text “Play”. Don’t include text in the
    /// label that repeats information that users already have. For example, don’t
    /// use the label “Play button” because a button already has a trait that
    /// identifies it as a button.
    public func accessibilityLabel(_ label: String?...) -> some View {
        accessibilityLabel(Text(label.joined(separator: ", ")))
    }
}

// MARK: - Clip

extension View {
    /// Clips the content by setting offset to `.onePixel` to hide the last
    /// separator automatically.
    public func clipLastSeparator() -> some View {
        clipped(offsetY: -.onePixel)
    }

    /// Clips the content by setting offset Y by given value.
    public func clipped(offsetY: CGFloat) -> some View {
        clipShape(Rectangle().offset(y: offsetY))
    }
}
