//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

/// A structure representing an asynchronous transformation of an input to an
/// output.
///
/// `AsyncTransformer` encapsulates an async transformation, allowing input values
/// to be asynchronously processed into output values. This can be useful for
/// handling operations such as network requests, async computations, or data
/// processing.
///
/// **Usage**
///
/// ```swift
/// let stringToInt = AsyncTransformer<String, Int> { input in
///     try? await Task.sleep(for: .seconds(1)) // Simulating async work
///     return Int(input) ?? 0
/// }
///
/// let result = await stringToInt("42")
/// print(result) // 42
/// ```
@frozen
public struct AsyncTransformer<Input, Output>: Sendable {
    private let transform: @Sendable (Input) async -> Output

    /// Creates a asynchronous transformer that applies a function to transform
    /// input into output.
    ///
    /// - Parameter transform: An async closure that transforms an input into an
    ///   output.
    public init(_ transform: @escaping @Sendable (Input) async -> Output) {
        self.transform = transform
    }

    /// Asynchronously transforms the given input value into an output value.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let uppercased = AsyncTransformer<String, String> { $0.uppercased() }
    /// let result = await uppercased("hello")
    /// print(result) // "HELLO"
    /// ```
    ///
    /// - Parameter value: The input to transform.
    /// - Returns: The asynchronously transformed output.
    public func callAsFunction(_ value: Input) async -> Output {
        await transform(value)
    }
}

// MARK: - Passthrough

extension AsyncTransformer where Input == Output {
    /// A transformer that returns the input as output without modification.
    ///
    /// This is useful for providing a default or identity transformation.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let passthrough = AsyncTransformer<String, String>.passthrough
    /// let result = await passthrough("No Change")
    /// print(result) // "No Change"
    /// ```
    public static var passthrough: Self {
        .init { $0 }
    }
}

// MARK: - Map

extension AsyncTransformer {
    /// Returns a new transformer that applies another transformation to the output.
    ///
    /// This allows composing multiple transformations together.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// let stringToInt = AsyncTransformer<String, Int> { Int($0) ?? 0 }
    /// let intToDouble = AsyncTransformer<Int, Double> { Double($0) * 1.5 }
    /// let combined = stringToInt.map(intToDouble)
    ///
    /// let result = await combined("10")
    /// print(result) // 15.0
    /// ```
    ///
    /// - Parameter other: A transformer that takes the output of `self` as input
    ///   and transforms it into a new value.
    /// - Returns: A new `AsyncTransformer` applying both transformations
    ///   sequentially.
    public func map<NewOutput>(
        _ other: AsyncTransformer<Output, NewOutput>
    ) -> AsyncTransformer<Input, NewOutput> {
        .init { await other(self($0)) }
    }
}
