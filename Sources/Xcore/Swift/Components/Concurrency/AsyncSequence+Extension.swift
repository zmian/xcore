//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

extension AsyncSequence {
    /// Used to expose an instance of `some AsyncSequence` to the client, rather
    /// than this async sequence’s actual type to preserve abstraction across API
    /// boundaries, such as different modules.
    @available(macOS 15.0, iOS 18.0, watchOS 11.0, tvOS 18.0, visionOS 2.0, *)
    public func eraseToAsyncSequence() -> some AsyncSequence<Element, Failure> {
        self
    }
}
