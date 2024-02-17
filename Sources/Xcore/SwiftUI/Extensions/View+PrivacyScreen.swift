//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// The content view is automatically displayed when scene transitions to
    /// non-active state.
    ///
    /// Privacy screen behavior is suitable to be used on any view that displays
    /// private content that should be masked when when scene transition to
    /// non-active state.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// @main
    /// struct MyApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .privacyScreen {
    ///                     Color.black
    ///                 }
    ///         }
    ///     }
    /// }
    /// ```
    /// - Parameter content: The privacy screen content view.
    public func privacyScreen(@ViewBuilder content: @escaping () -> some View) -> some View {
        modifier(PrivacyScreenViewModifier(screen: content))
    }

    /// The content view is automatically displayed when scene transitions to
    /// non-active state.
    ///
    /// Privacy screen behavior is suitable to be used on any view that displays
    /// private content that should be masked when when scene transition to
    /// non-active state.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// @main
    /// struct MyApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .privacyScreen(Color.black)
    ///         }
    ///     }
    /// }
    /// ```
    /// - Parameter content: The privacy screen content view.
    public func privacyScreen(_ content: @autoclosure @escaping () -> some View) -> some View {
        privacyScreen { content() }
    }
}

// MARK: - ViewModifier

private struct PrivacyScreenViewModifier<Screen: View>: ViewModifier {
    @Environment(\.scenePhase) private var scenePhase
    @State private var isPrivacyScreenActive = false
    private let screen: () -> Screen

    init(@ViewBuilder screen: @escaping () -> Screen) {
        self.screen = screen
    }

    func body(content: Content) -> some View {
        content
            .overlayScreen(
                isPresented: $isPrivacyScreenActive,
                style: .privacy,
                content: screen
            )
            .onChange(of: scenePhase) { phase in
                isPrivacyScreenActive = phase != .active
            }
    }
}

// MARK: - Preview

#Preview {
    Color.red
        .ignoresSafeArea()
        .privacyScreen {
            Color.yellow
                .ignoresSafeArea()
        }
}
