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
        XCTAssertEqual(url.queryItem(named: "x"), nil)
    }

    func testDeletingFragment() {
        let url1 = URL(string: "https://example.com/#hero")!
        XCTAssertEqual(url1.deletingFragment(), URL(string: "https://example.com/")!)

        let url2 = URL(string: "https://example.com#hero")!
        XCTAssertEqual(url2.deletingFragment(), URL(string: "https://example.com")!)

        // Unchanged url.
        let url3 = URL(string: "https://example.com/?q=HelloWorld")!
        XCTAssertEqual(url3.deletingFragment(), url3)
    }

    func testScheme() {
        XCTAssertEqual(URL.Scheme.none, "")
        XCTAssertEqual(URL.Scheme.https, "https")
        XCTAssertEqual(URL.Scheme.http, "http")
        XCTAssertEqual(URL.Scheme.file, "file")
        XCTAssertEqual(URL.Scheme.tel, "tel")
        XCTAssertEqual(URL.Scheme.sms, "sms")
        XCTAssertEqual(URL.Scheme.email, "mailto")
    }
}
