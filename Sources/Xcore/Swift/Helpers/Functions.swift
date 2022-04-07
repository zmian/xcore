//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A method that invokes `work` when app is not running in testing mode.
@inline(__always)
public func whenNotRunningTests(_ work: () -> Void) {
    #if DEBUG
    if !ProcessInfo.Arguments.isTesting {
        return work()
    }
    #else
    return work()
    #endif
}

/// A method that invokes `work` when app is running in debug mode.
@inline(__always)
public func ifDebug(_ work: () -> Void) {
    #if DEBUG
    work()
    #endif
}
