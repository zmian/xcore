//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import Combine

extension AsyncStream where Element: Sendable {
    /// Returns a publisher that emits events when asynchronous sequence produces
    /// new elements.
    public var publisher: some Publisher<Element, Never> {
        let box = Box()

        Task {
            for await value in self {
                box.subject.send(value)
            }
        }

        return box.subject
    }

    private final class Box: @unchecked Sendable {
        let subject = PassthroughSubject<Element, Never>()
    }
}
#endif
