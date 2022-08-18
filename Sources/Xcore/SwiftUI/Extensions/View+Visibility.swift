//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

extension View {
    /// Adds an action to perform when main window visibility status changes.
    ///
    /// - Note: It fires `.obstructed` event when `self` disappears as well.
    ///
    /// - Parameter action: The action to perform when visibility status changes.
    /// - Returns: A view that triggers action when this view's visibility status
    ///   changes.
    public func onVisibilityStatusChange(perform action: @escaping (VisibilityStatus) -> Void) -> some View {
        modifier(VisibilityModifier(action: action))
    }
}

// MARK: - Status

/// An enumeration representing the visibility status.
public enum VisibilityStatus: String, CustomAnalyticsValueConvertible {
    /// The element visibility is unknown.
    case unknown

    /// The element may be visible.
    case visible

    /// The element may be obstructed by another UI element (e.g., popup).
    case obstructed
}

// MARK: - ViewModifier

private struct VisibilityModifier: ViewModifier {
    @State private var status: VisibilityStatus = .unknown
    private let action: (VisibilityStatus) -> Void

    init(action: @escaping (VisibilityStatus) -> Void) {
        self.action = action
    }

    public func body(content: Content) -> some View {
        content
            .onAppear {
                updateStatusIfNeeded()
            }
            .onDisappear {
                status = .obstructed
            }
            .onChange(of: status) { newValue in
                action(newValue)
            }
            .onReceive(Publishers.windowVisibility) {
                updateStatusIfNeeded()
            }
    }

    private var appWindow: UIWindow? {
        UIApplication.sharedOrNil?.firstWindowScene?.windows.first
    }

    private func updateStatusIfNeeded() {
        DispatchQueue.main.async {
            guard let visibleWindow = UIApplication.sharedOrNil?.window(\.isVisible, \.isKeyWindow) else {
                status = .unknown
                return
            }

            status = visibleWindow != appWindow ? .obstructed : .visible
        }
    }
}
