//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct DynamicTextField<Formatter: TextFieldFormatter>: View {
    @Environment(\.dynamicTextFieldStyle) private var style
    @Binding private var value: Formatter.Value
    @State private var isValid = true
    @State private var isFocused = false
    @State private var isFloatingPlaceholderEnabled = true
    @State private var isSecure: Bool
    private let configuration: TextFieldConfiguration<Formatter>
    private var placeholder: LabelContent<AnyView>
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void

    private var valueProxy: Binding<String> {
        .init(
            get: { configuration.formatter.string(from: value) },
            set: { newString in
                if configuration.formatter.shouldChange(to: newString) {
                    value = configuration.formatter.value(from: newString)
                    validate(newString)
                }
            }
        )
    }

    public var body: some View {
        style.makeBody(configuration: .init(
            label: .init(label),
            configuration: .init(configuration),
            text: valueProxy.wrappedValue,
            isValid: isValid,
            isFocused: isFocused
        ))
    }

    private var label: some View {
        HStack {
            textField
            maskButtonIfNeeded
        }
    }

    private var textField: some View {
        InternalTextField(
            isValid: $isValid,
            isSecure: $isSecure,
            text: valueProxy,
            onEditingChanged: { isFocused in
                self.isFocused = isFocused
                onEditingChanged(isFocused)
            },
            onCommit: onCommit,
            label: placeholder
        )
        .autocapitalization(configuration.autocapitalization)
        .autocorrection(configuration.autocorrection)
        .keyboardType(configuration.keyboard)
        .textContentType(configuration.textContentType)
        .disabled(!configuration.isEditable)
    }

    @ViewBuilder
    private var maskButtonIfNeeded: some View {
        if configuration.secureTextEntry == .yesWithToggleButton {
            Button {
                isSecure.toggle()
            } label: {
                Image(system: isSecure ? .eye : .eyeSlash)
            }
            .accessibilityLabel(Text(isSecure ? "Show" : "Hide"))
        }
    }

    private func validate(_ newText: String) {
        let newValue = newText.validate(rule: configuration.validation)

        if isValid != newValue {
            isValid = newValue
        }
    }
}

// MARK: - Inits

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
        self.placeholder = .left(.left(titleKey))
        self._value = value
        self._isSecure = State(initialValue: configuration.secureTextEntry != .no)
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
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
    public init<S>(
        _ title: S,
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) where S: StringProtocol {
        self.placeholder = .left(.right(String(title)))
        self._value = value
        self._isSecure = State(initialValue: configuration.secureTextEntry != .no)
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
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
    public init<Label: View>(
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        @ViewBuilder label: () -> Label
    ) {
        self.placeholder = .right(label().eraseToAnyView())
        self._value = value
        self._isSecure = State(initialValue: configuration.secureTextEntry != .no)
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
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
        let configuration = TextFieldConfiguration<Formatter>.text
        self.placeholder = .left(.left(titleKey))
        self._value = value
        self._isSecure = State(initialValue: configuration.secureTextEntry != .no)
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
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
    public init<S>(
        _ title: S,
        value: Binding<String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {}
    ) where S: StringProtocol {
        let configuration = TextFieldConfiguration<Formatter>.text
        self.placeholder = .left(.right(String(title)))
        self._value = value
        self._isSecure = State(initialValue: configuration.secureTextEntry != .no)
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
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
    public init<Label: View>(
        value: Binding<String>,
        onEditingChanged: @escaping (Bool) -> Void = { _ in },
        onCommit: @escaping () -> Void = {},
        @ViewBuilder label: () -> Label
    ) {
        let configuration = TextFieldConfiguration<Formatter>.text
        self.placeholder = .right(label().eraseToAnyView())
        self._value = value
        self._isSecure = State(initialValue: configuration.secureTextEntry != .no)
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
    }
}
