//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import ComposableArchitecture

extension AsyncStream where Element: Sendable {
    /// Maps an asynchronous unit of work that can emit any number of times in an
    /// effect.
    func map<T: Sendable>(_ transform: @escaping @Sendable (Element) -> T) -> Effect<T> {
        .run { send in
            for await element in self {
                await send(transform(element))
            }
        }
    }
}
