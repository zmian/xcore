//
// StringTests.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import XCTest
@testable import Xcore

final class StringTests: TestCase {
    func testMD5Hash() {
        let string1 = "Hello World"
        XCTAssert(string1.md5()! == "b10a8db164e0754105b7a99be72e3fe5")

        let string2 = "hello world"
        XCTAssert(string2.md5()! == "5eb63bbbe01eeed093cb22bb8f5acdc3")

        XCTAssert(string1.md5()! != string2.md5()!)
    }

    func testSha256Hash() {
        let string1 = "Hello World"
        XCTAssert(string1.sha256()! == "a591a6d40bf420404a011733cfb7b190d62c65bf0bcda32b57b277d9ad9f146e")

        let string2 = "hello world"
        XCTAssert(string2.sha256()! == "b94d27b9934d3e08a52e52d7da7dabfac484efe37a5380ee9088f7ace2efcde9")

        XCTAssert(string1.sha256()! != string2.sha256()!)
    }

    func testUppercasedFirstAndLowercasedFirst() {
        let input1 = "Hello World"
        XCTAssert(input1.uppercasedFirst() == "Hello World")
        XCTAssert(input1.lowercasedFirst() == "hello World")

        let input2 = "HelloWorld"
        XCTAssert(input2.uppercasedFirst() == "HelloWorld")
        XCTAssert(input2.lowercasedFirst() == "helloWorld")

        let input3 = "helloworld"
        XCTAssert(input3.uppercasedFirst() == "Helloworld")
        XCTAssert(input3.lowercasedFirst() == "helloworld")

        let input4 = "hello world"
        XCTAssert(input4.uppercasedFirst() == "Hello world")
        XCTAssert(input4.lowercasedFirst() == "hello world")
    }

    func testCamelcased() {
        XCTAssert("".camelcased() == "")
        XCTAssert("a".camelcased() == "a")
        XCTAssert("aBC".camelcased() == "aBC")
        XCTAssert("a b".camelcased() == "aB")

        XCTAssert("HELLOWORLD".camelcased() == "helloworld")
        XCTAssert("HELLO_WORLD".camelcased() == "helloWorld")
        XCTAssert("HELLOwORLD".camelcased() == "helloWorld")
        XCTAssert("HELLOworld".camelcased() == "helloWorld")
        XCTAssert("HELLOworlD".camelcased() == "helloWorlD")

        XCTAssert("Helloworld".camelcased() == "helloworld")
        XCTAssert("HelloWorld".camelcased() == "helloWorld")
        XCTAssert("Hello World".camelcased() == "helloWorld")
        XCTAssert("Hello World, Greeting".camelcased() == "helloWorldGreeting")
        XCTAssert("Hello World, Greeting 🐶🐮".camelcased() == "helloWorldGreeting")
        XCTAssert("Hello World, Greeting 🐶🐮".snakecased().titlecased().camelcased() == "helloWorldGreeting")
        XCTAssert("TheSwiftProgrammingLanguage".camelcased() == "theSwiftProgrammingLanguage")
    }

    func testSnakecased() {
        XCTAssert("".snakecased() == "")
        XCTAssert("a".snakecased() == "a")
        XCTAssert("aBC".snakecased() == "a_b_c")
        XCTAssert("a b".snakecased() == "a_b")

        XCTAssert("HELLOWORLD".snakecased() == "helloworld")
        XCTAssert("HELLO_WORLD".snakecased() == "hello_world")
        XCTAssert("HELLOwORLD".snakecased() == "hello_world")
        XCTAssert("HELLOworld".snakecased() == "hello_world")
        XCTAssert("HELLOworlD".snakecased() == "hello_worl_d")

        XCTAssert("Helloworld".snakecased() == "helloworld")
        XCTAssert("HelloWorld".snakecased() == "hello_world")
        XCTAssert("hello_world".snakecased() == "hello_world")
        XCTAssert("Hello_World".snakecased() == "hello_world")
        XCTAssert("Hello World".snakecased() == "hello_world")
        XCTAssert("Hello World, Greeting".snakecased() == "hello_world_greeting")
        XCTAssert("Hello World, Greeting 🐶🐮".snakecased() == "hello_world_greeting")
        XCTAssert("Hello World, Greeting 🐶🐮".camelcased().titlecased().snakecased() == "hello_world_greeting")
        XCTAssert("TheSwiftProgrammingLanguage".snakecased() == "the_swift_programming_language")
    }

    func testTitlecased() {
        XCTAssert("".titlecased() == "")
        XCTAssert("a".titlecased() == "A")
        XCTAssert("aBC".titlecased() == "A B C")
        XCTAssert("a b".titlecased() == "A B")

        XCTAssert("HELLOWORLD".titlecased() == "Helloworld")
        XCTAssert("HELLO_WORLD".titlecased() == "Hello World")
        XCTAssert("HELLOwORLD".titlecased() == "Hello World")
        XCTAssert("HELLOworld".titlecased() == "Hello World")
        XCTAssert("HELLOworlD".titlecased() == "hello Worl D")

        XCTAssert("we're having dinner in the garden".titlecased() == "We're Having Dinner In The Garden")
        XCTAssert("TheSwiftProgrammingLanguage".titlecased() == "The Swift Programming Language")
        XCTAssert("TheSwiftProgrammingLanguage".snakecased().camelcased().titlecased() == "The Swift Programming Language")
    }
}
