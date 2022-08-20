//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension CheckboxToggleStyle {
    @available(iOS, introduced: 14, deprecated: 15, message: "Use HorizontalEdge directly.")
    public enum HorizontalEdge {
        case leading
        case trailing
    }
}

/// A toggle style that displays a checkbox and its label based on the given
/// horizontal edge.
public struct CheckboxToggleStyle: ToggleStyle {
    private let edge: HorizontalEdge

    init(edge: HorizontalEdge) {
        self.edge = edge
    }

    public func makeBody(configuration: Self.Configuration) -> some View {
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

    private func toggle(_ configuration: Self.Configuration) -> some View {
        EnvironmentReader(\.theme) { theme in
            Image(system: configuration.isOn ? .checkmarkCircleFill : .circle)
                .resizable()
                .frame(24)
                .foregroundColor(
                    configuration.isOn ? theme.toggleColor : theme.separatorColor
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}

// MARK: - Dot Syntax Support

extension ToggleStyle where Self == CheckboxToggleStyle {
    /// A toggle style that displays a checkbox and its label based on the given
    /// horizontal edge.
    public static func checkbox(edge: Self.HorizontalEdge) -> Self {
        .init(edge: edge)
    }
}
