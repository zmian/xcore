//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class ValidationRuleTests: TestCase {
    func testEmail() {
        let rule: ValidationRule<String> = .email
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
        let rule: ValidationRule<String> = .ssn

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
        let rule: ValidationRule<String> = .itin

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
        let rule: ValidationRule<String> = .name

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

    func testLogicalOperators() {
        XCTAssertFalse("help@example.com".validate(rule: .ssn && .email))
        XCTAssertTrue("help@example.com".validate(rule: .ssn || .email))
        XCTAssertFalse("help@example.com".validate(rule: !.ssn && !.email))
        XCTAssertTrue("help@example.com".validate(rule: !.ssn && .email))
    }

    func testRange() {
        XCTAssertTrue("John Doe".validate(rule: .range(1...)))
        XCTAssertFalse("secret".validate(rule: .range(8...50)))
        XCTAssertTrue("secret123".validate(rule: .range(8...50)))
    }
}
