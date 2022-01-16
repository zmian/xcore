//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

struct PondError: Error, CustomStringConvertible {
    let description: String

    init(_ description: String, file: StaticString = #fileID, line: UInt = #line) {
        self.description = "\(file):\(line) \(description)"
    }
}

extension PondError {
    static func saveFailure(
        id: @autoclosure () -> String,
        value: @autoclosure () -> Any?,
        file: StaticString = #fileID,
        line: UInt = #line
    ) -> Self {
        #if DEBUG
        if AppInfo.isDebuggerAttached {
            fatalError("Unable to save value for \(id()): \(String(describing: value()))")
        }
        #endif

        return self.init("Unexpected error occurred. Unable to save value.", file: file, line: line)
    }
}
