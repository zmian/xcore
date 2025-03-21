//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension EnvironmentValues {
    /// The safe area insets of the current device.
    ///
    /// Use this environment value to access the safe area insets for the current
    /// view hierarchy. This can be useful for layout adjustments based on the
    /// actual device insets.
    ///
    /// To enable this environment value, apply the `withDeviceSafeAreaInsets()`
    /// view modifier at the app's root view.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// // 1. Integrate into your app
    /// @main
    /// struct MyApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .withDeviceSafeAreaInsets() // 👈 Apply the modifier here
    ///         }
    ///     }
    /// }
    ///
    /// // 2. Example component using the environment value
    /// struct ContentView: View {
    ///     @Environment(\.deviceSafeAreaInsets) private var safeAreaInsets
    ///
    ///     var body: some View {
    ///         Text("Top inset: \(safeAreaInsets.top)")
    ///     }
    /// }
    /// ```
    @Entry public var deviceSafeAreaInsets = EdgeInsets()
}

// MARK: - View Modifier

extension View {
    /// Enables access to the device's safe area insets via the
    /// `deviceSafeAreaInsets` environment value.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// // 1. Integrate into your app
    /// @main
    /// struct MyApp: App {
    ///     var body: some Scene {
    ///         WindowGroup {
    ///             ContentView()
    ///                 .withDeviceSafeAreaInsets() // 👈 Apply the modifier here
    ///         }
    ///     }
    /// }
    ///
    /// // 2. Example component using the environment value
    /// struct ContentView: View {
    ///     @Environment(\.deviceSafeAreaInsets) private var safeAreaInsets
    ///
    ///     var body: some View {
    ///         Text("Top inset: \(safeAreaInsets.top)")
    ///     }
    /// }
    /// ```
    ///
    /// - Returns: A view that provides safe area insets via environment.
    public func withDeviceSafeAreaInsets() -> some View {
        modifier(DeviceSafeAreaProviderModifier())
    }
}

// MARK: - ViewModifier

private struct DeviceSafeAreaProviderModifier: ViewModifier {
    /// A view modifier that enables access to the `deviceSafeAreaInsets`
    /// environment value.
    ///
    /// This modifier uses `GeometryReader` to obtain the current view's safe area
    /// insets and sets them into the `deviceSafeAreaInsets` environment value.
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            content
                .environment(\.deviceSafeAreaInsets, geometry.safeAreaInsets)
        }
    }
}
