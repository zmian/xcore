//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct DataStatusTests {
    @Test
    func isFailureOrEmpty() {
        var data = DataStatus<[String]>.idle
        #expect(data.isFailureOrEmpty == false)

        data = .loading
        #expect(data.isFailureOrEmpty == false)

        // True, collection is empty
        data = .failure(.general)
        #expect(data.isFailureOrEmpty == true)

        // False, collection is empty
        data = .success(["Hello"])
        #expect(data.isFailureOrEmpty == false)

        // True, collection is empty
        data = .success([])
        #expect(data.isFailureOrEmpty == true)
    }

    @Test
    func isFailureOrEmpty_ReloadableDataStatus() {
        var data = ReloadableDataStatus<[String]>.idle
        #expect(data.isFailureOrEmpty == false)

        data = .loading
        #expect(data.isFailureOrEmpty == false)

        // True, collection is empty
        data = .failure(.general)
        #expect(data.isFailureOrEmpty == true)

        // False, collection is empty
        data = .success(["Hello"])
        #expect(data.isFailureOrEmpty == false)

        // True, collection is empty
        data = .success([])
        #expect(data.isFailureOrEmpty == true)

        // True, collection is empty
        data = .reloading([])
        #expect(data.isFailureOrEmpty == true)

        // False, collection is empty
        data = .reloading(["Hello"])
        #expect(data.isFailureOrEmpty == false)
    }
}
