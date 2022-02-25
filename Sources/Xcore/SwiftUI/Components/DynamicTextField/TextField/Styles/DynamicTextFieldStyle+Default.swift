//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct DefaultDynamicTextFieldStyle: DynamicTextFieldStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        DynamicTextField.default(configuration)
    }
}

// MARK: - Dot Syntax Support

extension DynamicTextFieldStyle where Self == DefaultDynamicTextFieldStyle {
    static var `default`: Self { .init() }
}

// MARK: - Internal

struct DefaultDynamicTextFieldView: View {
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.textFieldAttributes) private var attributes
    @State private var textFieldHeight: CGFloat = 0
    @State private var labelHeight: CGFloat = 0
    let configuration: DynamicTextFieldStyleConfiguration

    private var text: String {
        configuration.text
    }

    var body: some View {
        Group {
            if attributes.disableFloatingPlaceholder {
                withoutFloating
            } else {
                withFloating
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
            placeholderView
                .hidden(!text.isEmpty)

            configuration.textField
        }
    }

    private var withFloating: some View {
        ZStack(alignment: .leading) {
            placeholderView
                .readSize {
                    labelHeight = $0.height
                }
                .offset(y: placeholderOffsetY)
                .scaleEffect(CGFloat(text.isEmpty ? 1.0 : 0.75), anchor: .topLeading)
                .animation(.spring(response: .default, dampingFraction: 0.75), value: placeholderOffsetY)

            configuration.textField
                .readSize {
                    textFieldHeight = $0.height
                }
                .offset(y: textFieldOffsetY)
        }
        .frame(height: floor(textFieldHeight + labelHeight))
    }

    private var placeholderView: some View {
        configuration.label
            .foregroundColor {
                if text.isEmpty {
                    return attributes.placeholderColor
                }

                return configuration.isValid ?
                    attributes.placeholderSuccessColor :
                        attributes.placeholderErrorColor
            }
    }

    private var placeholderOffsetY: CGFloat {
        if text.isEmpty {
            return 0
        }

        return -floor(textFieldHeight * 0.5)
    }

    private var textFieldOffsetY: CGFloat {
        if text.isEmpty {
            return 0
        }

        return floor(textFieldHeight * 0.5)
    }
}
