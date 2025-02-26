//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct ConfirmOperationStatusTests {
    @Test
    func booleanProperties() {
        var status = ConfirmOperationStatus<String, Int, Error>.idle
        #expect(status.isIdle)
        #expect(!status.isWaitingConfirmation)
        #expect(!status.isLoading)
        #expect(!status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .waitingConfirmation("Hello")
        #expect(!status.isIdle)
        #expect(status.isWaitingConfirmation)
        #expect(!status.isLoading)
        #expect(!status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .loading
        #expect(!status.isIdle)
        #expect(!status.isWaitingConfirmation)
        #expect(status.isLoading)
        #expect(!status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .success(10)
        #expect(!status.isIdle)
        #expect(!status.isWaitingConfirmation)
        #expect(!status.isLoading)
        #expect(status.isSuccess)
        #expect(!status.isFailure)
        #expect(!status.isCancelled)

        status = .failure(AppError.general)
        #expect(!status.isIdle)
        #expect(!status.isWaitingConfirmation)
        #expect(!status.isLoading)
        #expect(!status.isSuccess)
        #expect(status.isFailure)
        #expect(!status.isCancelled)

        status = .failure(CancellationError())
        #expect(!status.isIdle)
        #expect(!status.isWaitingConfirmation)
        #expect(!status.isLoading)
        #expect(!status.isSuccess)
        #expect(status.isFailure)
        #expect(status.isCancelled)
    }

    @Test
    func associatedValues() {
        var status = ConfirmOperationStatus<String, Int, AppError>.idle
        #expect(status.item == nil)
        #expect(status.value == nil)
        #expect(status.error == nil)
        #expect(status.result == nil)

        status = .loading("Hello")
        #expect(status.item == "Hello")
        #expect(status.value == nil)
        #expect(status.error == nil)
        #expect(status.result == nil)

        status = .waitingConfirmation("Hello")
        #expect(status.item == "Hello")
        #expect(status.value == nil)
        #expect(status.error == nil)
        #expect(status.result == nil)

        status = .success(10)
        #expect(status.item == nil)
        #expect(status.value == 10)
        #expect(status.error == nil)
        #expect(status.result == .success(10))

        status = .failure(.general)
        #expect(status.item == nil)
        #expect(status.value == nil)
        #expect(status.error == AppError.general)
        #expect(status.result == .failure(.general))
    }

    @Test
    func initWithResult() {
        let resultSuccess: Result<String, AppError> = .success("Data")
        let statusSuccess = ConfirmOperationStatus<Empty, String, AppError>(resultSuccess)
        #expect(statusSuccess == .success("Data"))

        let resultFailure: Result<String, AppError> = .failure(.general)
        let statusFailure = ConfirmOperationStatus<Empty, String, AppError>(resultFailure)
        #expect(statusFailure == .failure(.general))
    }
}
