//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct ReloadableDataStatusTests {
    @Test
    func isEmpty() {
        var status = ReloadableDataStatus<[String], AppError>.idle
        #expect(status.isEmpty == false)

        // False, collection case is not success
        status = .loading
        #expect(status.isEmpty == false)

        // False, collection case is not success
        status = .failure(.general)
        #expect(status.isEmpty == false)

        // False, collection is not empty
        status = .success(["Hello"])
        #expect(status.isEmpty == false)

        // True, collection is empty
        status = .success([])
        #expect(status.isEmpty == true)

        // False, collection is not empty
        status = .reloading(["Hello"])
        #expect(status.isEmpty == false)

        // True, collection is empty
        status = .reloading([])
        #expect(status.isEmpty == true)

        // String
        var stringStatus = ReloadableDataStatus<String, AppError>.idle

        // False, string is not empty
        stringStatus = .success("Hello")
        #expect(stringStatus.isEmpty == false)

        // True, string is empty
        stringStatus = .success("")
        #expect(stringStatus.isEmpty == true)

        // False, string is not empty
        stringStatus = .reloading("Hello")
        #expect(stringStatus.isEmpty == false)

        // True, string is empty
        stringStatus = .reloading("")
        #expect(stringStatus.isEmpty == true)
    }

    @Test
    func isFailureOrEmpty() {
        var status = ReloadableDataStatus<[String], AppError>.idle
        #expect(status.isFailureOrEmpty == false)

        status = .loading
        #expect(status.isFailureOrEmpty == false)

        // True, collection is empty
        status = .failure(.general)
        #expect(status.isFailureOrEmpty == true)

        // False, collection is not empty
        status = .success(["Hello"])
        #expect(status.isFailureOrEmpty == false)

        // True, collection is empty
        status = .success([])
        #expect(status.isFailureOrEmpty == true)

        // True, collection is empty
        status = .reloading([])
        #expect(status.isFailureOrEmpty == true)

        // String
        var stringStatus = ReloadableDataStatus<String, AppError>.idle

        // False, string is not empty
        stringStatus = .success("Hello")
        #expect(stringStatus.isFailureOrEmpty == false)

        // True, string is empty
        stringStatus = .success("")
        #expect(stringStatus.isFailureOrEmpty == true)

        // False, string is not empty
        stringStatus = .reloading("Hello")
        #expect(stringStatus.isFailureOrEmpty == false)

        // True, string is empty
        stringStatus = .reloading("")
        #expect(stringStatus.isFailureOrEmpty == true)
    }

    @Test
    func startLoading() {
        var status = ReloadableDataStatus<String, AppError>.idle

        // idle → loading
        status.startLoading()
        #expect(status == .loading)

        // loading → loading
        status = .loading
        status.startLoading()
        #expect(status == .loading)

        // failure → loading
        status = .failure(.general)
        status.startLoading()
        #expect(status == .loading)

        // success → reloading
        status = .success("Fetched Data")
        status.startLoading()
        #expect(status == .reloading("Fetched Data"))

        // reloading → reloading
        status = .reloading("Fetched Data")
        status.startLoading()
        #expect(status == .reloading("Fetched Data"))

        // Collection Value
        var collectionStatus = ReloadableDataStatus<[String], AppError>.idle

        // Not Empty: success → reloading
        collectionStatus = .success(["Fetched Data"])
        collectionStatus.startLoading()
        #expect(collectionStatus == .reloading(["Fetched Data"]))

        // Not Empty: reloading → reloading
        collectionStatus = .reloading(["Fetched Data"])
        collectionStatus.startLoading()
        #expect(collectionStatus == .reloading(["Fetched Data"]))

        // Empty: success → loading
        collectionStatus = .success([])
        collectionStatus.startLoading()
        #expect(collectionStatus == .loading)

        // Empty: reloading → loading
        collectionStatus = .reloading([])
        collectionStatus.startLoading()
        #expect(collectionStatus == .loading)

        // Empty String Value

        // success → loading
        status = .success("")
        status.startLoading()
        #expect(status == .loading)

        // reloading → loading
        status = .reloading("")
        status.startLoading()
        #expect(status == .loading)
    }

    @Test
    func booleanProperties() {
        var status = ReloadableDataStatus<[String], Error>.idle
        #expect(status.isIdle)
        #expect(!status.isLoading)
        #expect(!status.isReloading)
        #expect(!status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .loading
        #expect(!status.isIdle)
        #expect(status.isLoading)
        #expect(!status.isReloading)
        #expect(!status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .reloading([])
        #expect(!status.isIdle)
        #expect(!status.isLoading)
        #expect(status.isReloading)
        #expect(!status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .success([])
        #expect(!status.isIdle)
        #expect(!status.isLoading)
        #expect(!status.isReloading)
        #expect(status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .failure(AppError.general)
        #expect(!status.isIdle)
        #expect(!status.isLoading)
        #expect(!status.isReloading)
        #expect(!status.isSuccess)
        #expect(status.isFailure)
        #expect(!status.isCancelled)

        status = .failure(CancellationError())
        #expect(!status.isIdle)
        #expect(!status.isLoading)
        #expect(!status.isReloading)
        #expect(!status.isSuccess)
        #expect(status.isFailure)
        #expect(status.isCancelled)
    }

    @Test
    func associatedValues() {
        var status = ReloadableDataStatus<[String], AppError>.idle
        #expect(status.value == nil)
        #expect(status.error == nil)
        #expect(status.result == nil)

        status = .loading
        #expect(status.value == nil)
        #expect(status.error == nil)
        #expect(status.result == nil)

        status = .reloading(["Hello"])
        #expect(status.value == ["Hello"])
        #expect(status.error == nil)
        #expect(status.result == .success(["Hello"]))

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
        let statusSuccess = ReloadableDataStatus(resultSuccess)
        #expect(statusSuccess == .success("Data"))

        let resultFailure: Result<String, AppError> = .failure(.general)
        let statusFailure = ReloadableDataStatus(resultFailure)
        #expect(statusFailure == .failure(.general))
    }

    @Test
    func initWithDataStatus() {
        let dsIdle: DataStatus<String, AppError> = .idle
        let statusIdle = ReloadableDataStatus(dsIdle)
        #expect(statusIdle == .idle)

        let dsLoading: DataStatus<String, AppError> = .loading
        let statusLoading = ReloadableDataStatus(dsLoading)
        #expect(statusLoading == .loading)

        let dsSuccess: DataStatus<String, AppError> = .success("Data")
        let statusSuccess = ReloadableDataStatus(dsSuccess)
        #expect(statusSuccess == .success("Data"))

        let dsFailure: Result<String, AppError> = .failure(.general)
        let statusFailure = ReloadableDataStatus(dsFailure)
        #expect(statusFailure == .failure(.general))
    }

    @Test
    func map() {
        func getNextInteger() -> ReloadableDataStatus<Int, AppError> { .success(5) }
        let integerStatus = getNextInteger()
        #expect(integerStatus == .success(5))

        let stringStatus = integerStatus.map { String($0) }
        #expect(stringStatus == .success("5"))
    }

    @Test
    func flatMap() {
        func getNextInteger() -> ReloadableDataStatus<Int, AppError> {
            .success(4)
        }

        func getNextAfterInteger(_ n: Int) -> ReloadableDataStatus<Int, AppError> {
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

        let result: ReloadableDataStatus<Int, AppError> = .failure(.general)
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

        let result: ReloadableDataStatus<Int, AppError> = .failure(.general)
        #expect(result == .failure(.general))

        let now = Date()
        let resultWithDatedError = result.flatMapError { .failure(DatedError(error: $0, date: now)) }
        #expect(resultWithDatedError == .failure(DatedError(error: .general, date: now)))
    }
}
