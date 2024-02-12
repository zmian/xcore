//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

/// A structure representing transformation of an input to an output.
@frozen
public struct AsyncTransformer<Input, Output>: Sendable {
    private let transform: @Sendable (Input) async -> Output

    /// An initializer to transform given input.
    ///
    /// - Parameter transform: A block to transform the input to an output.
    public init(_ transform: @escaping @Sendable (Input) async -> Output) {
        self.transform = transform
    }

    /// Transforms the input to an output.
    ///
    /// - Parameter value: The input to transform.
    /// - Returns: The transformed input.
    public func callAsFunction(_ value: Input) async -> Output {
        await transform(value)
    }
}

// MARK: - Passthrough

extension AsyncTransformer where Input == Output {
    /// Returns the input as output without any transformation.
    public static var passthrough: Self {
        .init { $0 }
    }
}

// MARK: - Map

extension AsyncTransformer {
    /// Returns a new transformer, mapping output value using the given transformer.
    ///
    /// - Parameter other: A transformer that takes the output of `self` as an input
    ///   and transforms it to a new value.
    /// - Returns: A new transformer with the transformation of the output.
    public func map<NewOutput>(
        _ other: AsyncTransformer<Output, NewOutput>
    ) -> AsyncTransformer<Input, NewOutput> {
        .init { await other(self($0)) }
    }
}
