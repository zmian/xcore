//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

/// A structure representing transformation of an input to an output.
@frozen
public struct Transformer<Input, Output>: Sendable {
    private let transform: @Sendable (Input) -> Output

    /// An initializer to transform given input.
    ///
    /// - Parameter transform: A block to transform the input to an output.
    public init(_ transform: @escaping @Sendable (Input) -> Output) {
        self.transform = transform
    }

    /// Transforms the input to an output.
    ///
    /// - Parameter value: The input to transform.
    /// - Returns: The transformed input.
    public func callAsFunction(_ value: Input) -> Output {
        transform(value)
    }
}

// MARK: - Passthrough

extension Transformer where Input == Output {
    /// Returns the input as output without any transformation.
    public static var passthrough: Self {
        .init { $0 }
    }
}

// MARK: - Map

extension Transformer {
    /// Returns a new transformer, mapping output value using the given transformer.
    ///
    /// - Parameter other: A transformer that takes the output of `self` as an input
    ///   and transforms it to a new value.
    /// - Returns: A new transformer with the transformation of the output.
    public func map<NewOutput>(
        _ other: Transformer<Output, NewOutput>
    ) -> Transformer<Input, NewOutput> {
        .init { other(self($0)) }
    }
}
