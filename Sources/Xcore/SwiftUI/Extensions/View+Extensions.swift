//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Embed this view in a navigation view.
    ///
    /// - Note: This method is internal on purpose to allow the app target to
    ///   declare their own variant in case they want to use this method name to
    ///   apply any additional modifications (e.g., setting the navigation view style
    ///   `.navigationViewStyle(.stack)`).
    func embedInNavigation() -> some View {
        NavigationView { self }
    }

    /// Wraps this view with a type eraser.
    ///
    /// - Returns: An `AnyView` wrapping this view.
    public func eraseToAnyView() -> AnyView {
        AnyView(self)
    }
}

// MARK: - BackgroundColor

extension View {
    /// Sets the background color behind this view.
    public func backgroundColor(_ color: Color, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View {
        background(
            color
                .ignoresSafeArea(edges: edges)
        )
    }

    /// Sets the background color behind this view.
    public func backgroundColor(ignoresSafeAreaEdges edges: Edge.Set = .all, _ color: () -> Color) -> some View {
        background(
            color()
                .ignoresSafeArea(edges: edges)
        )
    }

    /// Sets the background color behind this view.
    @_disfavoredOverload
    public func backgroundColor(_ color: UIColor, ignoresSafeAreaEdges edges: Edge.Set = .all) -> some View {
        background(
            Color(color)
                .ignoresSafeArea(edges: edges)
        )
    }

    /// Sets the background color behind this view.
    @_disfavoredOverload
    public func backgroundColor(ignoresSafeAreaEdges edges: Edge.Set = .all, _ color: () -> UIColor) -> some View {
        background(
            Color(color())
                .ignoresSafeArea(edges: edges)
        )
    }
}

// MARK: - ForegroundColor

extension View {
    /// Sets the color that the view uses for foreground elements.
    public func foregroundColor(_ color: () -> Color) -> some View {
        foregroundColor(color())
    }

    /// Sets the color that the view uses for foreground elements.
    @_disfavoredOverload
    public func foregroundColor(_ color: () -> UIColor) -> some View {
        foregroundColor(Color(color()))
    }

    /// Sets the color that the view uses for foreground elements.
    @_disfavoredOverload
    public func foregroundColor(_ color: UIColor) -> some View {
        foregroundColor(Color(color))
    }
}

// MARK: - ForegroundColor: Text

extension Text {
    /// Sets the color that the view uses for foreground elements.
    public func foregroundColor(_ color: () -> Color) -> Text {
        foregroundColor(color())
    }

    /// Sets the color that the view uses for foreground elements.
    @_disfavoredOverload
    public func foregroundColor(_ color: () -> UIColor) -> Text {
        foregroundColor(Color(color()))
    }

    /// Sets the color that the view uses for foreground elements.
    @_disfavoredOverload
    public func foregroundColor(_ color: UIColor) -> Text {
        foregroundColor(Color(color))
    }
}

// MARK: - Tint & Accent Color

extension View {
    @available(iOS, introduced: 14, deprecated: 15, message: "Use .tint() and .accentColor() directly.")
    @ViewBuilder
    func _xtint(_ tint: Color?) -> some View {
        if #available(iOS 15.0, *) {
            self.tint(tint)
                .accentColor(tint)
        } else {
            self.accentColor(tint)
        }
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
    /// Hide or show the view based on a boolean value.
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

// MARK: - Spacer

public func Spacer(height: CGFloat) -> some View {
    Spacer()
        .frame(height: height)
}

public func Spacer(width: CGFloat) -> some View {
    Spacer()
        .frame(width: width)
}
