//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// Forwards scene URL events, including URLs delivered when a scene connects.
///
/// Set this class (or a subclass) as the delegate class in your scene
/// configuration. Assign `send` to your app phase client's send closure.
/// SwiftUI apps can instead forward URLs with `View.onOpenURL(perform:)`.
@MainActor
open class PhaseForwarderSceneDelegate: NSObject, UIWindowSceneDelegate {
    /// Receives URL events for this scene.
    public var send: (AppPhase) -> Void = { _ in }

    open func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        forward(connectionOptions.urlContexts)
    }

    open func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        forward(URLContexts)
    }

    private func forward(_ contexts: Set<UIOpenURLContext>) {
        for context in contexts {
            send(.openURL(context.url, options: context.options))
        }
    }
}
