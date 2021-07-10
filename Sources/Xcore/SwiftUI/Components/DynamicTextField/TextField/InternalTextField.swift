//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct InternalTextField<Label>: View where Label: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textFieldAttributes) private var attributes
    @State private var textFieldHeight: CGFloat = 0
    @State private var labelHeight: CGFloat = 0
    @Binding private var isValid: Bool
    @Binding private var isSecure: Bool
    private let text: Binding<String>
    private let onEditingChanged: (Bool) -> Void
    private let onCommit: () -> Void
    private let label: LabelContainer<Label>

    init(
        isValid: Binding<Bool>,
        isSecure: Binding<Bool>,
        text: Binding<String>,
        onEditingChanged: @escaping (Bool) -> Void,
        onCommit: @escaping () -> Void,
        label: LabelContent<Label>
    ) {
        self._isValid = isValid
        self._isSecure = isSecure
        self.text = text
        self.onEditingChanged = onEditingChanged
        self.onCommit = onCommit
        self.label = .init(label, text: text, isValid: isValid)
    }

    var body: some View {
        Group {
            if attributes.disableFloatingPlaceholder {
                withoutFloating
            } else {
                withFloating
                    .frame(height: textFieldHeight + labelHeight)
            }
        }
        .apply {
            if !isEnabled, let disabledColor = attributes.disabledColor {
                $0.foregroundColor(disabledColor)
            } else {
                $0
            }
        }
    }

    private var withoutFloating: some View {
        ZStack(alignment: .leading) {
            label
                .hidden(!text.wrappedValue.isEmpty)
            textField
        }
    }

    private var withFloating: some View {
        ZStack(alignment: .leading) {
            label
                .readSize {
                    labelHeight = $0.height
                }
                .offset(y: placeholderOffsetY)
                .scaleEffect(CGFloat(text.wrappedValue.isEmpty ? 1.0 : 0.75), anchor: .topLeading)
                .animation(.spring(response: .default, dampingFraction: 0.75))
            textField
                .readSize {
                    textFieldHeight = $0.height
                }
                .offset(y: textFieldOffsetY)
        }
    }

    @ViewBuilder
    private var textField: some View {
        switch isSecure {
            case false:
                TextField("", text: text, onEditingChanged: onEditingChanged, onCommit: onCommit)
            case true:
                SecureField("", text: text, onCommit: onCommit)
        }
    }

    private var placeholderOffsetY: CGFloat {
        if text.wrappedValue.isEmpty {
            return 0
        }

        return -floor(textFieldHeight * 0.5)
    }

    private var textFieldOffsetY: CGFloat {
        if text.wrappedValue.isEmpty {
            return 0
        }

        return floor(textFieldHeight * 0.5)
    }
}

// MARK: - Label

extension InternalTextField {
    private struct LabelContainer<Label>: View where Label: View {
        @Environment(\.textFieldAttributes) private var attributes
        private let text: Binding<String>
        private let isValid: Binding<Bool>
        private let content: LabelContent<Label>

        fileprivate init(_ content: LabelContent<Label>, text: Binding<String>, isValid: Binding<Bool>) {
            self.content = content
            self.text = text
            self.isValid = isValid
        }

        var body: some View {
            Group {
                switch content {
                    case let .left(title):
                        Text(title)
                    case let .right(label):
                        label
                }
            }
            .foregroundColor(color)
        }

        private var color: Color {
            if text.wrappedValue.isEmpty {
                return attributes.placeholderColor
            }

            return isValid.wrappedValue ? attributes.placeholderSuccessColor : attributes.placeholderErrorColor
        }
    }
}

// MARK: - Helpers

typealias TextContent = Either<LocalizedStringKey, String>
typealias LabelContent<V> = Either<TextContent, V> where V: View

extension Text {
    fileprivate init(_ content: TextContent) {
        switch content {
            case let .left(content):
                self.init(content)
            case let .right(content):
                self.init(content)
        }
    }
}
