//
//  PredicateQueryTests.swift
//  Xcore
//
//  Created by Zeeshan Mian on 4/8/17.
//  Copyright © 2017 Xcore. All rights reserved.
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
