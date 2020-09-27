//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class StringTests: TestCase {
    func testSha256Hash() {
        let string1 = "Hello World"
        XCTAssertEqual(string1.sha256()!, "a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e")

        let string2 = "hello world"
        XCTAssertEqual(string2.sha256()!, "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9")

        XCTAssertNotEqual(string1.sha256()!, string2.sha256()!)
    }

    func testMask() {
        let email = "support@apple.com"
        XCTAssertEqual(email.masked(), "s•••@apple.com")
        XCTAssertEqual(email.masked(options: .automatic(maskCount: .same)), "s••••••@apple.com")
        XCTAssertEqual(email.masked(options: .automatic(maskCount: .equal(2))), "s••@apple.com")

        let string1 = "Hello World"
        XCTAssertEqual(string1.masked(), "•••••••••••")

        let string2 = "0123456789"
        XCTAssertEqual(string2.masked(options: .allExceptLast(3)), "•••••••789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(4)), "••••••6789")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(4)), "0123••••••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(14)), "0123456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(14)), "0123456789")
        XCTAssertEqual(string2.masked(options: .accountNumber), "•••• 6789")

        // Options: Last 4
        XCTAssertEqual(string2.masked(options: .allExceptLast(4, separator: " ")), "•••••• 6789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(4, maskCount: .same, separator: " ")), "•••••• 6789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(9, maskCount: .same, separator: " ")), "• 123456789")

        XCTAssertEqual(string2.masked(options: .allExceptLast(10, maskCount: .min(2), separator: " ")), "•• 0123456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(9, maskCount: .min(2), separator: " ")), "•• 123456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(8, maskCount: .min(2), separator: " ")), "•• 23456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(7, maskCount: .min(2), separator: " ")), "••• 3456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(4, maskCount: .min(2), separator: " ")), "•••••• 6789")

        XCTAssertEqual(string2.masked(options: .allExceptLast(10, maskCount: .max(2), separator: " ")), "0123456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(9, maskCount: .max(2), separator: " ")), "• 123456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(8, maskCount: .max(2), separator: " ")), "•• 23456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(7, maskCount: .max(2), separator: " ")), "•• 3456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(4, maskCount: .max(2), separator: " ")), "•• 6789")

        XCTAssertEqual(string2.masked(options: .allExceptLast(10, maskCount: .equal(1), separator: " ")), "• 0123456789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(4, maskCount: .equal(4), separator: " ")), "•••• 6789")
        XCTAssertEqual(string2.masked(options: .allExceptLast(10, maskCount: .equal(4), separator: " ")), "•••• 0123456789")

        // Options: First 4
        XCTAssertEqual(string2.masked(options: .allExceptFirst(4, separator: " ")), "0123 ••••••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(4, maskCount: .same, separator: " ")), "0123 ••••••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(9, maskCount: .same, separator: " ")), "012345678 •")

        XCTAssertEqual(string2.masked(options: .allExceptFirst(10, maskCount: .min(2), separator: " ")), "0123456789 ••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(9, maskCount: .min(2), separator: " ")), "012345678 ••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(8, maskCount: .min(2), separator: " ")), "01234567 ••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(7, maskCount: .min(2), separator: " ")), "0123456 •••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(4, maskCount: .min(2), separator: " ")), "0123 ••••••")

        XCTAssertEqual(string2.masked(options: .allExceptFirst(10, maskCount: .max(2), separator: " ")), "0123456789")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(9, maskCount: .max(2), separator: " ")), "012345678 •")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(8, maskCount: .max(2), separator: " ")), "01234567 ••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(7, maskCount: .max(2), separator: " ")), "0123456 ••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(4, maskCount: .max(2), separator: " ")), "0123 ••")

        XCTAssertEqual(string2.masked(options: .allExceptFirst(10, maskCount: .equal(1), separator: " ")), "0123456789 •")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(4, maskCount: .equal(4), separator: " ")), "0123 ••••")
        XCTAssertEqual(string2.masked(options: .allExceptFirst(10, maskCount: .equal(4), separator: " ")), "0123456789 ••••")
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
        XCTAssertEqual("HELLOwORLD".camelcased(), "helloWorld")
        XCTAssertEqual("HELLOworld".camelcased(), "helloWorld")
        XCTAssertEqual("HELLOworlD".camelcased(), "helloWorlD")

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
        XCTAssertEqual("HELLOwORLD".snakecased(), "hello_world")
        XCTAssertEqual("HELLOworld".snakecased(), "hello_world")
        XCTAssertEqual("HELLOworlD".snakecased(), "hello_worl_d")

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
        XCTAssertEqual("aBC".titlecased(), "A B C")
        XCTAssertEqual("a b".titlecased(), "A B")

        XCTAssertEqual("HELLOWORLD".titlecased(), "Helloworld")
        XCTAssertEqual("HELLO_WORLD".titlecased(), "Hello World")
        XCTAssertEqual("HELLOwORLD".titlecased(), "Hello World")
        XCTAssertEqual("HELLOworld".titlecased(), "Hello World")
        XCTAssertEqual("HELLOworlD".titlecased(), "hello Worl D")

        XCTAssertEqual("we're having dinner in the garden".titlecased(), "We're Having Dinner In The Garden")
        XCTAssertEqual("TheSwiftProgrammingLanguage".titlecased(), "The Swift Programming Language")
        XCTAssertEqual("TheSwiftProgrammingLanguage".snakecased().camelcased().titlecased(), "The Swift Programming Language")
    }
}
