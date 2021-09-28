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
    private let label: AnyView
    private let configuration: TextFieldConfiguration<Formatter>
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void
    private var onValidationChanged: (Bool) -> Void = { _ in }

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
    }

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
            textField: .init(textFieldView),
            label: .init(label),
            configuration: .init(configuration),
            text: valueProxy,
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
                        text: valueProxy,
                        onEditingChanged: { isFocused in
                            self.isFocused = isFocused
                            onEditingChanged(isFocused)
                        },
                        onCommit: onCommit
                    )
                case true:
                    SecureField("", text: valueProxy, onCommit: onCommit)
            }
        }
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
