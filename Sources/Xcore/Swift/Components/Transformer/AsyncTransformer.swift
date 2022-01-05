//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing transformation of an input to output.
@frozen
public struct AsyncTransformer<Input, Output> {
    private let transform: (Input) async -> Output

    /// An initializer to transform given input.
    ///
    /// - Parameter transform: A block to transform the input to output.
    public init(_ transform: @escaping (Input) async -> Output) {
        self.transform = transform
    }

    public func callAsFunction(_ value: Input) async -> Output {
        await transform(value)
    }
}

// MARK: - Passthrough

extension AsyncTransformer where Input == Output {
    /// Returns input as output without any transformation.
    public static var passthrough: Self {
        .init { $0 }
    }
}

// MARK: - Map

extension AsyncTransformer {
    public func map<NewOutput>(_ other: AsyncTransformer<Output, NewOutput>) -> AsyncTransformer<Input, NewOutput> {
        .init { await other(self($0)) }
    }
}
