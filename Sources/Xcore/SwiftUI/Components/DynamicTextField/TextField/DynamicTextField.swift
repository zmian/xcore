//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

public struct DynamicTextField<Formatter: TextFieldFormatter>: View {
    @Environment(\.dynamicTextFieldStyle) private var style
    @Binding private var value: Formatter.Value
    @State private var text: String
    @State private var previousText: String
    @State private var isValid = true
    @State private var isFocused = false
    @State private var isFloatingPlaceholderEnabled = true
    @State private var isSecure: Bool
    private let label: AnyView
    private let configuration: TextFieldConfiguration<Formatter>
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void
    private var onValidationChanged: (Bool) -> Void = { _ in }
    private var formatter: Formatter {
        configuration.formatter
    }

    init<Label: View>(
        value: Binding<Formatter.Value>,
        label: Label,
        configuration: TextFieldConfiguration<Formatter>,
        onEditingChanged: @escaping (Bool) -> Void,
        onCommit: @escaping () -> Void
    ) {
        self._value = value
        self._isSecure = State(initialValue: configuration.secureTextEntry != .no)
        self.label = label.eraseToAnyView()
        self.configuration = configuration
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit

        // Initial value
        let formatter = configuration.formatter
        let initialValue = formatter.displayValue(from: formatter.transformToString(value.wrappedValue))
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
                            onEditingChanged(isFocused)
                        },
                        onCommit: onCommit
                    )
                case true:
                    SecureField("", text: $text, onCommit: onCommit)
            }
        }
        .autocapitalization(configuration.autocapitalization)
        .autocorrection(configuration.autocorrection)
        .keyboardType(configuration.keyboard)
        .textContentType(configuration.textContentType)
        .disabled(!configuration.isEditable)
        // If text field changes the then format the text and also update the value.
        .onChange(of: text) { newText in
            // Sanitize the text
            let sanitizedText = formatter.sanitizeDisplayValue(from: newText)
            // Check if the input is valid
            if formatter.shouldChange(to: sanitizedText) {
                // If the input is valid, format it and display it
                text = formatter.displayValue(from: sanitizedText)
                previousText = text
                validate(sanitizedText)
                // In case the input produces a new value send it over
                let newValue = formatter.transformToValue(sanitizedText)
                if newValue != value {
                    value = newValue
                }
            } else {
                text = previousText
            }
        }
        // If value changes the then update the text field.
        .onChange(of: value) { newValue in
            let sanitizedText = formatter.sanitizeDisplayValue(from: text)
            let currentValue = formatter.transformToValue(sanitizedText)
            guard currentValue != newValue else {
                return
            }
            let defaultText = formatter.transformToString(newValue)
            text = formatter.displayValue(from: defaultText)
            previousText = text
        }
    }

    @ViewBuilder
    private var maskButtonIfNeeded: some View {
        if configuration.secureTextEntry == .yesWithToggleButton {
            Button {
                isSecure.toggle()
            } label: {
                Image(system: isSecure ? .eye : .eyeSlash)
                    .imageScale(.small)
            }
            .accessibilityLabel(Text(isSecure ? "Show" : "Hide"))
        }
    }

    private func validate(_ newText: String) {
        let newValue = newText.validate(rule: configuration.validation)

        if isValid != newValue {
            isValid = newValue
            onValidationChanged(newValue)
        }
    }
}

extension DynamicTextField {
    public func onValidation(_ value: Binding<Bool>) -> Self {
        var copy = self
        copy.onValidationChanged = {
            value.wrappedValue = $0
        }
        return copy
    }
}
