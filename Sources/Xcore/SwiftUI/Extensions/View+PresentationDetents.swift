//
// Xcore
// Copyright © 2024 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Sets the available detents for the enclosing sheet.
    ///
    /// ```swift
    /// struct ContentView: View {
    ///     @State private var showSettings = false
    ///
    ///     var body: some View {
    ///         Button("View Settings") {
    ///             showSettings = true
    ///         }
    ///         .sheet(isPresented: $showSettings) {
    ///             SettingsView()
    ///                 .presentationDetents(.contentHeight)
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter detent: A supported detent for the sheet.
    public func presentationDetents(_ detent: AppCustomPresentationDetent) -> some View {
        modifier(PresentationDetentsViewModifier(detent: detent))
    }
}

/// A custom detent used to define the presentation behavior of a sheet.
public enum AppCustomPresentationDetent {
    /// Specifies the content height of the sheet, optionally with insets.
    case contentHeight(insets: EdgeInsets?)

    /// Convenience property to specify content height without insets.
    public static var contentHeight: Self {
        .contentHeight(insets: nil)
    }
}

private struct PresentationDetentsViewModifier: ViewModifier {
    @Environment(\.theme) private var theme
    @Environment(\.horizontalSizeClass) private var sizeClass
    @State private var detentHeight: CGFloat = 0
    private let cornerRadius = 16.0
    let detent: AppCustomPresentationDetent

    func body(content: Content) -> some View {
        switch detent {
            case .contentHeight:
                VStack(spacing: 0) {
                    content
                }
                .padding(insets)
                .deviceSpecificBottomPadding()
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: preferredWidth)
                .readSize { @MainActor in
                    if detentHeight != $0.height {
                        detentHeight = $0.height
                    }
                }
                .presentationDetents([.height(detentHeight)])
                .presentationCornerRadius(cornerRadius)
                // On iPad adapt the bottom sheet to be a popup.
                .unwrap(preferredWidth) { view, preferredWidth in
                    view.presentationBackground {
                        theme.backgroundColor
                            .frame(maxWidth: preferredWidth, maxHeight: detentHeight)
                            .clipShape(.rect(cornerRadius: cornerRadius))
                    }
                }
        }
    }

    private var insets: EdgeInsets {
        if case let .contentHeight(insets) = detent, let insets {
            return insets
        }

        return .init(
            top: .s8,
            leading: .defaultSpacing,
            bottom: isPopup ? .defaultSpacing : 0,
            trailing: .defaultSpacing
        )
    }

    private var preferredWidth: CGFloat? {
        isPopup ? AppConstants.preferredMaxWidth : nil
    }

    /// On iPad, the bottom sheet is displayed as a popup.
    private var isPopup: Bool {
        sizeClass == .regular
    }
}

// MARK: - Preview

#Preview {
    @Previewable @State var showConfirmation = false

    Button.delete {
        showConfirmation = true
    }
    .sheet(isPresented: $showConfirmation) {
        let L = Samples.Strings.deleteMessageAlert

        StandardBottomSheetContent(L.title, message: L.message) {
            HStack {
                Button.cancel {
                    showConfirmation.toggle()
                }
                .buttonStyle(.secondary)

                Button.delete {
                    showConfirmation.toggle()
                }
                .buttonStyle(.primary)
            }
        }
        .padding(.defaultSpacing)
    }
}
