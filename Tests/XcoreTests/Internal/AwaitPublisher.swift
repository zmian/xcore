//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

#if canImport(Combine)
import Testing
import Combine

/// - SeeAlso: https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code
func awaitPublisher<T: Publisher>(
    _ publisher: T,
    sourceLocation: SourceLocation = #_sourceLocation,
    fulfillOnValue: Bool = false
) async throws -> T.Output where T.Output: Sendable {
    try await confirmation("Awaiting publisher") { signalCompletion in
        var result: Result<T.Output, Error>?

        var cancellable: AnyCancellable?

        cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case let .failure(error):
                        result = .failure(error)
                    case .finished:
                        break
                }

                signalCompletion()
                cancellable?.cancel()
                cancellable = nil
            },
            receiveValue: { value in
                result = .success(value)
                if fulfillOnValue {
                    signalCompletion()
                    cancellable?.cancel()
                    cancellable = nil
                }
            }
        )

        let unwrappedResult = try #require(
            result,
            "Awaited publisher did not produce any output",
            sourceLocation: sourceLocation
        )

        return try unwrappedResult.get()
    }
}
#endif
