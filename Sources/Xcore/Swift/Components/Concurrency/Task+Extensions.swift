//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
extension Task<Never, Never> {
    /// Suspends the current task for at least the given duration in seconds.
    ///
    /// If the task is canceled before the time ends, this function throws
    /// `CancellationError`.
    ///
    /// This function doesn't block the underlying thread.
    public static func sleep(seconds duration: TimeInterval) async throws {
        try await sleep(nanoseconds: UInt64(TimeInterval(NSEC_PER_SEC) * duration))
    }
}
