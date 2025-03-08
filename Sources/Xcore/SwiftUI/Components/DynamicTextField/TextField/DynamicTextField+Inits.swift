//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Configuration

extension DynamicTextField<PassthroughTextFieldFormatter> {
    /// Creates a text field based on a text field style configuration.
    ///
    /// You can use this initializer within the ``makeBody(configuration:)`` method
    /// of a ``DynamicTextFieldStyle`` to create an instance of the styled text
    /// field. This is useful for custom text field styles that only modify the
    /// current text field style, as opposed to implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the text field,
    /// but otherwise preserves the stack’s current style:
    ///
    /// ```swift
    /// struct RedBorderedDynamicTextFieldStyle: DynamicTextFieldStyle {
    ///     func makeBody(configuration: Configuration) -> some View {
    ///         DynamicTextField.default(configuration)
    ///             .border(Color.red)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter configuration: A text field style configuration.
    public static func `default`(_ configuration: DynamicTextFieldStyleConfiguration) -> some View {
        DefaultDynamicTextFieldStyle()
            .makeBody(configuration: configuration)
    }
}

extension DynamicTextField {
    /// Creates a text field with a text label generated from a localized title
    /// string.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    ///   - configuration: A configuration used to define the behavior of the text
    ///     field.
    public init(
        _ titleKey: LocalizedStringKey,
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>
    ) {
        self.init(
            value: value,
            label: Text(titleKey).accessibilityHidden(true),
            configuration: configuration
        )
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - value: The value to display and edit.
    ///   - configuration: A configuration used to define the behavior of the text
    ///     field.
    public init(
        _ title: some StringProtocol,
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>
    ) {
        self.init(
            value: value,
            label: Text(title).accessibilityHidden(true),
            configuration: configuration
        )
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - value: The value to display and edit.
    ///   - configuration: A configuration used to define the behavior of the text
    ///     field.
    ///   - label: The label of the text field, describing its purpose.
    public init(
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>,
        @ViewBuilder label: () -> some View
    ) {
        self.init(
            value: value,
            label: label(),
            configuration: configuration
        )
    }
}

// MARK: - Convenience Inits

extension DynamicTextField<PassthroughTextFieldFormatter> {
    /// Creates a text field with a text label generated from a localized title
    /// string.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    public init(
        _ titleKey: LocalizedStringKey,
        value: Binding<String>
    ) {
        self.init(
            value: value,
            label: Text(titleKey),
            configuration: .text
        )
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - value: The value to display and edit.
    public init(
        _ title: some StringProtocol,
        value: Binding<String>
    ) {
        self.init(
            value: value,
            label: Text(title),
            configuration: .text
        )
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - value: The value to display and edit.
    ///   - label: The label of the text field, describing its purpose.
    public init(
        value: Binding<String>,
        @ViewBuilder label: () -> some View
    ) {
        self.init(
            value: value,
            label: label(),
            configuration: .text
        )
    }
}
