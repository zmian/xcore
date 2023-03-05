//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//
// swiftlint:disable icc_test_case_superclass

#if canImport(Combine)
import XCTest
import Combine

@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
extension XCTestCase {
    /// - SeeAlso: https://www.swiftbysundell.com/articles/unit-testing-combine-based-swift-code
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line,
        fulfillOnValue: Bool = false
    ) throws -> T.Output {
        // This time, we use Swift's Result type to keep track
        // of the result of our Combine pipeline:
        var result: Result<T.Output, Error>?
        let expectation = self.expectation(description: "Awaiting publisher")

        let cancellable = publisher.sink(
            receiveCompletion: { completion in
                switch completion {
                    case let .failure(error):
                        result = .failure(error)
                    case .finished:
                        break
                }

                expectation.fulfill()
            },
            receiveValue: { value in
                result = .success(value)
                if fulfillOnValue {
                    expectation.fulfill()
                }
            }
        )

        // Just like before, we await the expectation that we
        // created at the top of our test, and once done, we
        // also cancel our cancellable to avoid getting any
        // unused variable warnings:
        waitForExpectations(timeout: timeout)
        cancellable.cancel()

        // Here we pass the original file and line number that
        // our utility was called at, to tell XCTest to report
        // any encountered errors at that original call site:
        let unwrappedResult = try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        )

        return try unwrappedResult.get()
    }
}
#endif
