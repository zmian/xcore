//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - View Extension

extension View {
    /// A View modifier that wraps the content in an `VStack` and aligns the content
    /// based on given alignment.
    public func vAlign(_ alignment: VerticalAlignment) -> some View {
        modifier(VerticalAlignmentViewModifier(alignment))
    }

    /// A View modifier that wraps the content in an `HStack` and aligns the content
    /// based on given alignment.
    public func hAlign(_ alignment: HorizontalAlignment) -> some View {
        modifier(HorizontalAlignmentViewModifier(alignment))
    }
}

// MARK: - VerticalAlignment

/// A View modifier that wraps the content in an `VStack` and aligns the content
/// based on given alignment.
private struct VerticalAlignmentViewModifier: ViewModifier {
    private let alignment: VerticalAlignment

    init(_ alignment: VerticalAlignment) {
        self.alignment = alignment
    }

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            switch alignment {
                case .top:
                    content
                    Spacer()
                case .bottom:
                    Spacer()
                    content
                case .center:
                    Spacer()
                    content
                    Spacer()
                default:
                    content
            }
        }
    }
}

// MARK: - HorizontalAlignment

/// A View modifier that wraps the content in an `HStack` and aligns the content
/// based on given alignment.
private struct HorizontalAlignmentViewModifier: ViewModifier {
    private let alignment: HorizontalAlignment

    init(_ alignment: HorizontalAlignment) {
        self.alignment = alignment
    }

    func body(content: Content) -> some View {
        HStack(spacing: 0) {
            switch alignment {
                case .leading:
                    content
                    Spacer()
                case .trailing:
                    Spacer()
                    content
                case .center:
                    Spacer()
                    content
                    Spacer()
                default:
                    content
            }
        }
    }
}
