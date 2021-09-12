//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class StringTests: TestCase {
    func testMasked() {
        let email = "support@example.com"
        XCTAssertEqual(email.formatted(.masked), "s•••@example.com")
        XCTAssertEqual(email.formatted(.masked(count: .same)), "s••••••@example.com")
        XCTAssertEqual(email.formatted(.masked(count: .equal(2))), "s••@example.com")

        let string1 = "Hello World"
        XCTAssertEqual(string1.formatted(.masked), "•••••••••••")

        let string2 = "0123456789"
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 3)), "•••••••789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 4)), "••••••6789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 4)), "0123••••••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 14)), "0123456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 14)), "0123456789")
        XCTAssertEqual(string2.formatted(.maskedAccountNumber), "•••• 6789")

        // Options: Last 4
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 4, separator: " ")), "•••••• 6789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 4, count: .same, separator: " ")), "•••••• 6789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 9, count: .same, separator: " ")), "• 123456789")

        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 10, count: .min(2), separator: " ")), "•• 0123456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 9, count: .min(2), separator: " ")), "•• 123456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 8, count: .min(2), separator: " ")), "•• 23456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 7, count: .min(2), separator: " ")), "••• 3456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 4, count: .min(2), separator: " ")), "•••••• 6789")

        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 10, count: .max(2), separator: " ")), "0123456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 9, count: .max(2), separator: " ")), "• 123456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 8, count: .max(2), separator: " ")), "•• 23456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 7, count: .max(2), separator: " ")), "•• 3456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 4, count: .max(2), separator: " ")), "•• 6789")

        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 10, count: .equal(1), separator: " ")), "• 0123456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 4, count: .equal(4), separator: " ")), "•••• 6789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(last: 10, count: .equal(4), separator: " ")), "•••• 0123456789")

        // Options: First 4
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 4, separator: " ")), "0123 ••••••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 4, count: .same, separator: " ")), "0123 ••••••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 9, count: .same, separator: " ")), "012345678 •")

        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 10, count: .min(2), separator: " ")), "0123456789 ••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 9, count: .min(2), separator: " ")), "012345678 ••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 8, count: .min(2), separator: " ")), "01234567 ••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 7, count: .min(2), separator: " ")), "0123456 •••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 4, count: .min(2), separator: " ")), "0123 ••••••")

        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 10, count: .max(2), separator: " ")), "0123456789")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 9, count: .max(2), separator: " ")), "012345678 •")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 8, count: .max(2), separator: " ")), "01234567 ••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 7, count: .max(2), separator: " ")), "0123456 ••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 4, count: .max(2), separator: " ")), "0123 ••")

        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 10, count: .equal(1), separator: " ")), "0123456789 •")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 4, count: .equal(4), separator: " ")), "0123 ••••")
        XCTAssertEqual(string2.formatted(.maskedAllExcept(first: 10, count: .equal(4), separator: " ")), "0123456789 ••••")
    }

    func testRandomAlphanumerics() {
        let result = String.randomAlphanumerics(length: 50)
        XCTAssertEqual(result.count, 50)
    }

    func testUppercasedFirstAndLowercasedFirst() {
        let input1 = "Hello World"
        XCTAssertEqual(input1.uppercasedFirst(), "Hello World")
        XCTAssertEqual(input1.lowercasedFirst(), "hello World")

        let input2 = "HelloWorld"
        XCTAssertEqual(input2.uppercasedFirst(), "HelloWorld")
        XCTAssertEqual(input2.lowercasedFirst(), "helloWorld")

        let input3 = "helloworld"
        XCTAssertEqual(input3.uppercasedFirst(), "Helloworld")
        XCTAssertEqual(input3.lowercasedFirst(), "helloworld")

        let input4 = "hello world"
        XCTAssertEqual(input4.uppercasedFirst(), "Hello world")
        XCTAssertEqual(input4.lowercasedFirst(), "hello world")
    }

    func testCamelcased() {
        XCTAssertEqual("".camelcased(), "")
        XCTAssertEqual("a".camelcased(), "a")
        XCTAssertEqual("aBC".camelcased(), "aBC")
        XCTAssertEqual("a b".camelcased(), "aB")

        XCTAssertEqual("HELLOWORLD".camelcased(), "helloworld")
        XCTAssertEqual("HELLO_WORLD".camelcased(), "helloWorld")

        #warning("FIXME")
//        XCTAssertEqual("HELLOwORLD".camelcased(), "helloWorld")
//        XCTAssertEqual("HELLOworld".camelcased(), "helloWorld")
//        XCTAssertEqual("HELLOworlD".camelcased(), "helloWorlD")

        XCTAssertEqual("Helloworld".camelcased(), "helloworld")
        XCTAssertEqual("HelloWorld".camelcased(), "helloWorld")
        XCTAssertEqual("Hello World".camelcased(), "helloWorld")
        XCTAssertEqual("Hello World, Greeting".camelcased(), "helloWorldGreeting")
        XCTAssertEqual("Hello World, Greeting 🐶🐮".camelcased(), "helloWorldGreeting")
        XCTAssertEqual("Hello World, Greeting 🐶🐮".snakecased().titlecased().camelcased(), "helloWorldGreeting")
        XCTAssertEqual("TheSwiftProgrammingLanguage".camelcased(), "theSwiftProgrammingLanguage")
    }

    func testSnakecased() {
        XCTAssertEqual("".snakecased(), "")
        XCTAssertEqual("a".snakecased(), "a")
        XCTAssertEqual("aBC".snakecased(), "a_b_c")
        XCTAssertEqual("a b".snakecased(), "a_b")

        XCTAssertEqual("HELLOWORLD".snakecased(), "helloworld")
        XCTAssertEqual("HELLO_WORLD".snakecased(), "hello_world")

        #warning("FIXME")
//        XCTAssertEqual("HELLOwORLD".snakecased(), "hello_world")
//        XCTAssertEqual("HELLOworld".snakecased(), "hello_world")
//        XCTAssertEqual("HELLOworlD".snakecased(), "hello_worl_d")

        XCTAssertEqual("Helloworld".snakecased(), "helloworld")
        XCTAssertEqual("HelloWorld".snakecased(), "hello_world")
        XCTAssertEqual("hello_world".snakecased(), "hello_world")
        XCTAssertEqual("Hello_World".snakecased(), "hello_world")
        XCTAssertEqual("Hello World".snakecased(), "hello_world")
        XCTAssertEqual("Hello World, Greeting".snakecased(), "hello_world_greeting")
        XCTAssertEqual("Hello World, Greeting 🐶🐮".snakecased(), "hello_world_greeting")
        XCTAssertEqual("Hello World, Greeting 🐶🐮".camelcased().titlecased().snakecased(), "hello_world_greeting")
        XCTAssertEqual("TheSwiftProgrammingLanguage".snakecased(), "the_swift_programming_language")
    }

    func testTitlecased() {
        XCTAssertEqual("".titlecased(), "")
        XCTAssertEqual("a".titlecased(), "A")
//        XCTAssertEqual("aBC".titlecased(), "A B C")
        XCTAssertEqual("a b".titlecased(), "A B")

        XCTAssertEqual("HELLOWORLD".titlecased(), "Helloworld")
        #warning("FIXME")
//        XCTAssertEqual("HELLO_WORLD".titlecased(), "Hello World")
//        XCTAssertEqual("HELLOwORLD".titlecased(), "Hello World")
//        XCTAssertEqual("HELLOworld".titlecased(), "Hello World")
//        XCTAssertEqual("HELLOworlD".titlecased(), "hello Worl D")

        XCTAssertEqual("we're having dinner in the garden".titlecased(), "We're Having Dinner In The Garden")
        XCTAssertEqual("TheSwiftProgrammingLanguage".snakecased().replacing("_", with: " ").titlecased(), "The Swift Programming Language")
        XCTAssertEqual("TheSwiftProgrammingLanguage".snakecased().camelcased().titlecased(), "TheSwiftProgrammingLanguage")
    }
}
