//
// ValidationRuleTests.swift
//
// Copyright © 2019 Zeeshan Mian
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

final class ValidationRuleTests: TestCase {
    func testEmail() {
        let rule:  ValidationRule<String> = .email
        XCTAssertTrue("help@example.com".validate(rule: rule))
        XCTAssertTrue("help@gmail.com".validate(rule: rule))
        XCTAssertTrue("help@io.com".validate(rule: rule))
        XCTAssertTrue("help_now@io.com".validate(rule: rule))
        XCTAssertTrue("help.now@io.com".validate(rule: rule))
        XCTAssertTrue("123@example.com".validate(rule: rule))
        XCTAssertFalse("123example.com".validate(rule: rule))
        XCTAssertFalse("123.example.com".validate(rule: rule))
        XCTAssertFalse("123examp".validate(rule: rule))
    }

    func testSSN() {
        let rule:  ValidationRule<String> = .ssn

        // Valid
        XCTAssertTrue("111-11-1111".validate(rule: rule))
        XCTAssertTrue("457-55-5462".validate(rule: rule))
        XCTAssertTrue("657-55-5462".validate(rule: rule))

        // Invalid
        XCTAssertFalse("666-66-666".validate(rule: rule))
        XCTAssertFalse("666-66-6666".validate(rule: rule))
        XCTAssertFalse("957-55-5462".validate(rule: rule)) // Valid ITIN not valid SSN
    }

    func testItin() {
        let rule:  ValidationRule<String> = .itin

        // Valid
        XCTAssertTrue("957-75-5462".validate(rule: rule))
        XCTAssertTrue("900-70-0000".validate(rule: rule))

        // Invalid
        XCTAssertFalse("957-55-5462".validate(rule: rule))
        XCTAssertFalse("666-66-666".validate(rule: rule))
        XCTAssertFalse("666-66-6666".validate(rule: rule))
        XCTAssertFalse("111-11-1111".validate(rule: rule))
        XCTAssertFalse("457-55-5462".validate(rule: rule))
        XCTAssertFalse("657-55-5462".validate(rule: rule))
    }

    func testName() {
        let rule:  ValidationRule<String> = .name

        // Valid
        XCTAssertTrue("Xcore Swift".validate(rule: rule))
        XCTAssertTrue("John Doe".validate(rule: rule))
        XCTAssertTrue("XC".validate(rule: rule))

        // Invalid
        XCTAssertFalse("2".validate(rule: rule))
        XCTAssertFalse("23 John Doe".validate(rule: rule))
        // More than 50 character is invalid name
        XCTAssertFalse("John Doe Fugetaboutit Boaty McBoatface Boaty McBoatface Doe".validate(rule: rule))
    }
}
