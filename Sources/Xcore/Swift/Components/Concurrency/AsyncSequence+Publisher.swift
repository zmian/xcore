//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import Combine

extension AsyncStream {
    /// Returns a publisher that emits events when asynchronous sequence produces
    /// new elements.
    public var publisher: some Publisher<Element, Never> {
        let subject = PassthroughSubject<Element, Never>()

        Task {
            for await value in self {
                subject.send(value)
            }
        }

        return subject
    }
}
#endif
