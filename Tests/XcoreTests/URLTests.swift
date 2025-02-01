//
// Xcore
// Copyright © 2020 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct URLTests {
    @Test
    func queryItem() {
        let url = URL(string: "https://example.com/?q=HelloWorld")!
        #expect(url.queryItem(named: "q") == "HelloWorld")
        #expect(url.queryItem(named: "x") == nil)
    }

    @Test
    func removingFragment() {
        let url1 = URL(string: "https://example.com/#hero")!
        #expect(url1.removingFragment() == URL(string: "https://example.com/")!)

        let url2 = URL(string: "https://example.com#hero")!
        #expect(url2.removingFragment() == URL(string: "https://example.com")!)

        // Unchanged url.
        let url3 = URL(string: "https://example.com/?q=HelloWorld")!
        #expect(url3.removingFragment() == url3)
    }

    @Test
    func scheme() {
        // swiftlint:disable:next empty_string
        #expect(URL.Scheme.none == "")
        #expect(URL.Scheme.https == "https")
        #expect(URL.Scheme.http == "http")
        #expect(URL.Scheme.file == "file")
        #expect(URL.Scheme.tel == "tel")
        #expect(URL.Scheme.sms == "sms")
        #expect(URL.Scheme.email == "mailto")
    }

    @Test
    func removingScheme() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        #expect(url1.removingScheme() == "www.example.com/?q=HelloWorld")
        #expect(url2.removingScheme() == "welcome.hello.example.com/?q=HelloWorld")
        #expect(url3.removingScheme() == "www.hello.example.com/?q=HelloWorld")
        #expect(url4.removingScheme() == "hello.example.com")
        #expect(url5.removingScheme() == "mail.app")
        #expect(url6.removingScheme() == "mail.app")
        #expect(url7.removingScheme() == "mail.app")
    }

    @Test
    func removingQueryItems() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        #expect(url1.removingQueryItems() == URL(string: "https://www.example.com/"))
        #expect(url2.removingQueryItems() == URL(string: "http://welcome.hello.example.com/"))
        #expect(url3.removingQueryItems() == URL(string: "www.hello.example.com/"))
        #expect(url4.removingQueryItems() == URL(string: "hello.example.com"))
        #expect(url5.removingQueryItems() == URL(string: "mail.app"))
        #expect(url6.removingQueryItems() == URL(string: "file://mail.app"))
        #expect(url7.removingQueryItems() == URL(string: "mailto://mail.app"))
    }

    @Test
    func removingQueryItemsList() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!
        let url8 = URL(string: "https://www.example.com/?q=HelloWorld")!

        #expect(url1.removingQueryItems(["q"]) == URL(string: "https://www.example.com/"))
        #expect(url2.removingQueryItems(["q", "lang"]) == URL(string: "http://welcome.hello.example.com/"))
        #expect(url3.removingQueryItems(["q"]) == URL(string: "www.hello.example.com/"))
        #expect(url4.removingQueryItems(["q"]) == URL(string: "hello.example.com"))
        #expect(url5.removingQueryItems(["q"]) == URL(string: "mail.app"))
        #expect(url6.removingQueryItems(["q"]) == URL(string: "file://mail.app"))
        #expect(url7.removingQueryItems(["q"]) == URL(string: "mailto://mail.app"))
        #expect(url8.removingQueryItems(["w"]) == URL(string: "https://www.example.com/?q=HelloWorld"))
    }

    @Test
    func removingQueryItemNamed() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        #expect(url1.removingQueryItem(named: "q") == URL(string: "https://www.example.com/"))
        #expect(url2.removingQueryItem(named: "lang") == URL(string: "http://welcome.hello.example.com/?q=HelloWorld"))
        #expect(url3.removingQueryItem(named: "q") == URL(string: "www.hello.example.com/"))
        #expect(url4.removingQueryItem(named: "q") == URL(string: "hello.example.com"))
        #expect(url5.removingQueryItem(named: "q") == URL(string: "mail.app"))
        #expect(url6.removingQueryItem(named: "q") == URL(string: "file://mail.app"))
        #expect(url7.removingQueryItem(named: "q") == URL(string: "mailto://mail.app"))
    }

    @Test
    func replacingQueryItemNamed() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        #expect(url1.replacingQueryItem(named: "q", with: "Greetings") == URL(string: "https://www.example.com/?q=Greetings"))
        #expect(url2.replacingQueryItem(named: "lang", with: "Greetings") == URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=Greetings"))
        #expect(url2.replacingQueryItem(named: "w", with: "Greetings") == URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift"))
        #expect(url2.replacingQueryItem(named: "q", with: "Greetings") == URL(string: "http://welcome.hello.example.com/?q=Greetings&lang=swift"))
        #expect(url3.replacingQueryItem(named: "q", with: "Greetings") == URL(string: "www.hello.example.com/?q=Greetings"))
        #expect(url4.replacingQueryItem(named: "q", with: "Greetings") == URL(string: "hello.example.com"))
        #expect(url5.replacingQueryItem(named: "q", with: "Greetings") == URL(string: "mail.app"))
        #expect(url6.replacingQueryItem(named: "q", with: "Greetings") == URL(string: "file://mail.app"))
        #expect(url7.replacingQueryItem(named: "q", with: "Greetings") == URL(string: "mailto://mail.app"))
    }

    @Test
    func replacingQueryItemsList() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        #expect(url1.replacingQueryItems(["q"], with: "xxxx") == URL(string: "https://www.example.com/?q=xxxx"))
        #expect(url1.replacingQueryItems([], with: "xxxx") == URL(string: "https://www.example.com/?q=HelloWorld"))
        #expect(url2.replacingQueryItems(["lang"], with: "xxxx") == URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=xxxx"))
        #expect(url2.replacingQueryItems(["w"], with: "xxxx") == URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift"))
        #expect(url2.replacingQueryItems(["lang", "q"], with: "xxxx") == URL(string: "http://welcome.hello.example.com/?q=xxxx&lang=xxxx"))
        #expect(url3.replacingQueryItems(["q"], with: "xxxx") == URL(string: "www.hello.example.com/?q=xxxx"))
        #expect(url4.replacingQueryItems(["q"], with: "xxxx") == URL(string: "hello.example.com"))
        #expect(url5.replacingQueryItems(["q"], with: "xxxx") == URL(string: "mail.app"))
        #expect(url6.replacingQueryItems(["q"], with: "xxxx") == URL(string: "file://mail.app"))
        #expect(url7.replacingQueryItems(["q"], with: "xxxx") == URL(string: "mailto://mail.app"))
    }

    @Test
    func maskingAllQueryItems() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        #expect(url1.maskingAllQueryItems() == URL(string: "https://www.example.com/?q=xxxx"))
        #expect(url1.maskingAllQueryItems() == URL(string: "https://www.example.com/?q=xxxx"))
        #expect(url2.maskingAllQueryItems() == URL(string: "http://welcome.hello.example.com/?q=xxxx&lang=xxxx"))
        #expect(url2.maskingAllQueryItems() == URL(string: "http://welcome.hello.example.com/?q=xxxx&lang=xxxx"))
        #expect(url2.maskingAllQueryItems() == URL(string: "http://welcome.hello.example.com/?q=xxxx&lang=xxxx"))
        #expect(url2.maskingAllQueryItems(mask: "***") == URL(string: "http://welcome.hello.example.com/?q=***&lang=***"))
        #expect(url2.maskingAllQueryItems(mask: "") == URL(string: "http://welcome.hello.example.com/?q=&lang="))
        #expect(url3.maskingAllQueryItems() == URL(string: "www.hello.example.com/?q=xxxx"))
        #expect(url4.maskingAllQueryItems() == URL(string: "hello.example.com"))
        #expect(url5.maskingAllQueryItems() == URL(string: "mail.app"))
        #expect(url6.maskingAllQueryItems() == URL(string: "file://mail.app"))
        #expect(url7.maskingAllQueryItems() == URL(string: "mailto://mail.app"))
    }

    @Test
    func appendingQueryItemsList() {
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=swift")!
        let url3 = URL(string: "www.hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "hello.example.com")!
        let url5 = URL(string: "mail.app")!
        let url6 = URL(string: "file://mail.app")!
        let url7 = URL(string: "mailto://mail.app")!

        #expect(url1.appendQueryItems([.init(name: "lang", value: "Swift")]) == URL(string: "https://www.example.com/?q=HelloWorld&lang=Swift"))
        #expect(url1.appendQueryItems([.init(name: "lang", value: "Swift")]) == URL(string: "https://www.example.com/?q=HelloWorld&lang=Swift"))
        #expect(url2.appendQueryItems([.init(name: "lang", value: "Swift")]) == URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=Swift"))
        #expect(url2.appendQueryItems([.init(name: "q", value: nil)]) == URL(string: "http://welcome.hello.example.com/?lang=swift&q"))
        #expect(url2.appendQueryItems([.init(name: "lang", value: "en")]) == URL(string: "http://welcome.hello.example.com/?q=HelloWorld&lang=en"))
        #expect(url3.appendQueryItems([.init(name: "q", value: nil)]) == URL(string: "www.hello.example.com/?q"))
        #expect(url4.appendQueryItems([.init(name: "lang", value: "Swift")]) == URL(string: "hello.example.com?lang=Swift"))
        #expect(url5.appendQueryItems([.init(name: "lang", value: "Swift")]) == URL(string: "mail.app?lang=Swift"))
        #expect(url6.appendQueryItems([.init(name: "lang", value: "Swift")]) == URL(string: "file://mail.app?lang=Swift"))
        #expect(url7.appendQueryItems([.init(name: "lang", value: "Swift")]) == URL(string: "mailto://mail.app?lang=Swift"))
    }

    @Test
    func matchFound() {
        let domain = "example.com"
        let url1 = URL(string: "https://www.example.com/?q=HelloWorld")!
        let url2 = URL(string: "https://example.com/?q=HelloWorld")!
        let url3 = URL(string: "https://hello.example.com/?q=HelloWorld")!
        let url4 = URL(string: "https://welcome.hello.example.com/?q=HelloWorld")!

        #expect(url1.host == "www.example.com")
        #expect(url2.host == "example.com")
        #expect(url3.host == "hello.example.com")
        #expect(url4.host == "welcome.hello.example.com")

        #expect(url1.matches(domain))
        #expect(url2.matches(domain))
        #expect(url3.matches(domain))
        #expect(url4.matches(domain))
        #expect(!url4.matches(domain, includingSubdomains: false))

        // Org
        let url6 = URL(string: "https://example.org")!
        let url7 = URL(string: "example.org")!
        #expect(url6.host == "example.org")
        #expect(url7.host == nil)
        #expect(url6.matches("example.org") == true)
        #expect(url7.matches("example.org") == false)
    }

    @Test
    func matchNotFound() {
        let domain = "example.com"
        let url1 = URL(string: "https://www.examplex.com/?q=HelloWorld")!
        let url2 = URL(string: "https://example_x.com/?q=HelloWorld")!
        let url3 = URL(string: "https://hello.example-x.com/?q=HelloWorld")!
        let url4 = URL(string: "https://welcome.hello.helloexample.com/?q=HelloWorld")!
        let url5 = URL(string: "https://example.org")!

        #expect(url1.host == "www.examplex.com")
        #expect(url2.host == "example_x.com")
        #expect(url3.host == "hello.example-x.com")
        #expect(url4.host == "welcome.hello.helloexample.com")
        #expect(url5.host == "example.org")

        #expect(!url1.matches(domain))
        #expect(!url2.matches(domain))
        #expect(!url3.matches(domain))
        #expect(!url4.matches(domain))
        #expect(!url5.matches(domain))
    }

    @Test
    func maskingSensitiveQueryItems() {
        FeatureFlag.resetProviders()
        FeatureFlag.setValue(["token", "vfp"], forKey: "sensitive_url_query_parameters")
        let url1 = URL(string: "https://example.com/magiclink?token=Jn3yk23cf23")!
        let url2 = URL(string: "https://example.com/magiclink?token=Jn3yk23cf23")!
        let url3 = URL(string: "https://app.example.com/magiclink?token=Jn3yk23cf23")!
        let url4 = URL(string: "https://example.com/callback/prove?vfp=Jn3yk23cf23")!
        let url5 = URL(string: "https://app.example.com/magiclink?vfp=Jn3yk23cf23&token=Jn3yk23cf23")!
        let url6 = URL(string: "https://app.example.com/magiclink?token=Jn3yk23cf23&vfp=Jn3yk23cf23")!
        let url7 = URL(string: "https://example.com/dl/trade/buy?id=20")!
        let url8 = URL(string: "https://example.com/dl/trade/buy?id=20&token=Jn3yk2x3cf23")!
        let url9 = URL(string: "https://example.com/buy?token=Jn3yk2x3cf23")!
        let url10 = URL(string: "https://example.com?token=Jn3yk2x3cf23")!
        let url11 = URL(string: "https://example.com?code=Jn3yk2x3cf23")!

        #expect(url1.maskingSensitiveQueryItems() == URL(string: "https://example.com/magiclink?token=xxxx"))
        #expect(url2.maskingSensitiveQueryItems() == URL(string: "https://example.com/magiclink?token=xxxx"))
        #expect(url3.maskingSensitiveQueryItems() == URL(string: "https://app.example.com/magiclink?token=xxxx"))
        #expect(url4.maskingSensitiveQueryItems() == URL(string: "https://example.com/callback/prove?vfp=xxxx"))
        #expect(url5.maskingSensitiveQueryItems() == URL(string: "https://app.example.com/magiclink?vfp=xxxx&token=xxxx"))
        #expect(url6.maskingSensitiveQueryItems() == URL(string: "https://app.example.com/magiclink?token=xxxx&vfp=xxxx"))
        #expect(url7.maskingSensitiveQueryItems() == URL(string: "https://example.com/dl/trade/buy?id=20"))
        #expect(url8.maskingSensitiveQueryItems() == URL(string: "https://example.com/dl/trade/buy?id=20&token=xxxx"))
        #expect(url9.maskingSensitiveQueryItems() == URL(string: "https://example.com/buy?token=xxxx"))
        #expect(url10.maskingSensitiveQueryItems() == URL(string: "https://example.com?token=xxxx"))
        #expect(url11.maskingSensitiveQueryItems() == URL(string: "https://example.com?code=Jn3yk2x3cf23"))
    }

    @Test
    func resolvingRedirectedLink() async {
        let shortUrl = URL(string: "https://git.new/swift")!
        let resolvedUrl = await shortUrl.resolvingRedirectedLink(timeout: .seconds(10))
        let expandedUrl = "https://github.com/swiftlang/swift"
        #expect(resolvedUrl?.absoluteString == expandedUrl)
    }
}
