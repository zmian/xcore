//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Alignment

extension Alignment {
    /// Returns unit point derived from the built-in alignments; otherwise, nil.
    public var unitPoint: UnitPoint? {
        switch self {
            case .leading: .leading
            case .trailing: .trailing
            case .top: .top
            case .bottom: .bottom
            case .topLeading: .topLeading
            case .topTrailing: .topTrailing
            case .bottomLeading: .bottomLeading
            case .bottomTrailing: .bottomTrailing
            case .center: .center
            default: nil
        }
    }
}

// MARK: - TextAlignment

extension TextAlignment {
    /// Returns an alignment position along the horizontal axis.
    public var horizontal: HorizontalAlignment {
        switch self {
            case .leading: .leading
            case .trailing: .trailing
            case .center: .center
        }
    }

    /// Returns an alignment in both axes.
    public var alignment: Alignment {
        .init(horizontal: horizontal, vertical: .center)
    }
}
