//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Presents a window when a binding to a Boolean value that you provide is
    /// `true`.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// @main
    /// struct MyApp: App {
    ///     @State private var isPresented = false
    ///
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .overlayScreen(isPresented: $isPresented) {
    ///                     Color.black
    ///                 }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter content: The overlay screen content view.
    public func overlayScreen(
        isPresented: Binding<Bool>,
        style: WindowStyle = .init(),
        @ViewBuilder content: @escaping () -> some View
    ) -> some View {
        modifier(OverlayScreenViewModifier(isPresented: isPresented, style: style, screen: content))
    }

    /// Presents a window using the binding you provide as a data source for the
    /// window's content.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// @main
    /// struct MyApp: App {
    ///     @State private var string: String?
    ///
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .overlayScreen(item: $string) { string in
    ///                     Text(string)
    ///                 }
    ///         }
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter content: The overlay screen content view.
    public func overlayScreen<Item: Hashable>(
        item: Binding<Item?>,
        style: WindowStyle = .init(),
        @ViewBuilder content: @escaping (Item) -> some View
    ) -> some View {
        overlayScreen(
            isPresented: item.isPresented,
            style: style,
            content: {
                if let item = item.wrappedValue {
                    content(item)
                }
            }
        )
    }
}

// MARK: - ViewModifier

private struct OverlayScreenViewModifier<Screen: View>: ViewModifier {
    @Binding private var isPresented: Bool
    private let style: WindowStyle
    private let screen: () -> Screen

    init(
        isPresented: Binding<Bool>,
        style: WindowStyle,
        @ViewBuilder screen: @escaping () -> Screen
    ) {
        self._isPresented = isPresented
        self.style = style
        self.screen = screen
    }

    func body(content: Content) -> some View {
        content
            .window(isPresented: $isPresented, style: style) {
                ZStack {
                    if isPresented {
                        screen()
                            .transition(.opacity)
                    }
                }
                .animation(.easeInOut, value: isPresented)
            }
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}

struct ContentView: View {
    @State private var isPresented = true

    var body: some View {
        Color.red
            .ignoresSafeArea()
            .overlay {
                Button("Show Overlay Screen") {
                    isPresented = true
                }
                .buttonStyle(.borderedProminent)
            }
            .overlayScreen(isPresented: $isPresented) {
                Color.yellow
                    .ignoresSafeArea()
                    .overlay {
                        Button("Hide Overlay Screen") {
                            isPresented = false
                        }
                        .buttonStyle(.bordered)
                    }
            }
    }
}
