//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

public struct CustomBottomSheet<Content: View, Header: View>: View {
    @Environment(\.theme) private var theme
    @Environment(\.multilineTextAlignment) private var textAlignment
    private let content: () -> Content
    private let header: () -> Header

    public init(
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.content = content
        self.header = header
    }

    public var body: some View {
        VStack(spacing: 0) {
            if Header.self != Never.self {
                header()
                    .padding(.horizontal, .defaultSpacing)
                    .padding(.vertical, .defaultSpacing * 1.2)
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .separator()
                    .accessibilityAddTraits(.isHeader)
            }

            content()
                .buttonStyle(CustomBottomSheetButtonStyle())
                .separator()
        }
        .clipLastSeparator()
        .presentationDetents(.contentHeight(insets: .zero))
    }
}

// MARK: - Inits

extension CustomBottomSheet where Header == Text? {
    public init(
        _ title: String? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init(content: content) {
            if let title {
                Text(title)
                    .fontWeight(.semibold)
            }
        }
    }
}

// MARK: - ButtonStyle

private struct CustomBottomSheetButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        InternalBody(configuration: configuration)
    }

    private struct InternalBody: View {
        @Environment(\.multilineTextAlignment) private var textAlignment
        @Environment(\.isEnabled) private var isEnabled
        let configuration: ButtonStyleConfiguration

        var body: some View {
            configuration.label
                .frame(maxWidth: .infinity, alignment: textAlignment.alignment)
                .padding(.defaultSpacing)
                .contentShape(.rect)
                .opacity(opacity)
        }

        private var opacity: CGFloat {
            !isEnabled ? 0.2 : (configuration.isPressed ? 0.2 : 1)
        }
    }
}

// MARK: - Preview

#Preview {
    CustomBottomSheet {
        Button("Option 1") {}
        Button("Option 2") {}
        Button("Option 3") {}
    } header: {
        Label("Sheet Title", systemImage: .tv)
            .font(.app(.title3))
    }
    .frame(max: .infinity, alignment: .bottom)
    .background(.secondary)
}
