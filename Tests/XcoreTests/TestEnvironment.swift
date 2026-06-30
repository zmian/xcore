//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

enum TestEnvironment {
    static var isCI: Bool {
        #if XCORE_CI
        true
        #else
        let environment = ProcessInfo.processInfo.environment
        return environment["CI"] == "true" || environment["XCORE_CI"] == "true"
        #endif
    }
}
