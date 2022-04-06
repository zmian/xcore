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

    func testPostalCode() {
        let rule: ValidationRule<String> = .postalCode

        // Valid
        XCTAssertTrue("12345".validate(rule: rule))
        XCTAssertTrue("123456789".validate(rule: rule))
        XCTAssertTrue("12345-6789".validate(rule: rule))

        // Invalid
        XCTAssertFalse("1234".validate(rule: rule))
        XCTAssertFalse("123 4".validate(rule: rule))
        XCTAssertFalse("123 45".validate(rule: rule))
        XCTAssertFalse("1234567890".validate(rule: rule))
    }

    func testContainsPoBox() {
        let rule: ValidationRule<String> = .containsPoBox

        // Valid
        XCTAssertTrue("957-75-5462 P.O. Box".validate(rule: rule))
        XCTAssertTrue("1 P.O. Box".validate(rule: rule))
        XCTAssertTrue("2 P.O.Box".validate(rule: rule))
        XCTAssertTrue("3 PO.Box".validate(rule: rule))
        XCTAssertTrue("4 POBox".validate(rule: rule))
        XCTAssertTrue("4 PO Box".validate(rule: rule))
        XCTAssertTrue("4 P.O Box".validate(rule: rule))
        XCTAssertTrue("4 P.O. Box".validate(rule: rule))
        XCTAssertTrue("4 POST OFFICE Box".validate(rule: rule))

        // Strict words
        XCTAssertTrue("POST OFFICE Box".validate(rule: rule))
        XCTAssertTrue("post office box".validate(rule: rule))
        XCTAssertTrue("PO Box".validate(rule: rule))
        XCTAssertTrue("po box".validate(rule: rule))
        XCTAssertTrue("P.O. Box".validate(rule: rule))
        XCTAssertTrue("p.o. box".validate(rule: rule))
        XCTAssertTrue("P.O. box".validate(rule: rule))
        XCTAssertTrue("P.O.Box".validate(rule: rule))
        XCTAssertTrue("p.o.box".validate(rule: rule))
        XCTAssertTrue("p.o. box 1033".validate(rule: rule))
        XCTAssertTrue("P.O. Box 1033".validate(rule: rule))
        XCTAssertTrue("p.o.box 1033".validate(rule: rule))
        XCTAssertTrue("P.O.Box 1033".validate(rule: rule))
        XCTAssertTrue("P.O.Box 1033 ".validate(rule: rule))
        XCTAssertTrue(" P.O.Box 1033".validate(rule: rule))

        // Does not contain P.O. Box
        XCTAssertFalse("1 Apple Park Way".validate(rule: rule))
        XCTAssertFalse("1 Office Way".validate(rule: rule))
        XCTAssertFalse("1 Infinite Loop; Cupertino, CA 95014".validate(rule: rule))
        XCTAssertFalse("1 Infinite Loop".validate(rule: rule))

        let not_a_p_o_box = [
            "The Postal Road",
            "The Postal Office Road",
            "Box Hill",
            "123 Some Street",
            "Controller's Office",
            "pollo St.",
            "123 box canyon rd",
            "777 Post Oak Blvd",
            "PSC 477 Box 396",
            "RR 1 Box 1020",
            "Coop services",
            "65 Brook Ave Ste 1P",
            "pacific city",
            "orange county",
            "obox",
            "pbox",
            "party house",
            "p shorty",
            "something pacif pobo",
            "po helpkline box",
            "po ferrirs",
            "panther boxing",
            "box center",
            "post office",
            "Post",
            "porceline"
        ]

        for address in not_a_p_o_box {
            XCTAssertFalse(address.validate(rule: rule), "\(address)")
        }

        let p_o_box = [
            "post office box",
            "POBOX",
            "P.o-bOX",
            "po box",
            "POBox12234",
            "p o box",
            "P.O.Box",
            "HC73 P.O. Box 217",
            "P O Box125",
            "P. O. Box",
            "P.O. Box 123",
            "P.O. Box",
            "PO Box N",
            "PO Box",
            "PO-Box",
            "POBOX123",
            "Po Box",
            "Post Box 123",
            "Post Office Box 123",
            "Post Office Box",
            "p box",
            "p-o box",
            "p-o-box",
            "p.o box",
            "p.o. box",
            "p.o.-box",
            "po box 123",
            "po box",
            "po-box",
            "pobox",
            "pobox123"
        ]

        for address in p_o_box {
            XCTAssertTrue(address.validate(rule: rule), "\(address)")
        }
    }

    func testName() {
        let rule: ValidationRule<String> = .name

        // Valid
        XCTAssertTrue("Xcore Swift".validate(rule: rule))
        XCTAssertTrue("John Doe".validate(rule: rule))
        XCTAssertTrue("XC".validate(rule: rule))
        XCTAssertTrue("Z".validate(rule: rule))

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

    func testCount() {
        XCTAssertTrue("1234".validate(rule: .count(4)))
        XCTAssertTrue("s123".validate(rule: .count(4)))
        XCTAssertFalse("1234".validate(rule: .count(3)))
        XCTAssertFalse("1234".validate(rule: .count(50)))

        XCTAssertTrue("1234".validate(rule: .number(count: 4)))
        XCTAssertFalse("s123".validate(rule: .number(count: 4)))
        XCTAssertFalse("1234".validate(rule: .number(count: 3)))
        XCTAssertFalse("1234".validate(rule: .number(count: 50)))
    }

    func testDataDector() {
        XCTAssertTrue("http://example.com".validate(rule: .isValid(.link)))
        XCTAssertTrue("https://example.com".validate(rule: .isValid(.link)))
        XCTAssertTrue("example.com".validate(rule: .isValid(.link)))
        XCTAssertTrue("www.example.com".validate(rule: .isValid(.link)))
        XCTAssertFalse("example".validate(rule: .isValid(.link)))
        XCTAssertFalse("http:www.example.com".validate(rule: .isValid(.link)))
        XCTAssertTrue("www.example.com/file[/].html".validate(rule: .isValid(.link)))
        XCTAssertFalse("https://example.com".validate(rule: .isValid(.phoneNumber)))

        XCTAssertTrue("(800) MY–APPLE".validate(rule: .isValid(.phoneNumber)))
    }
}
