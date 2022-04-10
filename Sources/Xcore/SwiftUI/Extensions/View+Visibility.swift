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
    public func onVisibilityStatusChange(perform action: @escaping (VisibilityStatus) -> Void) -> some View {
        modifier(VisibilityModifier(action: action))
    }
}

// MARK: - Status

public enum VisibilityStatus: String, CustomAnalyticsValueConvertible {
    case unknown
    case visible
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
