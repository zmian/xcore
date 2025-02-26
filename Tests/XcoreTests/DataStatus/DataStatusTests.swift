//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct DataStatusTests {
    @Test
    func isFailureOrEmpty() {
        var status = DataStatus<[String], AppError>.idle
        #expect(status.isFailureOrEmpty == false)

        status = .loading
        #expect(status.isFailureOrEmpty == false)

        // True, collection is empty
        status = .failure(.general)
        #expect(status.isFailureOrEmpty == true)

        // False, collection is empty
        status = .success(["Hello"])
        #expect(status.isFailureOrEmpty == false)

        // True, collection is empty
        status = .success([])
        #expect(status.isFailureOrEmpty == true)
    }

    @Test
    func booleanProperties() {
        var status = DataStatus<[String], Error>.idle
        #expect(status.isIdle)
        #expect(!status.isLoading)
        #expect(!status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .loading
        #expect(!status.isIdle)
        #expect(status.isLoading)
        #expect(!status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .success([])
        #expect(!status.isIdle)
        #expect(!status.isLoading)
        #expect(status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .failure(AppError.general)
        #expect(!status.isIdle)
        #expect(!status.isLoading)
        #expect(!status.isSuccess)
        #expect(status.isFailure)
        #expect(!status.isCancelled)

        status = .failure(CancellationError())
        #expect(!status.isIdle)
        #expect(!status.isLoading)
        #expect(!status.isSuccess)
        #expect(status.isFailure)
        #expect(status.isCancelled)
    }

    @Test
    func associatedValues() {
        var status = DataStatus<[String], AppError>.idle
        #expect(status.value == nil)
        #expect(status.error == nil)
        #expect(status.result == nil)

        status = .loading
        #expect(status.value == nil)
        #expect(status.error == nil)
        #expect(status.result == nil)

        status = .success(["Hello"])
        #expect(status.value == ["Hello"])
        #expect(status.error == nil)
        #expect(status.result == .success(["Hello"]))

        status = .failure(.general)
        #expect(status.value == nil)
        #expect(status.error == AppError.general)
        #expect(status.result == .failure(.general))
    }

    @Test
    func initWithResult() {
        let resultSuccess: Result<String, AppError> = .success("Data")
        let statusSuccess = DataStatus(resultSuccess)
        #expect(statusSuccess == .success("Data"))

        let resultFailure: Result<String, AppError> = .failure(.general)
        let statusFailure = DataStatus(resultFailure)
        #expect(statusFailure == .failure(.general))
    }

    @Test
    func map() {
        func getNextInteger() -> DataStatus<Int, AppError> { .success(5) }
        let integerStatus = getNextInteger()
        #expect(integerStatus == .success(5))

        let stringStatus = integerStatus.map { String($0) }
        #expect(stringStatus == .success("5"))
    }

    @Test
    func flatMap() {
        func getNextInteger() -> DataStatus<Int, AppError> {
            .success(4)
        }

        func getNextAfterInteger(_ n: Int) -> DataStatus<Int, AppError> {
            .success(n + 1)
        }

        let result1 = getNextInteger().map { getNextAfterInteger($0) }
        #expect(result1 == .success(.success(5)))

        let result2 = getNextInteger().flatMap { getNextAfterInteger($0) }
        #expect(result2 == .success(5))
    }

    @Test
    func mapError() {
        struct DatedError: Error, Hashable {
            var error: AppError
            var date: Date
        }

        let result: DataStatus<Int, AppError> = .failure(.general)
        #expect(result == .failure(.general))

        let now = Date()
        let resultWithDatedError = result.mapError { DatedError(error: $0, date: now) }
        #expect(resultWithDatedError == .failure(DatedError(error: .general, date: now)))
    }

    @Test
    func flatMapError() {
        struct DatedError: Error, Hashable {
            var error: AppError
            var date: Date
        }

        let result: DataStatus<Int, AppError> = .failure(.general)
        #expect(result == .failure(.general))

        let now = Date()
        let resultWithDatedError = result.flatMapError { .failure(DatedError(error: $0, date: now)) }
        #expect(resultWithDatedError == .failure(DatedError(error: .general, date: now)))
    }
}
