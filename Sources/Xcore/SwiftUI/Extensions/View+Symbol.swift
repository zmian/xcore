//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - View Extension

extension View {
    /// A View modifier that wraps the content in an `HStack` and places the given
    /// symbol to either left or right of the content.
    public func symbol(
        _ assetIdentifier: SystemAssetIdentifier,
        alignment: VerticalAlignment = .center,
        edge: SymbolPlacementEdge = .trailing,
        spacing: CGFloat? = nil,
        scale: Image.Scale = .small
    ) -> some View {
        modifier(SymbolViewModifier(
            assetIdentifier: assetIdentifier,
            alignment: alignment,
            edge: edge,
            spacing: spacing,
            scale: scale
        ))
    }
}

// MARK: - SymbolPlacementEdge

public enum SymbolPlacementEdge {
    case none
    case leading
    case trailing
}

// MARK: - ViewModifier

/// A View modifier that wraps the content in an `HStack` and places the given
/// symbol to either left or right of the content.
private struct SymbolViewModifier: ViewModifier {
    @Environment(\.theme) private var theme
    private let assetIdentifier: SystemAssetIdentifier
    private var alignment: VerticalAlignment
    private let edge: SymbolPlacementEdge
    private let spacing: CGFloat?
    private let scale: Image.Scale

    init(
        assetIdentifier: SystemAssetIdentifier,
        alignment: VerticalAlignment,
        edge: SymbolPlacementEdge,
        spacing: CGFloat?,
        scale: Image.Scale
    ) {
        self.assetIdentifier = assetIdentifier
        self.alignment = alignment
        self.edge = edge
        self.spacing = spacing
        self.scale = scale
    }

    func body(content: Content) -> some View {
        switch edge {
            case .none:
                content
            case .leading, .trailing:
                HStack(alignment: alignment, spacing: spacing) {
                    if edge == .leading {
                        image
                    }

                    content

                    if edge == .trailing {
                        image
                    }
                }
        }
    }

    private var image: some View {
        Image(system: assetIdentifier)
            .imageScale(scale)
            .accessibilityHidden(true)
            .foregroundColor(theme.separatorColor)
    }
}
