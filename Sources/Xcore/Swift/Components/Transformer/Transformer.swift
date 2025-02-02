//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

/// A structure representing the transformation of an input to an output.
///
/// `Transformer` provides a lightweight, type-safe way to encapsulate
/// transformations. It enables composable operations, making it easy to build
/// reusable processing pipelines.
///
/// **Usage**
///
/// ```swift
/// let intToString = Transformer<Int, String> { "\($0)" }
/// print(intToString(42)) // "42"
///
/// let stringToDouble = Transformer<String, Double> { Double($0) ?? 0.0 }
/// print(stringToDouble("3.14")) // 3.14
///
/// let combined = intToString.map(stringToDouble)
/// print(combined(42)) // 42.0
/// ```
@frozen
public struct Transformer<Input, Output>: Sendable {
    private let transform: @Sendable (Input) -> Output

    /// Creates a transformer that applies a function to transform input into
    /// output.
    ///
    /// - Parameter transform: A closure that transforms an input into an output.
    public init(_ transform: @escaping @Sendable (Input) -> Output) {
        self.transform = transform
    }

    /// Transforms the given input value into an output value.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let uppercased = Transformer<String, String> { $0.uppercased() }
    /// print(uppercased("hello")) // "HELLO"
    /// ```
    ///
    /// - Parameter value: The input to transform.
    /// - Returns: The transformed output.
    public func callAsFunction(_ value: Input) -> Output {
        transform(value)
    }
}

// MARK: - Passthrough

extension Transformer where Input == Output {
    /// A transformer that returns the input as output without modification.
    ///
    /// This is useful for providing a default or identity transformation.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let passthrough = Transformer<String, String>.passthrough
    /// print(passthrough("No Change")) // "No Change"
    /// ```
    public static var passthrough: Self {
        .init { $0 }
    }
}

// MARK: - Map

extension Transformer {
    /// Returns a new transformer that applies another transformation to the output.
    ///
    /// This allows composing multiple transformations together.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let intToString = Transformer<Int, String> { "\($0)" }
    /// let stringToDouble = Transformer<String, Double> { Double($0) ?? 0.0 }
    /// let combined = intToString.map(stringToDouble)
    ///
    /// print(combined(42)) // 42.0
    /// ```
    ///
    /// - Parameter other: A transformer that takes the output of `self` as input
    ///   and transforms it into a new value.
    /// - Returns: A new `Transformer` applying both transformations sequentially.
    public func map<NewOutput>(
        _ other: Transformer<Output, NewOutput>
    ) -> Transformer<Input, NewOutput> {
        .init { other(self($0)) }
    }
}
