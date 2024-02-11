//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct DefaultDynamicTextFieldStyle: DynamicTextFieldStyle {
    func makeBody(configuration: Configuration) -> some View {
        InternalBody(configuration: configuration)
    }
}

// MARK: - Internal

extension DefaultDynamicTextFieldStyle {
    private struct InternalBody: View {
        @Environment(\.isEnabled) private var isEnabled
        @Environment(\.isLoading) private var isLoading
        @Environment(\.textFieldAttributes) private var attributes
        @State private var textFieldHeight: CGFloat = 0
        @State private var labelHeight: CGFloat = 0
        let configuration: Configuration

        private var text: String {
            configuration.text
        }

        var body: some View {
            HStack(spacing: .s2) {
                if attributes.disableFloatingPlaceholder {
                    withoutFloating
                } else {
                    withFloating
                }

                ProgressView()
                    .hidden(!isLoading, remove: true)
            }
            .unwrap(foregroundColor) {
                $0.foregroundColor($1)
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
                .foregroundStyle {
                    if text.isEmpty {
                        return attributes.placeholderColor
                    }

                    return configuration.isValid ?
                    attributes.placeholderSuccessColor :
                    attributes.placeholderErrorColor
                }
        }

        private var placeholderOffsetY: CGFloat {
            text.isEmpty ? 0 : -floor(textFieldHeight * 0.5)
        }

        private var textFieldOffsetY: CGFloat {
            text.isEmpty ? 0 : floor(textFieldHeight * 0.5)
        }

        private var foregroundColor: Color? {
            isEnabled ? nil : attributes.disabledColor
        }
    }
}

// MARK: - Dot Syntax Support

extension DynamicTextFieldStyle where Self == DefaultDynamicTextFieldStyle {
    static var `default`: Self { .init() }
}
