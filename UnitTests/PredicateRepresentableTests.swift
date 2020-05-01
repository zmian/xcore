//
// Xcore
// Copyright © 2017 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class PredicateRepresentableTests: TestCase {
    private typealias TestData<OutputType> = (input: String, output: OutputType)

    private func testData(comparator: String) -> [TestData<String>] {
        [
            ("Lowe's", "identifier \(comparator) \"Lowe\'s\""),
            ("Lowes", "identifier \(comparator) \"Lowes\""),
            ("görsel", "identifier \(comparator) \"görsel\""),
            ("Can't Do it", "identifier \(comparator) \"Can\'t Do it\"")
        ]
    }

    func testEqual() {
        for item in testData(comparator: "==") {
            let testNative = NSPredicate(format: "%K == %@", "identifier", item.input).predicateFormat
            let testEqual = NSPredicate(field: "identifier", equal: item.input).predicateFormat
            expect(testNative, ==, item.output)
            expect(testEqual, ==, item.output)
        }
    }

    func testNotEqual() {
        for item in testData(comparator: "!=") {
            let testNative = NSPredicate(format: "identifier != %@", item.input).predicateFormat
            let testNotEqual = NSPredicate(field: "identifier", notEqual: item.input).predicateFormat
            expect(testNative, ==, item.output)
            expect(testNotEqual, ==, item.output)
        }
    }

    func testBetween() {
        let data = ("Can't Do i\t", "Lowe's")
        let expectedOutput = "identifier BETWEEN {\"Can\'t Do i\t\", \"Lowe\'s\"}"

        let result = NSPredicate(field: "identifier", between: data.0, and: data.1).predicateFormat
        expect(result, ==, expectedOutput)
    }
}
