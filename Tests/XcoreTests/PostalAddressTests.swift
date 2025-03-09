//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct PostalAddressTests {
    @Test
    func formatted() {
        let formatted = PostalAddress.sample.formatted()
        #expect(formatted ==
            """
            One Apple Park Way
            Cupertino CA 95014
            United States
            """
        )
    }
}
