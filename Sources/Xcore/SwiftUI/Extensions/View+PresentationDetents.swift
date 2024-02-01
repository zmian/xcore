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
    case contentHeight(padding: CGFloat?)

    public static var contentHeight: Self {
        .contentHeight(padding: nil)
    }
}

private struct PresentationDetentsViewModifier: ViewModifier {
    @State private var detentHeight: CGFloat = 0
    let detent: AppCustomPresentationDetent

    func body(content: Content) -> some View {
        switch detent {
            case let .contentHeight(padding):
                VStack(spacing: 0) {
                    content
                }
                .padding(.horizontal, padding ?? .defaultSpacing)
                .padding(.top, padding ?? .s8)
                .deviceSpecificBottomPadding()
                .fixedSize(horizontal: false, vertical: true)
                .readSize {
                    if detentHeight != $0.height {
                        detentHeight = $0.height
                    }
                }
                .presentationDetents([.height(detentHeight)])
                .apply {
                    if #available(iOS 16.4, *) {
                        $0.presentationCornerRadius(16)
                    } else {
                        $0
                    }
                }
        }
    }
}
