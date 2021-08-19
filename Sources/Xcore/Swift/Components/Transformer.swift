//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A structure representing transformation of an input to output.
@frozen
public struct Transformer<Input, Output> {
    private let transform: (Input) -> Output

    /// An initializer to transform given input.
    ///
    /// - Parameter transform: A block to transform the input to output.
    public init(_ transform: @escaping (Input) -> Output) {
        self.transform = transform
    }

    public func callAsFunction(_ value: Input) -> Output {
        transform(value)
    }
}

// MARK: - Passthrough

extension Transformer where Input == Output {
    /// Returns input as output without any transformation.
    public static var passthrough: Self {
        .init { $0 }
    }
}

// MARK: - Map

extension Transformer {
    public func map<NewOutput>(_ other: Transformer<Output, NewOutput>) -> Transformer<Input, NewOutput> {
        .init { other(self($0)) }
    }
}
