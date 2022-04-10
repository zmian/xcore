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

/// Prints items in debug mode and only when debugger is attached.
@inline(__always)
public func debugLog(
    _ items: Any...,
    info: String? = nil,
    compact: Bool = false,
    file: StaticString = #fileID,
    line: UInt = #line
) {
    #if DEBUG
    if AppInfo.isDebuggerAttached {
        let info = info.map { " \($0)" } ?? ""
        let firstLine = "[\(file):\(line)]\(info)"

        if compact, items.count == 1 {
            print("\(firstLine) \(items[0])")
        } else {
            print("———")
            print(firstLine)
            let isError = items.contains { ($0 as? Error) != nil }

            if isError {
                dump(items)
            } else if items.count == 1 {
                // Avoid printing array brackets.
                print(items[0])
            } else {
                print(items)
            }

            print("———")
        }
    }
    #endif
}
