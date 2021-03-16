//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@main
struct XcoreApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}

// MARK: - Delegate

private final class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UIApplication.swizzle()
        Theme.start()
        return true
    }
}
