//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

enum TestEnvironment {
    static var isCI: Bool {
        #if CI
        true
        #else
        ProcessInfo.processInfo.environment["CI"] == "true"
        #endif
    }
}
