//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A toggle style that displays a leading label and a trailing switch. It
/// automatically replaces the switch with progress view when `isLoading` value
/// is `true`.
public struct LoadingSwitchToggleStyle: ToggleStyle {
    @Environment(\.isLoading) private var isLoading

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            ZStack(alignment: .trailing) {
                ProgressView()
                    .hidden(!isLoading)

                Toggle(isOn: configuration.$isOn) {
                    EmptyView()
                }
                .labelsHidden()
                .hidden(isLoading)
            }
        }
        .animation(.default, value: isLoading)
    }
}

// MARK: - Dot Syntax Support

extension ToggleStyle where Self == LoadingSwitchToggleStyle {
    /// A toggle style that displays a leading label and a trailing switch. It
    /// automatically replaces the switch with progress view when `isLoading` value
    /// is `true`.
    public static var loadingSwitch: Self { .init() }
}

#if DEBUG

// MARK: - Preview

#Preview {
    TogglePreview()
}

private struct TogglePreview: View {
    @State private var isLoading = false

    var body: some View {
        List {
            Toggle("Show Loading", isOn: $isLoading)
                .toggleStyle(.loadingSwitch)
                .isLoading(isLoading)
        }
        .onChange(of: isLoading) { _, _ in
            if isLoading {
                withDelay(.seconds(1)) { @MainActor in
                    isLoading = false
                }
            }
        }
    }
}
#endif
