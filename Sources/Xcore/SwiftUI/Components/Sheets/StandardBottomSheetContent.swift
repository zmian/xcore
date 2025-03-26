//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A view that presents a standard bottom sheet layout with a title, optional
/// message, and configurable header and footer content.
///
/// Use this view to display modal content in a bottom sheet format. The layout
/// adapts its text alignment based on device size class, automatically
/// centering content on larger devices like iPads where the sheet is presented
/// as a popup.
///
/// You can customize the content by providing header and footer views.
///
/// **Usage**
///
/// ```swift
/// struct ContentView: View {
///     @State private var showConfirmation = false
///
///     var body: some View {
///         Button("Delete") {
///             showConfirmation = true
///         }
///         .sheet(isPresented: $showConfirmation) {
///             StandardBottomSheetContent("Delete Item", message: "Are you sure you want to delete this?") {
///                 HStack {
///                     Button.cancel {
///                         showConfirmation = false
///                     }
///
///                     Button.delete {
///                         // Handle deletion
///                     }
///                 }
///             }
///         }
///     }
/// }
/// ```
public struct StandardBottomSheetContent<Header: View, Footer: View>: View {
    @Environment(\.theme) private var theme
    @Environment(\.multilineTextAlignment) private var multilineTextAlignment
    @Environment(\.horizontalSizeClass) private var sizeClass
    private let title: Text
    private let message: Text?
    private let header: () -> Header
    private let footer: () -> Footer

    /// Creates a bottom sheet with a title and message, along with header and
    /// footer content.
    ///
    /// - Parameters:
    ///   - title: The title text to display.
    ///   - message: An optional secondary message text.
    ///   - header: A view builder that produces the header content.
    ///   - footer: A view builder that produces the footer content.
    public init(
        _ title: Text,
        message: Text? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.title = title
        self.message = message
        self.header = header
        self.footer = footer
    }

    public var body: some View {
        VStack(spacing: .defaultSpacing) {
            if Header.self != Never.self {
                header()
            }

            VStack(alignment: textAlignment.horizontal, spacing: .s2) {
                title
                    .font(.app(isPopup ? .body : .title2, weight: .medium))
                    .foregroundStyle(theme.textColor)
                    .accessibilityAddTraits(.isHeader)

                if let message {
                    message
                        .foregroundStyle(theme.textSecondaryColor)
                }
            }
            .frame(maxWidth: .infinity, alignment: textAlignment.alignment)

            if Footer.self != Never.self {
                footer()
            }
        }
        .multilineTextAlignment(textAlignment)
        .presentationDetents(.contentHeight)
    }

    private var textAlignment: TextAlignment {
        isPopup ? .center : multilineTextAlignment
    }

    /// On iPad, the bottom sheet is displayed as a popup.
    private var isPopup: Bool {
        sizeClass == .regular
    }
}

// MARK: - Inits

extension StandardBottomSheetContent {
    /// Creates a bottom sheet with a title and message, along with header and
    /// footer content.
    ///
    /// - Parameters:
    ///   - title: The title text to display.
    ///   - message: An optional secondary message text.
    ///   - header: A view builder that produces the header content.
    ///   - footer: A view builder that produces the footer content.
    public init(
        _ title: String,
        message: String? = nil,
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.init(
            Text(title),
            message: message.map(Text.init),
            header: header,
            footer: footer
        )
    }
}

extension StandardBottomSheetContent where Header == Never {
    /// Creates a bottom sheet with a title and message generated from `Text` and a
    /// footer content.
    ///
    /// - Parameters:
    ///   - title: The title text to display.
    ///   - message: An optional secondary message text.
    ///   - footer: A view builder that produces the footer content.
    public init(
        _ title: Text,
        message: Text? = nil,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.init(
            title,
            message: message,
            header: { fatalError() },
            footer: footer
        )
    }

    /// Creates a bottom sheet with a title and message generated from string and a
    /// footer content.
    ///
    /// - Parameters:
    ///   - title: The title text to display.
    ///   - message: An optional secondary message text.
    ///   - footer: A view builder that produces the footer content.
    public init(
        _ title: String,
        message: String? = nil,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.init(
            Text(title),
            message: message.map(Text.init),
            footer: footer
        )
    }
}

// MARK: - Preview

#Preview {
    Group {
        let L = Samples.Strings.deleteMessageAlert

        StandardBottomSheetContent(L.title, message: L.message) {
            HStack {
                Button.cancel {
                    print("Cancel Tapped")
                }
                .buttonStyle(.secondary)

                Button.delete {
                    print("Delete Tapped")
                }
                .buttonStyle(.primary)
            }
        }

        StandardBottomSheetContent(L.title, message: L.message) {
            EmptyView()
        }
    }
    .padding(.defaultSpacing)
    .frame(max: .infinity)
    .background(.secondary.opacity(0.15))
}
