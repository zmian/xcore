//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Separator Style

public enum ListRowSeparatorStyle: Equatable, Sendable {
    case hidden
    case line(EdgeInsets)

    public static var line: Self {
        .line(.zero)
    }

    public static var lineInset: Self {
        .line(.listRow)
    }

    var insets: EdgeInsets {
        switch self {
            case .hidden:
                .zero
            case let .line(insets):
                EdgeInsets(
                    top: 0,
                    leading: insets.leading,
                    bottom: 0,
                    trailing: insets.trailing
                )
        }
    }
}

// MARK: - List Row Separator Style Environment

extension EnvironmentValues {
    @Entry public var listRowSeparatorStyle: ListRowSeparatorStyle = .line
}

// MARK: - View Modifiers

extension View {
    /// Applies an inset to the rows separator in a list.
    public func listRowSeparatorInsets(_ insets: CGFloat) -> some View {
        listRowSeparatorStyle(.line(EdgeInsets(insets)))
    }

    /// Applies the given separator style to the rows separator in a list.
    public func listRowSeparatorStyle(_ style: ListRowSeparatorStyle) -> some View {
        environment(\.listRowSeparatorStyle, style)
    }
}
