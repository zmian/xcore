//
// PredicateQueryTests.swift
//
// Copyright © 2017 Zeeshan Mian
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

final class PredicateQueryTests: XCTestCase {
    private typealias TestData<OutputType> = (input: String, output: OutputType)

    private func testData(comparator: String) -> [TestData<String>] {
        return [
            ("Lowe's", "identifier \(comparator) \"Lowe\'s\""),
            ("Lowes", "identifier \(comparator) \"Lowes\""),
            ("görsel", "identifier \(comparator) \"görsel\""),
            ("Can't Do i\t", "identifier \(comparator) \"Can\'t Do i\t\"")
        ]
    }

    func testEqual() {
        for item in testData(comparator: "==") {
            let testNative = NSPredicate(format: "identifier == %@", item.input).predicateFormat
            let testEqual = PredicateQuery(field: "identifier", equal: item.input).predicate.predicateFormat
            expect(testNative, ==, item.output)
            expect(testEqual, ==, item.output)
        }
    }

    func testNotEqual() {
        for item in testData(comparator: "!=") {
            let testNative = NSPredicate(format: "identifier != %@", item.input).predicateFormat
            let testNotEqual = PredicateQuery(field: "identifier", notEqual: item.input).predicate.predicateFormat
            expect(testNative, ==, item.output)
            expect(testNotEqual, ==, item.output)
        }
    }

    func testBetween() {
        let data = ("Can't Do i\t", "Lowe's")
        let expectedOutput = "identifier BETWEEN {\"Can\'t Do i\t\", \"Lowe\'s\"}"

        let result = PredicateQuery(field: "identifier", between: data.0, and: data.1).predicate.predicateFormat
        expect(result, ==, expectedOutput)
    }
}
