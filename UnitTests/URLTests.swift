//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class URLTests: TestCase {
    func testQueryItem() {
        let url = URL(string: "https://example.com/?q=HelloWorld")!
        XCTAssertEqual(url.queryItem(named: "q"), "HelloWorld")
    }
}
