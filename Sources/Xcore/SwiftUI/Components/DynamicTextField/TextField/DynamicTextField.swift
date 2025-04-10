//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A SwiftUI text field that supports dynamic formatting, validation, and secure entry.
///
/// `TextFieldView` provides an extensible, SwiftUI-native alternative to `TextField`,
/// allowing for custom formatting, validation, and secure text entry modes.
///
/// ## Example Usage
///
/// ```swift
/// struct ContentView: View {
///     @State private var emailAddress: String = ""
///
///     var body: some View {
///         DynamicTextField("Email Address", value: $emailAddress, configuration: .emailAddress)
///     }
/// }
/// ```
public struct DynamicTextField<Label: View, Formatter: TextFieldFormatter>: View {
    @Environment(\.dynamicTextFieldStyle) private var style
    @Binding private var value: Formatter.Value
    @State private var text: String
    @State private var previousText: String
    @State private var isValid = true
    @State private var isFocused = false
    @State private var isSecure: Bool
    private let label: Label
    private let configuration: TextFieldConfiguration<Formatter>
    private var onValidationChanged: ((Bool) -> Void)?
    private var formatter: Formatter {
        configuration.formatter
    }

    /// Creates a text field with a label generated from a view builder.
    ///
    /// - Parameters:
    ///   - value: The value to display and edit.
    ///   - configuration: A configuration defining behavior, formatting, and
    ///     validation.
    ///   - label: A view builder that produces a label for the text field,
    ///     describing its purpose.
    public init(
        value: Binding<Formatter.Value>,
        configuration: TextFieldConfiguration<Formatter>,
        @ViewBuilder label: () -> Label
    ) {
        self._value = value
        self._isSecure = State(initialValue: configuration.textEntryMode != .plain)
        self.label = label()
        self.configuration = configuration

        // Initial value
        let formatter = configuration.formatter
        let sanitizedText = formatter.unformat(formatter.string(from: value.wrappedValue))
        let initialValue = formatter.format(sanitizedText) ?? ""
        self._text = .init(wrappedValue: initialValue)
        self._previousText = .init(wrappedValue: initialValue)
    }

    public var body: some View {
        style.makeBody(configuration: .init(
            textField: .init(textFieldView),
            label: .init(label),
            configuration: .init(configuration),
            text: $text,
            isValid: isValid,
            isFocused: isFocused
        ))
    }

    private var textFieldView: some View {
        HStack {
            textField
            maskButtonIfNeeded
        }
    }

    private var textField: some View {
        Group {
            switch isSecure {
                case false:
                    TextField(
                        "",
                        text: $text,
                        onEditingChanged: { isFocused in
                            self.isFocused = isFocused
                        }
                    )
                case true:
                    SecureField("", text: $text)
            }
        }
        .textInputAutocapitalization(configuration.autocapitalization)
        .autocorrectionDisabled(configuration.autocorrectionDisabled)
        .keyboardType(configuration.keyboard)
        .textContentType(configuration.textContentType)
        .disabled(!configuration.isEditable)
        // If text field changes the then format the text and also update the value.
        .onChange(of: text) { _, newText in
            // Check if the input is valid
            if let displayText = formatter.format(formatter.unformat(newText)) {
                // If the input is valid, format it and display it
                text = displayText
                previousText = text

                // Sanitize the display text
                let sanitizedText = formatter.unformat(displayText)
                validate(sanitizedText)
                // In case the input produces a new value send it over
                let newValue = formatter.value(from: sanitizedText)
                if newValue != value {
                    value = newValue
                }
            } else {
                text = previousText
            }
        }
        // If value changes then update the text field.
        .onChange(of: value) { _, newValue in
            let currentValue = formatter.value(from: formatter.unformat(text))
            guard currentValue != newValue else {
                return
            }
            let sanitizedText = formatter.unformat(formatter.string(from: newValue))
            if let displayText = formatter.format(sanitizedText), displayText != text {
                DispatchQueue.main.async {
                    text = displayText
                    previousText = text
                }
            }
        }
    }

    @ViewBuilder
    private var maskButtonIfNeeded: some View {
        if configuration.textEntryMode == .maskedWithToggle {
            Button(isSecure ? "Show" : "Hide", systemImage: isSecure ? "eye" : "eye.slash") {
                isSecure.toggle()
            }
            .imageScale(.small)
            .labelStyle(.iconOnly)
            .accessibilityIdentifier("maskButton")
        }
    }

    private func validate(_ newText: String) {
        let newValue = newText.validate(rule: configuration.validation)

        if isValid != newValue {
            isValid = newValue
            onValidationChanged?(newValue)
        }
    }
}

extension DynamicTextField {
    public func onValidationChanged(_ value: Binding<Bool>) -> Self {
        var copy = self
        copy.onValidationChanged = {
            value.wrappedValue = $0
        }
        return copy
    }
}
