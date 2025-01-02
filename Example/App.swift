//
// Xcore
// Copyright © 2014 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

#warning("TODO: Switch docs to DocC")
#warning("TODO: Add watchOS support")

@main
struct XcoreApp: App {
    init() {
        SwizzleManager.start()
        Theme.start()
    }

    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
