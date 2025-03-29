//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that presents content in a custom fitted sheet layout with an
/// optional header.
///
/// The header is displayed with centered text and standard padding, while the
/// content uses a custom button style. Separators are inserted between the
/// header and content to improve visual clarity. The view adapts its height to
/// fit the content using the
/// `.presentationDetents(.contentHeight(insets: .zero))` modifier.
///
/// **Usage**
///
/// ```swift
/// struct ContentView: View {
///     @State private var showOptions = false
///
///     var body: some View {
///         Button("Show Options") {
///             showOptions = true
///         }
///         .sheet(isPresented: $showOptions) {
///             CustomFittedSheetContent {
///                 Button("Option 1") {}
///                 Button("Option 2") {}
///                 Button("Option 3") {}
///             } header: {
///                 Label("Sheet Title", systemImage: "tv")
///                     .font(.app(.title3))
///             }
///         }
///     }
/// }
/// ```
public struct CustomFittedSheetContent<Content: View, Header: View>: View {
    @Environment(\.theme) private var theme
    @Environment(\.multilineTextAlignment) private var textAlignment
    private let content: () -> Content
    private let header: () -> Header

    /// Creates a custom fitted sheet content with optional header.
    ///
    /// - Parameters:
    ///   - content: A view builder that produces the content of the sheet.
    ///   - header: A view builder that produces the header of the sheet.
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
                .buttonStyle(CustomFittedSheetContentButtonStyle())
                .separator()
        }
        .clipLastSeparator()
        .presentationDetents(.contentHeight(insets: .zero))
    }
}

// MARK: - Inits

extension CustomFittedSheetContent where Header == Text? {
    /// Creates a custom fitted sheet content with optional header from a string.
    ///
    /// - Parameters:
    ///   - title: An optional title to be displayed in the header.
    ///   - content: A view builder that produces the content of the sheet.
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

private struct CustomFittedSheetContentButtonStyle: ButtonStyle {
    @Environment(\.multilineTextAlignment) private var textAlignment
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(maxWidth: .infinity, alignment: textAlignment.alignment)
            .padding(.defaultSpacing)
            .contentShape(.rect)
            .opacity(opacity(configuration))
    }

    private func opacity(_ configuration: Configuration) -> CGFloat {
        !isEnabled ? 0.2 : (configuration.isPressed ? 0.2 : 1)
    }
}

// MARK: - Preview

#Preview {
    CustomFittedSheetContent {
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
