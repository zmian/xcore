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
    public func alignment(vertical alignment: VerticalAlignment) -> some View {
        modifier(AlignmentViewModifier(.left(alignment)))
    }

    /// A View modifier that wraps the content in an `HStack` and aligns the content
    /// based on given alignment.
    public func alignment(horizontal alignment: HorizontalAlignment) -> some View {
        modifier(AlignmentViewModifier(.right(alignment)))
    }
}

// MARK: - Alignment

/// A View modifier that wraps the content in a `VStack` or `HStack` and aligns
/// the content based on given alignment.
private struct AlignmentViewModifier: ViewModifier {
    private let alignment: Either<VerticalAlignment, HorizontalAlignment>

    init(_ alignment: Either<VerticalAlignment, HorizontalAlignment>) {
        self.alignment = alignment
    }

    func body(content: Content) -> some View {
        layout {
            switch alignment {
                case .left(.top), .right(.leading):
                    content
                    Spacer(minLength: 0)
                case .left(.bottom), .right(.trailing):
                    Spacer(minLength: 0)
                    content
                case .left(.center), .right(.center):
                    Spacer(minLength: 0)
                    content
                    Spacer(minLength: 0)
                default:
                    content
            }
        }
    }

    private var layout: AnyLayout {
        switch alignment {
            case .left: AnyLayout(VStackLayout(spacing: 0))
            case .right: AnyLayout(HStackLayout(spacing: 0))
        }
    }
}

// MARK: - Preview

#Preview {
    List {
        Section("Horizontal Alignment") {
            VStack {
                Label("Swift", systemImage: .swift)
                    .border(.rect, color: .accentColor)
                    .alignment(horizontal: .leading)

                Label("Swift", systemImage: .swift)
                    .border(.rect, color: .accentColor)
                    .alignment(horizontal: .center)

                Label("Swift", systemImage: .swift)
                    .border(.rect, color: .accentColor)
                    .alignment(horizontal: .trailing)
            }
        }

        Section("Vertical Alignment") {
            VStack {
                Label("Swift", systemImage: .swift)
                    .border(.rect, color: .accentColor)
                    .alignment(vertical: .top)
            }
            .frame(height: 100)

            VStack {
                Label("Swift", systemImage: .swift)
                    .border(.rect, color: .accentColor)
                    .alignment(vertical: .center)
            }
            .frame(height: 100)

            VStack {
                Label("Swift", systemImage: .swift)
                    .border(.rect, color: .accentColor)
                    .alignment(vertical: .bottom)
            }
            .frame(height: 100)
        }
    }
}
