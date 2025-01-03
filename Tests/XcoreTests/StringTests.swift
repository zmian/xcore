//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct StringTests {
    @Test
    func masked() {
        let email = "support@example.com"
        #expect(email.formatted(.masked) == "s•••@example.com")
        #expect(email.formatted(.masked(count: .same)) == "s••••••@example.com")
        #expect(email.formatted(.masked(count: .equal(2))) == "s••@example.com")
        #expect(email.formatted(.masked(count: nil)) == "s•••@example.com")

        let string1 = "Hello World"
        #expect(string1.formatted(.masked) == "•••••••••••")

        let string2 = "0123456789"
        #expect(string2.formatted(.maskedAllExcept(last: 3)) == "•••••••789")
        #expect(string2.formatted(.maskedAllExcept(last: 4)) == "••••••6789")
        #expect(string2.formatted(.maskedAllExcept(first: 4)) == "0123••••••")
        #expect(string2.formatted(.maskedAllExcept(first: 14)) == "0123456789")
        #expect(string2.formatted(.maskedAllExcept(last: 14)) == "0123456789")
        #expect(string2.formatted(.maskedAccountNumber) == "•••• 6789")

        // Options: Last 4
        #expect(string2.formatted(.maskedAllExcept(last: 4, separator: " ")) == "•••••• 6789")
        #expect(string2.formatted(.maskedAllExcept(last: 4, count: .same, separator: " ")) == "•••••• 6789")
        #expect(string2.formatted(.maskedAllExcept(last: 9, count: .same, separator: " ")) == "• 123456789")

        #expect(string2.formatted(.maskedAllExcept(last: 10, count: .min(2), separator: " ")) == "•• 0123456789")
        #expect(string2.formatted(.maskedAllExcept(last: 9, count: .min(2), separator: " ")) == "•• 123456789")
        #expect(string2.formatted(.maskedAllExcept(last: 8, count: .min(2), separator: " ")) == "•• 23456789")
        #expect(string2.formatted(.maskedAllExcept(last: 7, count: .min(2), separator: " ")) == "••• 3456789")
        #expect(string2.formatted(.maskedAllExcept(last: 4, count: .min(2), separator: " ")) == "•••••• 6789")

        #expect(string2.formatted(.maskedAllExcept(last: 10, count: .max(2), separator: " ")) == "0123456789")
        #expect(string2.formatted(.maskedAllExcept(last: 9, count: .max(2), separator: " ")) == "• 123456789")
        #expect(string2.formatted(.maskedAllExcept(last: 8, count: .max(2), separator: " ")) == "•• 23456789")
        #expect(string2.formatted(.maskedAllExcept(last: 7, count: .max(2), separator: " ")) == "•• 3456789")
        #expect(string2.formatted(.maskedAllExcept(last: 4, count: .max(2), separator: " ")) == "•• 6789")

        #expect(string2.formatted(.maskedAllExcept(last: 10, count: .equal(1), separator: " ")) == "• 0123456789")
        #expect(string2.formatted(.maskedAllExcept(last: 4, count: .equal(4), separator: " ")) == "•••• 6789")
        #expect(string2.formatted(.maskedAllExcept(last: 10, count: .equal(4), separator: " ")) == "•••• 0123456789")

        // Options: First 4
        #expect(string2.formatted(.maskedAllExcept(first: 4, separator: " ")) == "0123 ••••••")
        #expect(string2.formatted(.maskedAllExcept(first: 4, count: .same, separator: " ")) == "0123 ••••••")
        #expect(string2.formatted(.maskedAllExcept(first: 9, count: .same, separator: " ")) == "012345678 •")

        #expect(string2.formatted(.maskedAllExcept(first: 10, count: .min(2), separator: " ")) == "0123456789 ••")
        #expect(string2.formatted(.maskedAllExcept(first: 9, count: .min(2), separator: " ")) == "012345678 ••")
        #expect(string2.formatted(.maskedAllExcept(first: 8, count: .min(2), separator: " ")) == "01234567 ••")
        #expect(string2.formatted(.maskedAllExcept(first: 7, count: .min(2), separator: " ")) == "0123456 •••")
        #expect(string2.formatted(.maskedAllExcept(first: 4, count: .min(2), separator: " ")) == "0123 ••••••")

        #expect(string2.formatted(.maskedAllExcept(first: 10, count: .max(2), separator: " ")) == "0123456789")
        #expect(string2.formatted(.maskedAllExcept(first: 9, count: .max(2), separator: " ")) == "012345678 •")
        #expect(string2.formatted(.maskedAllExcept(first: 8, count: .max(2), separator: " ")) == "01234567 ••")
        #expect(string2.formatted(.maskedAllExcept(first: 7, count: .max(2), separator: " ")) == "0123456 ••")
        #expect(string2.formatted(.maskedAllExcept(first: 4, count: .max(2), separator: " ")) == "0123 ••")

        #expect(string2.formatted(.maskedAllExcept(first: 10, count: .equal(1), separator: " ")) == "0123456789 •")
        #expect(string2.formatted(.maskedAllExcept(first: 4, count: .equal(4), separator: " ")) == "0123 ••••")
        #expect(string2.formatted(.maskedAllExcept(first: 10, count: .equal(4), separator: " ")) == "0123456789 ••••")
    }

    @Test
    func randomAlphanumerics() {
        let result = String.randomAlphanumerics(length: 50)
        #expect(result.count == 50)
    }

    @Test
    func uppercasedFirstAndLowercasedFirst() {
        let input1 = "Hello World"
        #expect(input1.uppercasedFirst() == "Hello World")
        #expect(input1.lowercasedFirst() == "hello World")

        let input2 = "HelloWorld"
        #expect(input2.uppercasedFirst() == "HelloWorld")
        #expect(input2.lowercasedFirst() == "helloWorld")

        let input3 = "helloworld"
        #expect(input3.uppercasedFirst() == "Helloworld")
        #expect(input3.lowercasedFirst() == "helloworld")

        let input4 = "hello world"
        #expect(input4.uppercasedFirst() == "Hello world")
        #expect(input4.lowercasedFirst() == "hello world")
    }

    @Test
    func camelcased() {
        #expect("".camelcased().isEmpty)
        #expect("a".camelcased() == "a")
        #expect("aBC".camelcased() == "aBC")
        #expect("a b".camelcased() == "aB")

        #expect("HELLOWORLD".camelcased() == "helloworld")
        #expect("HELLO_WORLD".camelcased() == "helloWorld")

        #expect("Helloworld".camelcased() == "helloworld")
        #expect("HelloWorld".camelcased() == "helloWorld")
        #expect("Hello World".camelcased() == "helloWorld")
        #expect("Hello World, Greeting".camelcased() == "helloWorldGreeting")
        #expect("Hello World, Greeting 🐶🐮".camelcased() == "helloWorldGreeting")
        #expect("Hello World, Greeting 🐶🐮".snakecased().titlecased().camelcased() == "helloWorldGreeting")
        #expect("TheSwiftProgrammingLanguage".camelcased() == "theSwiftProgrammingLanguage")
    }

    @Test
    func snakecased() {
        #expect("".snakecased().isEmpty)
        #expect("a".snakecased() == "a")
        #expect("aBC".snakecased() == "a_b_c")
        #expect("a b".snakecased() == "a_b")

        #expect("HELLOWORLD".snakecased() == "helloworld")
        #expect("HELLO_WORLD".snakecased() == "hello_world")

        #expect("Helloworld".snakecased() == "helloworld")
        #expect("HelloWorld".snakecased() == "hello_world")
        #expect("hello_world".snakecased() == "hello_world")
        #expect("Hello_World".snakecased() == "hello_world")
        #expect("Hello World".snakecased() == "hello_world")
        #expect("Hello World, Greeting".snakecased() == "hello_world_greeting")
        #expect("Hello World, Greeting 🐶🐮".snakecased() == "hello_world_greeting")
        #expect("Hello World, Greeting 🐶🐮".camelcased().titlecased().snakecased() == "hello_world_greeting")
        #expect("TheSwiftProgrammingLanguage".snakecased() == "the_swift_programming_language")
    }

    @Test
    func titlecased() {
        #expect("".titlecased().isEmpty)
        #expect("a".titlecased() == "A")
        #expect("aBC".titlecased() == "A BC")
        #expect("a b".titlecased() == "A B")

        #expect("HELLOWORLD".titlecased() == "Helloworld")

        #expect("we're having dinner in the garden".titlecased() == "We're Having Dinner In The Garden")
        #expect("TheSwiftProgrammingLanguage".snakecased().replacing("_", with: " ").titlecased() == "The Swift Programming Language")
        #expect("TheSwiftProgrammingLanguage".snakecased().camelcased().titlecased() == "TheSwiftProgrammingLanguage")
    }
}
