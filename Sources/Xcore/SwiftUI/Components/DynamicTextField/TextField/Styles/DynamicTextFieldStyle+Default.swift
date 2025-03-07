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
                switch attributes.placeholderBehavior {
                    case .inline:
                        inlineContent
                    case .floating:
                        floatingContent
                }

                ProgressView()
                    .hidden(!isLoading, remove: true)
            }
            .foregroundStyle {
                isEnabled ? nil : attributes.disabledColor
            }
        }

        private var inlineContent: some View {
            ZStack(alignment: .leading) {
                placeholderView
                    .hidden(!text.isEmpty)

                configuration.textField
            }
        }

        private var floatingContent: some View {
            ZStack(alignment: .leading) {
                placeholderView
                    .onSizeChange {
                        labelHeight = $0.height.rounded()
                    }
                    .offset(y: -floatingContentOffsetY)
                    .scaleEffect(text.isEmpty ? 1.0 : 0.75, anchor: .topLeading)
                    .animation(.smooth, value: floatingContentOffsetY)

                configuration.textField
                    .onSizeChange {
                        textFieldHeight = $0.height.rounded()
                    }
                    .offset(y: floatingContentOffsetY)
            }
            .frame(height: floor(textFieldHeight + labelHeight))
        }

        private var placeholderView: some View {
            configuration.label
                .foregroundStyle {
                    if text.isEmpty {
                        return attributes.placeholderColor
                    }

                    return configuration.isValid
                        ? attributes.placeholderSuccessColor
                        : attributes.placeholderErrorColor
                }
        }

        private var floatingContentOffsetY: CGFloat {
            text.isEmpty ? 0 : floor(textFieldHeight * 0.5)
        }
    }
}

// MARK: - Dot Syntax Support

extension DynamicTextFieldStyle where Self == DefaultDynamicTextFieldStyle {
    static var `default`: Self { .init() }
}
