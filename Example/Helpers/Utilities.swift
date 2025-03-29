//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import ComposableArchitecture

extension AsyncSequence where Self: Sendable, Failure == Never {
    /// Transforms each element of this asynchronous sequence by applying the given
    /// closure, and returns an effect that emits the transformed values.
    ///
    /// This method iterates over the asynchronous sequence, applies the provided
    /// transform to each element, and asynchronously sends the resulting value to
    /// an effect.
    ///
    /// - Parameter transform: A closure that accepts an element of this sequence as
    ///   its argument and returns a transformed value.
    /// - Returns: An `Effect` that emits each transformed value produced from the
    ///   asynchronous sequence.
    func map<T: Sendable>(_ transform: @escaping @Sendable (Element) -> T) -> Effect<T> {
        .run { send in
            for await element in self {
                await send(transform(element))
            }
        }
    }
}
