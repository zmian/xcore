//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@main
struct XcoreApp: App {
    init() {
        SwizzleManager.start()
        Theme.start()
        Font.configureDefaultAppTypeface()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
