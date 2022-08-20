//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import Foundation
import Combine

extension Scheduler where Self == DispatchQueue {
    /// The dispatch queue associated with the main thread of the current process.
    public static var main: Self {
        DispatchQueue.main
    }
}
#endif
