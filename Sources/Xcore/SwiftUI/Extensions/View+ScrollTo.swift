//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Scans all scroll views contained by the proxy for the first with a child
    /// view with identifier `id`, and then scrolls to that view.
    ///
    /// If `anchor` is `nil`, this method finds the container of the identified
    /// view, and scrolls the minimum amount to make the identified view wholly
    /// visible.
    ///
    /// If `anchor` is non-`nil`, it defines the points in the identified view and
    /// the scroll view to align. For example, setting `anchor` to ``UnitPoint/top``
    /// aligns the top of the identified view to the top of the scroll view.
    /// Similarly, setting `anchor` to ``UnitPoint/bottom`` aligns the bottom of the
    /// identified view to the bottom of the scroll view, and so on.
    ///
    /// - Parameters:
    ///   - id: The identifier of a child view to scroll to.
    ///   - anchor: The alignment behavior of the scroll action.
    public func scrollTo<ID: Hashable>(_ id: Binding<ID>, anchor: UnitPoint = .top) -> some View {
        modifier(ScrollToViewModifier(id: id, anchor: anchor))
    }
}

// MARK: - ViewModifier

private struct ScrollToViewModifier<ID: Hashable>: ViewModifier {
    @Binding fileprivate var id: ID
    fileprivate let anchor: UnitPoint

    func body(content: Content) -> some View {
        ScrollViewReader { proxy in
            content
                .onChange(of: id) { id in
                    withAnimation {
                        proxy.scrollTo(id, anchor: anchor)
                    }
                }
        }
    }
}
