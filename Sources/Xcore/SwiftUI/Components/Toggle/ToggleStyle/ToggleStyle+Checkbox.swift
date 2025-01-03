//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

/// A toggle style that displays a checkbox and its label based on the given
/// horizontal edge.
public struct CheckboxToggleStyle: ToggleStyle {
    @Environment(\.theme) private var theme
    private let edge: HorizontalEdge

    nonisolated init(edge: HorizontalEdge) {
        self.edge = edge
    }

    public func makeBody(configuration: Configuration) -> some View {
        HStack {
            switch edge {
                case .leading:
                    toggle(configuration)
                    Spacer(width: .s4)
                    configuration.label
                    Spacer()
                case .trailing:
                    configuration.label
                    Spacer()
                    toggle(configuration)
            }
        }
    }

    private func toggle(_ configuration: Configuration) -> some View {
        Image(system: configuration.isOn ? .checkmarkCircleFill : .circle)
            .resizable()
            .frame(24)
            .foregroundStyle(
                configuration.isOn ? theme.toggleColor : theme.separatorColor
            )
            .onTapGesture {
                configuration.isOn.toggle()
            }
    }
}

// MARK: - Dot Syntax Support

extension ToggleStyle where Self == CheckboxToggleStyle {
    /// A toggle style that displays a checkbox and its label based on the given
    /// horizontal edge.
    nonisolated public static func checkbox(edge: HorizontalEdge) -> Self {
        .init(edge: edge)
    }
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
                .toggleStyle(.checkbox(edge: .leading))
        }
    }
}
#endif
