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

    func testRemovingFragment() {
        let url1 = URL(string: "https://example.com/#hero")!
        XCTAssertEqual(url1.removingFragment(), URL(string: "https://example.com/")!)

        let url2 = URL(string: "https://example.com#hero")!
        XCTAssertEqual(url2.removingFragment(), URL(string: "https://example.com")!)

        // Unchanged url.
        let url3 = URL(string: "https://example.com/?q=HelloWorld")!
        XCTAssertEqual(url3.removingFragment(), url3)
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

    func testRemovingScheme() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        XCTAssertEqual(url1.removingScheme(), "www.example.com/?q=HelloWorld")
        XCTAssertEqual(url2.removingScheme(), "welcome.hello.example.com/?q=HelloWorld")
        XCTAssertEqual(url3.removingScheme(), "www.hello.example.com/?q=HelloWorld")
        XCTAssertEqual(url4.removingScheme(), "hello.example.com")
        XCTAssertEqual(url5.removingScheme(), "mail.app")
        XCTAssertEqual(url6.removingScheme(), "mail.app")
        XCTAssertEqual(url7.removingScheme(), "mail.app")
    }

    func testRemovingQueryItems() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        XCTAssertEqual(url1.removingQueryItems(), URL(string: "https://www.example.com/")!)
        XCTAssertEqual(url2.removingQueryItems(), URL(string: "http://welcome.hello.example.com/")!)
        XCTAssertEqual(url3.removingQueryItems(), URL(string: "www.hello.example.com/")!)
        XCTAssertEqual(url4.removingQueryItems(), URL(string: "hello.example.com")!)
        XCTAssertEqual(url5.removingQueryItems(), URL(string: "mail.app")!)
        XCTAssertEqual(url6.removingQueryItems(), URL(string: "file://mail.app")!)
        XCTAssertEqual(url7.removingQueryItems(), URL(string: "mailto://mail.app")!)
    }

    func testRemovingQueryItemsList() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!
        let url8 = URL(string: "https://www.example.com/?q=HelloWorld")!

        XCTAssertEqual(url1.removingQueryItems(["q"]), URL(string: "https://www.example.com/")!)
        XCTAssertEqual(url2.removingQueryItems(["q", "lang"]), URL(string: "http://welcome.hello.example.com/")!)
        XCTAssertEqual(url3.removingQueryItems(["q"]), URL(string: "www.hello.example.com/")!)
        XCTAssertEqual(url4.removingQueryItems(["q"]), URL(string: "hello.example.com")!)
        XCTAssertEqual(url5.removingQueryItems(["q"]), URL(string: "mail.app")!)
        XCTAssertEqual(url6.removingQueryItems(["q"]), URL(string: "file://mail.app")!)
        XCTAssertEqual(url7.removingQueryItems(["q"]), URL(string: "mailto://mail.app")!)
        XCTAssertEqual(url8.removingQueryItems(["w"]), URL(string: "https://www.example.com/?q=HelloWorld")!)
    }

    func testRemovingQueryItemNamed() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        XCTAssertEqual(url1.removingQueryItem(named: "q"), URL(string: "https://www.example.com/")!)
        XCTAssertEqual(url2.removingQueryItem(named: "lang"), URL(string: "http://welcome.hello.example.com/?q=HelloWorld")!)
        XCTAssertEqual(url3.removingQueryItem(named: "q"), URL(string: "www.hello.example.com/")!)
        XCTAssertEqual(url4.removingQueryItem(named: "q"), URL(string: "hello.example.com")!)
        XCTAssertEqual(url5.removingQueryItem(named: "q"), URL(string: "mail.app")!)
        XCTAssertEqual(url6.removingQueryItem(named: "q"), URL(string: "file://mail.app")!)
        XCTAssertEqual(url7.removingQueryItem(named: "q"), URL(string: "mailto://mail.app")!)
    }

    func testReplacingQueryItemNamed() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        XCTAssertEqual(url1.replacingQueryItem(named: "q", with: "Greetings"), URL(string: "https://www.example.com/?q=Greetings")!)
        XCTAssertEqual(url2.replacingQueryItem(named: "lang", with: "Greetings"), URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=Greetings")!)
        XCTAssertEqual(url2.replacingQueryItem(named: "w", with: "Greetings"), URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!)
        XCTAssertEqual(url2.replacingQueryItem(named: "q", with: "Greetings"), URL(string: "http://welcome.hello.example.com/?q=Greetings&lang=swift")!)
        XCTAssertEqual(url3.replacingQueryItem(named: "q", with: "Greetings"), URL(string: "www.hello.example.com/?q=Greetings")!)
        XCTAssertEqual(url4.replacingQueryItem(named: "q", with: "Greetings"), URL(string: "hello.example.com")!)
        XCTAssertEqual(url5.replacingQueryItem(named: "q", with: "Greetings"), URL(string: "mail.app")!)
        XCTAssertEqual(url6.replacingQueryItem(named: "q", with: "Greetings"), URL(string: "file://mail.app")!)
        XCTAssertEqual(url7.replacingQueryItem(named: "q", with: "Greetings"), URL(string: "mailto://mail.app")!)
    }

    func testReplacingQueryItemsList() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        XCTAssertEqual(url1.replacingQueryItems(["q"], with: "xxxx"), URL(string: "https://www.example.com/?q=xxxx")!)
        XCTAssertEqual(url1.replacingQueryItems([], with: "xxxx"), URL(string: "https://www.example.com/?q=HelloWorld")!)
        XCTAssertEqual(url2.replacingQueryItems(["lang"], with: "xxxx"), URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=xxxx")!)
        XCTAssertEqual(url2.replacingQueryItems(["w"], with: "xxxx"), URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!)
        XCTAssertEqual(url2.replacingQueryItems(["lang", "q"], with: "xxxx"), URL(string: "http://welcome.hello.example.com/?q=xxxx&lang=xxxx")!)
        XCTAssertEqual(url3.replacingQueryItems(["q"], with: "xxxx"), URL(string: "www.hello.example.com/?q=xxxx")!)
        XCTAssertEqual(url4.replacingQueryItems(["q"], with: "xxxx"), URL(string: "hello.example.com")!)
        XCTAssertEqual(url5.replacingQueryItems(["q"], with: "xxxx"), URL(string: "mail.app")!)
        XCTAssertEqual(url6.replacingQueryItems(["q"], with: "xxxx"), URL(string: "file://mail.app")!)
        XCTAssertEqual(url7.replacingQueryItems(["q"], with: "xxxx"), URL(string: "mailto://mail.app")!)
    }

    func testMatchFound() {
        let domain = "example.com"
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "https://example.com/?q=HelloWorld")!
        let url3 = URL(string: "https://hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "https://welcome.hello.example.com/?q=HelloWorld")!

        XCTAssertEqual(url1.host, "www.example.com")
        XCTAssertEqual(url2.host, "example.com")
        XCTAssertEqual(url3.host, "hello.example.com")
        XCTAssertEqual(url4.host, "welcome.hello.example.com")

        XCTAssertTrue(url1.matches(domain))
        XCTAssertTrue(url2.matches(domain))
        XCTAssertTrue(url3.matches(domain))
        XCTAssertTrue(url4.matches(domain))
        XCTAssertFalse(url4.matches(domain, includingSubdomains: false))

        // Org
        let url6 = URL(string: "https://example.org")!
        let url7 = URL(string: "example.org")!
        XCTAssertEqual(url6.host, "example.org")
        XCTAssertEqual(url7.host, nil)
        XCTAssertEqual(url6.matches("example.org"), true)
        XCTAssertFalse(url7.matches("example.org"))
    }

    func testMatchNotFound() {
        let domain = "example.com"
        let url1 = URL(string: "https://www.examplex.com/?q=HelloWorld")!
        let url2 = URL(string: "https://example_x.com/?q=HelloWorld")!
        let url3 = URL(string: "https://hello.example-x.com/?q=HelloWorld")!
        let url4 = URL(string: "https://welcome.hello.helloexample.com/?q=HelloWorld")!
        let url5 = URL(string: "https://example.org")!

        XCTAssertEqual(url1.host, "www.examplex.com")
        XCTAssertEqual(url2.host, "example_x.com")
        XCTAssertEqual(url3.host, "hello.example-x.com")
        XCTAssertEqual(url4.host, "welcome.hello.helloexample.com")
        XCTAssertEqual(url5.host, "example.org")

        XCTAssertFalse(url1.matches(domain))
        XCTAssertFalse(url2.matches(domain))
        XCTAssertFalse(url3.matches(domain))
        XCTAssertFalse(url4.matches(domain))
        XCTAssertFalse(url5.matches(domain))
    }
}
