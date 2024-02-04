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

public enum AppCustomPresentationDetent {
    case contentHeight(insets: EdgeInsets?)

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
                .readSize {
                    if detentHeight != $0.height {
                        detentHeight = $0.height
                    }
                }
                .presentationDetents([.height(detentHeight)])
                .apply {
                    if #available(iOS 16.4, *) {
                        $0.presentationCornerRadius(cornerRadius)
                            // On iPad adapt the bottom sheet to be a popup.
                            .unwrap(preferredWidth) { view, preferredWidth in
                                view.presentationBackground {
                                    theme.backgroundColor
                                        .frame(maxWidth: preferredWidth, maxHeight: detentHeight)
                                        .clipShape(.rect(cornerRadius: cornerRadius))
                                }
                            }
                    } else {
                        $0
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
