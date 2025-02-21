//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@_spi(Internal) import Xcore

struct ResultTests {
    @Test
    func isCancelled_anyError() {
        var r: Result<Void, any Error> = .failure(CancellationError())
        #expect(r.isCancelled)

        r = .failure(AppError.general)
        #expect(!r.isCancelled)

        r = .success
        #expect(!r.isCancelled)
    }

    @Test
    func isCancelled_appError() {
        var r: Result<Void, AppError> = .failure(.general)
        #expect(!r.isCancelled)

        r = .failure(AppError.noInternet)
        #expect(!r.isCancelled)

        r = .success
        #expect(!r.isCancelled)
    }
}
