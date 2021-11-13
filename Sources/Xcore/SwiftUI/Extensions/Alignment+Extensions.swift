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
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .top:
                return .top
            case .bottom:
                return .bottom
            case .topLeading:
                return .topLeading
            case .topTrailing:
                return .topTrailing
            case .bottomLeading:
                return .bottomLeading
            case .bottomTrailing:
                return .bottomTrailing
            case .center:
                return .center
            default:
                return nil
        }
    }
}

// MARK: - TextAlignment

extension TextAlignment {
    /// Returns an alignment position along the horizontal axis.
    public var horizontal: HorizontalAlignment {
        switch self {
            case .leading:
                return .leading
            case .trailing:
                return .trailing
            case .center:
                return .center
        }
    }

    /// Returns an alignment in both axes.
    public var alignment: Alignment {
        .init(horizontal: horizontal, vertical: .center)
    }
}
