//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

struct ImageFetcherCompositeTests {
    @Test
    func initDeduplicatesFetchersWithSameId() {
        let deduped = CompositeImageFetcher([DefaultImageFetcher(), DefaultImageFetcher()])
        let single = CompositeImageFetcher([DefaultImageFetcher()])
        #expect(deduped.id == single.id)
    }
}