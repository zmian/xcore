//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Testing
@testable import Xcore

struct ErrorTests {
    @Test
    func appErrorProperties() {
        let appError = AppError.noInternet
        let error: Error = appError

        #expect(appError.id == "no_internet")
        #expect(appError.id == error.id)
        #expect(appError.title == error.title)
        #expect(appError.message == error.message)
        #expect(appError.debugMessage == error.debugMessage)
        #expect(appError.logLevel == error.logLevel)
    }

    @Test
    func localizedErrorProperties() {
        struct MyError: LocalizedError {
            let errorDescription: String? = "Some error description"
            let failureReason: String? = "some failure reason"
        }

        let myError = MyError()
        let error: Error = myError

        #expect(myError.id == "XcoreTests.ErrorTests.MyError")
        #expect(myError.id == error.id)
        #expect(myError.errorDescription == error.title)
        #expect(myError.failureReason == error.message)
        #expect(error.debugMessage == nil)
        #expect(error.logLevel == nil)
    }

    @Test
    func nsErrorProperties() {
        let errorDescription = "Some error description"
        let failureReason = "some failure reason"
        let debugDescription = "some debug description"

        let myError = NSError(domain: NSCocoaErrorDomain, code: 2, userInfo: [
            NSLocalizedDescriptionKey: errorDescription,
            NSLocalizedFailureReasonErrorKey: failureReason,
            NSDebugDescriptionErrorKey: debugDescription
        ])

        let error: Error = myError

        #expect(myError.id == "NSCocoaErrorDomain:2")
        #expect(myError.id == error.id)
        #expect(error.title == errorDescription)
        #expect(error.message == failureReason)
        #expect(error.debugMessage == nil) // debugDescription is messy for NSErrors
        #expect(error.logLevel == nil)
    }
}
