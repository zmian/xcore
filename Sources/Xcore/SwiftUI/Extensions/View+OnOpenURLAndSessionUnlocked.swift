//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

extension View {
    /// Registers a handler to invoke when the view receives a url for the scene or
    /// window the view is in and when the session is unlocked.
    ///
    /// Internally it observes session state and only invokes the provided action
    /// when session is unlocked.
    ///
    /// - Note: This method handles the reception of Universal Links, rather than a
    ///   ``NSUserActivity``.
    ///
    /// - Parameter action: A function that takes a URL object as its parameter when
    ///   delivering the URL to the scene or window the view is in and when the
    ///   session is unlocked.
    public func onOpenURLAndSessionUnlocked(perform action: @escaping (URL) -> Void) -> some View {
        modifier(OnOpenURLSessionUnlockedViewModifier(perform: action))
    }
}

// MARK: - ViewModifier

private struct OnOpenURLSessionUnlockedViewModifier: ViewModifier {
    @Dependency(\.appStatus) private var appStatus
    @State private var isUnlocked: Bool
    @State private var pendingOpenUrl: URL?
    private let action: (URL) -> Void

    init(perform action: @escaping (URL) -> Void) {
        let state = Dependency(\.appStatus).wrappedValue.sessionState.value
        _isUnlocked = .init(initialValue: state == .unlocked)
        self.action = action
    }

    func body(content: Content) -> some View {
        content
            .onReceive(appStatus.sessionState) { sessionState in
                isUnlocked = sessionState == .unlocked

                // Process the pending url
                if isUnlocked, let url = pendingOpenUrl {
                    pendingOpenUrl = nil
                    action(url)
                }
            }
            .onOpenURL { url in
                // If session is already unlocked then process the url right away.
                if isUnlocked {
                    action(url)
                } else {
                    pendingOpenUrl = url
                }
            }
    }
}
