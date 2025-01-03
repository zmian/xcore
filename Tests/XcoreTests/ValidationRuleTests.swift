//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct ValidationRuleTests {
    @Test
    func email() {
        let rule: ValidationRule<String> = .email
        #expect("help@example.com".validate(rule: rule))
        #expect("help@gmail.com".validate(rule: rule))
        #expect("help@io.com".validate(rule: rule))
        #expect("help_now@io.com".validate(rule: rule))
        #expect("help.now@io.com".validate(rule: rule))
        #expect("123@example.com".validate(rule: rule))
        #expect(!"123example.com".validate(rule: rule))
        #expect(!"123.example.com".validate(rule: rule))
        #expect(!"123examp".validate(rule: rule))
    }

    @Test
    func ssn() {
        let rule: ValidationRule<String> = .ssn

        // Valid
        #expect("111-11-1111".validate(rule: rule))
        #expect("457-55-5462".validate(rule: rule))
        #expect("657-55-5462".validate(rule: rule))

        // Invalid
        #expect(!"666-66-666".validate(rule: rule))
        #expect(!"666-66-6666".validate(rule: rule))
        #expect(!"957-55-5462".validate(rule: rule)) // Valid ITIN not valid SSN
    }

    @Test
    func itin() {
        let rule: ValidationRule<String> = .itin

        // Valid
        #expect("957-75-5462".validate(rule: rule))
        #expect("900-70-0000".validate(rule: rule))

        // Invalid
        #expect(!"957-55-5462".validate(rule: rule))
        #expect(!"666-66-666".validate(rule: rule))
        #expect(!"666-66-6666".validate(rule: rule))
        #expect(!"111-11-1111".validate(rule: rule))
        #expect(!"457-55-5462".validate(rule: rule))
        #expect(!"657-55-5462".validate(rule: rule))
    }

    @Test
    func postalCode() {
        let rule: ValidationRule<String> = .postalCode

        // Valid
        #expect("12345".validate(rule: rule))
        #expect("123456789".validate(rule: rule))
        #expect("12345-6789".validate(rule: rule))

        // Invalid
        #expect(!"1234".validate(rule: rule))
        #expect(!"123 4".validate(rule: rule))
        #expect(!"123 45".validate(rule: rule))
        #expect(!"1234567890".validate(rule: rule))
    }

    @Test
    func containsPoBox() {
        let rule: ValidationRule<String> = .containsPoBox

        // Valid
        #expect("957-75-5462 P.O. Box".validate(rule: rule))
        #expect("1 P.O. Box".validate(rule: rule))
        #expect("2 P.O.Box".validate(rule: rule))
        #expect("3 PO.Box".validate(rule: rule))
        #expect("4 POBox".validate(rule: rule))
        #expect("4 PO Box".validate(rule: rule))
        #expect("4 P.O Box".validate(rule: rule))
        #expect("4 P.O. Box".validate(rule: rule))
        #expect("4 POST OFFICE Box".validate(rule: rule))

        // Strict words
        #expect("POST OFFICE Box".validate(rule: rule))
        #expect("post office box".validate(rule: rule))
        #expect("PO Box".validate(rule: rule))
        #expect("po box".validate(rule: rule))
        #expect("P.O. Box".validate(rule: rule))
        #expect("p.o. box".validate(rule: rule))
        #expect("P.O. box".validate(rule: rule))
        #expect("P.O.Box".validate(rule: rule))
        #expect("p.o.box".validate(rule: rule))
        #expect("p.o. box 1033".validate(rule: rule))
        #expect("P.O. Box 1033".validate(rule: rule))
        #expect("p.o.box 1033".validate(rule: rule))
        #expect("P.O.Box 1033".validate(rule: rule))
        #expect("P.O.Box 1033 ".validate(rule: rule))
        #expect(" P.O.Box 1033".validate(rule: rule))

        // Does not contain P.O. Box
        #expect(!"1 Apple Park Way".validate(rule: rule))
        #expect(!"1 Office Way".validate(rule: rule))
        #expect(!"1 Infinite Loop; Cupertino, CA 95014".validate(rule: rule))
        #expect(!"1 Infinite Loop".validate(rule: rule))

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
            #expect(!address.validate(rule: rule), "\(address)")
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
            #expect(address.validate(rule: rule), "\(address)")
        }
    }

    @Test
    func name() {
        let rule: ValidationRule<String> = .name

        // Valid
        #expect("Xcore Swift".validate(rule: rule))
        #expect("Sam Swift".validate(rule: rule))
        #expect("XC".validate(rule: rule))
        #expect("Z".validate(rule: rule))

        // Invalid
        #expect(!"2".validate(rule: rule))
        #expect(!"23 Sam Swift".validate(rule: rule))
        // More than 50 character is invalid name
        #expect(!"Sam Swift Fugetaboutit Boaty McBoatface Boaty McBoatface Doe".validate(rule: rule))
    }

    @Test
    func logicalOperators() {
        #expect(!"help@example.com".validate(rule: .ssn && .email))
        #expect("help@example.com".validate(rule: .ssn || .email))
        #expect(!"help@example.com".validate(rule: !.ssn && !.email))
        #expect("help@example.com".validate(rule: !.ssn && .email))
    }

    @Test
    func range() {
        #expect("Sam Swift".validate(rule: .range(1...)))
        #expect(!"secret".validate(rule: .range(8...50)))
        #expect("secret123".validate(rule: .range(8...50)))
    }

    @Test
    func count() {
        #expect("1234".validate(rule: .count(4)))
        #expect("s123".validate(rule: .count(4)))
        #expect(!"1234".validate(rule: .count(3)))
        #expect(!"1234".validate(rule: .count(50)))

        #expect("1234".validate(rule: .number(count: 4)))
        #expect(!"s123".validate(rule: .number(count: 4)))
        #expect(!"1234".validate(rule: .number(count: 3)))
        #expect(!"1234".validate(rule: .number(count: 50)))
    }

    @Test
    func dataDetector() {
        #expect("http://example.com".validate(rule: .isValid(.link)))
        #expect("https://example.com".validate(rule: .isValid(.link)))
        #expect("example.com".validate(rule: .isValid(.link)))
        #expect("www.example.com".validate(rule: .isValid(.link)))
        #expect(!"example".validate(rule: .isValid(.link)))
        #expect(!"http:www.example.com".validate(rule: .isValid(.link)))
        #expect("www.example.com/file[/].html".validate(rule: .isValid(.link)))
        #expect(!"https://example.com".validate(rule: .isValid(.phoneNumber)))

        #expect("(800) MY–APPLE".validate(rule: .isValid(.phoneNumber)))
    }
}
