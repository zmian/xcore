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
    ///   - onEditingChanged: The action to perform when the user
    ///     begins editing `text` and after the user finishes editing `text`.
    ///     The closure receives a Boolean value that indicates the editing
    ///     status: `true` when the user begins editing, `false` when they
    ///     finish.
    ///   - onCommit: An action to perform when the user performs an action
    ///     (for example, when the user presses the Return key) while the text
    ///     field has focus.
    public init(
        _ titleKey: LocalizedStringKey,
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.init(
            value: value,
            label: Text(titleKey).accessibilityHidden(true),
            configuration: configuration,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - value: The value to display and edit.
    ///   - configuration: A configuration used to define the behavior of the text
    ///     field.
    ///   - onEditingChanged: The action to perform when the user
    ///     begins editing `text` and after the user finishes editing `text`.
    ///     The closure receives a Boolean value that indicates the editing
    ///     status: `true` when the user begins editing, `false` when they
    ///     finish.
    ///   - onCommit: An action to perform when the user performs an action
    ///     (for example, when the user presses the Return key) while the text
    ///     field has focus.
    public init(
        _ title: some StringProtocol,
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.init(
            value: value,
            label: Text(title).accessibilityHidden(true),
            configuration: configuration,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - value: The value to display and edit.
    ///   - configuration: A configuration used to define the behavior of the text
    ///     field.
    ///   - onEditingChanged: The action to perform when the user
    ///     begins editing `text` and after the user finishes editing `text`.
    ///     The closure receives a Boolean value that indicates the editing
    ///     status: `true` when the user begins editing, `false` when they
    ///     finish.
    ///   - onCommit: An action to perform when the user performs an action
    ///     (for example, when the user presses the Return key) while the text
    ///     field has focus.
    ///   - label: The label of the text field, describing its purpose.
    public init(
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        @ViewBuilder label: () -> some View
    ) {
        self.init(
            value: value,
            label: label(),
            configuration: configuration,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
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
    ///   - onEditingChanged: The action to perform when the user
    ///     begins editing `text` and after the user finishes editing `text`.
    ///     The closure receives a Boolean value that indicates the editing
    ///     status: `true` when the user begins editing, `false` when they
    ///     finish.
    ///   - onCommit: An action to perform when the user performs an action
    ///     (for example, when the user presses the Return key) while the text
    ///     field has focus.
    public init(
        _ titleKey: LocalizedStringKey,
        value: Binding<String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.init(
            value: value,
            label: Text(titleKey),
            configuration: .text,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - title: The title of the text view, describing its purpose.
    ///   - value: The value to display and edit.
    ///   - onEditingChanged: The action to perform when the user
    ///     begins editing `text` and after the user finishes editing `text`.
    ///     The closure receives a Boolean value that indicates the editing
    ///     status: `true` when the user begins editing, `false` when they
    ///     finish.
    ///   - onCommit: An action to perform when the user performs an action
    ///     (for example, when the user presses the Return key) while the text
    ///     field has focus.
    public init(
        _ title: some StringProtocol,
        value: Binding<String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) {
        self.init(
            value: value,
            label: Text(title),
            configuration: .text,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }

    /// Creates a text field with a text label generated from a title string.
    ///
    /// - Parameters:
    ///   - value: The value to display and edit.
    ///   - onEditingChanged: The action to perform when the user
    ///     begins editing `text` and after the user finishes editing `text`.
    ///     The closure receives a Boolean value that indicates the editing
    ///     status: `true` when the user begins editing, `false` when they
    ///     finish.
    ///   - onCommit: An action to perform when the user performs an action
    ///     (for example, when the user presses the Return key) while the text
    ///     field has focus.
    ///   - label: The label of the text field, describing its purpose.
    public init(
        value: Binding<String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        @ViewBuilder label: () -> some View
    ) {
        self.init(
            value: value,
            label: label(),
            configuration: .text,
            onEditingChanged: onEditingChanged,
            onCommit: onCommit
        )
    }
}
