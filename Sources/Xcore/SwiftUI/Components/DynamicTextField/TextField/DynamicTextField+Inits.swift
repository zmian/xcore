//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Configuration

extension DynamicTextField<Never, PassthroughTextFieldFormatter> {
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

extension DynamicTextField where Label == Text {
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
        self.init(value: value, configuration: configuration) {
            Text(titleKey)
        }
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
        self.init(value: value, configuration: configuration) {
            Text(title)
        }
    }
}

// MARK: - Convenience Inits

extension DynamicTextField where Formatter == PassthroughTextFieldFormatter {
    /// Creates a text field with a text label generated from a localized title
    /// string.
    ///
    /// - Parameters:
    ///   - titleKey: The key for the localized title of the text field,
    ///     describing its purpose.
    ///   - text: The text to display and edit.
    public init(_ titleKey: LocalizedStringKey, value: Binding<String>) where Label == Text {
        self.init(value: value, configuration: .text) {
            Text(titleKey)
        }
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - value: The value to display and edit.
    public init(_ title: some StringProtocol, value: Binding<String>) where Label == Text {
        self.init(value: value, configuration: .text) {
            Text(title)
        }
    }

    /// Creates a text field with a label generated from a view builder.
    ///
    /// - Parameters:
    ///   - value: The value to display and edit.
    ///   - label: A view builder that produces a label for the text field,
    ///     describing its purpose.
    public init(value: Binding<String>, @ViewBuilder label: () -> Label) {
        self.init(
            value: value,
            configuration: .text,
            label: label
        )
    }
}
