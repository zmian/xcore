//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Applies an inline button style to all buttons within this view.
    ///
    /// This modifier allows you to define a custom appearance and interaction
    /// behavior for buttons, using an inline closure to create a custom style. It
    /// is useful for quickly prototyping a UI.
    ///
    /// For example, to set all buttons to display blue text:
    ///
    /// ```swift
    /// HStack {
    ///     Button("Sign In", action: signIn)
    ///     Button("Register", action: register)
    /// }
    /// .buttonStyle { configuration in
    ///     configuration.label
    ///         .foregroundStyle(.blue)
    /// }
    /// ```
    ///
    /// - Parameter style: A closure that receives a `ButtonStyle.Configuration` and
    ///   returns a view describing the appearance of buttons within this view.
    /// - Returns: A view modified with the specified inline button style.
    @_disfavoredOverload
    public func buttonStyle(_ style: @escaping (_ configuration: ButtonStyle.Configuration) -> some View) -> some View {
        buttonStyle(InlineButtonStyle(style: style))
    }
}

// MARK: - ButtonStyle

private struct InlineButtonStyle<Body: View>: ButtonStyle {
    @ViewBuilder let style: (Configuration) -> Body

    func makeBody(configuration: Configuration) -> Body {
        style(configuration)
    }
}

#Preview {
    Button("Done") {}
        .buttonStyle { configuration in
            configuration.label
                .foregroundStyle(.indigo)
                .fontWeight(.black)
        }
}
