//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class TextFieldFormatterTests: TestCase {
    func testPhoneNumberFormatter() {
        let formatter = PhoneNumberTextFieldFormatter(style: .us)
        let validation = ValidationRule<String>.phoneNumber(length: 10)

        // Country code is always omited
        XCTAssertEqual(formatter.transformToValue("18006927753"), "8006927753")
        XCTAssertEqual(formatter.transformToString("18006927753"), "8006927753")
        XCTAssertTrue(formatter.transformToString("18006927753").validate(rule: validation))
        XCTAssertEqual(formatter.transformToString("18006927753").validate(rule: validation), "8006927753".validate(rule: validation))

        // Display
        XCTAssertEqual(formatter.displayValue(from: "18006927753"), "🇺🇸 +1 (800) 692-7753")
        XCTAssertEqual(formatter.displayValue(from: "8006927753"), "🇺🇸 +1 (800) 692-7753")

        // Test the input as if user is entering it.
        XCTAssertEqual(formatter.displayValue(from: "1"), "🇺🇸 +1")
        XCTAssertEqual(formatter.displayValue(from: "18"), "🇺🇸 +1 (8")
        XCTAssertEqual(formatter.displayValue(from: "180"), "🇺🇸 +1 (80")
        XCTAssertEqual(formatter.displayValue(from: "1800"), "🇺🇸 +1 (800")
        XCTAssertEqual(formatter.displayValue(from: "18006"), "🇺🇸 +1 (800) 6")
        XCTAssertEqual(formatter.displayValue(from: "180069"), "🇺🇸 +1 (800) 69")
        XCTAssertEqual(formatter.displayValue(from: "1800692"), "🇺🇸 +1 (800) 692")
        XCTAssertEqual(formatter.displayValue(from: "18006927"), "🇺🇸 +1 (800) 692-7")
        XCTAssertEqual(formatter.displayValue(from: "180069277"), "🇺🇸 +1 (800) 692-77")
        XCTAssertEqual(formatter.displayValue(from: "1800692775"), "🇺🇸 +1 (800) 692-775")
        XCTAssertEqual(formatter.displayValue(from: "18006927753"), "🇺🇸 +1 (800) 692-7753")

        // Test if country code is repeated it is removed and replaced with correct value (e.g., iOS Autocompletion).
        XCTAssertEqual(formatter.displayValue(from: "118006927753"), "🇺🇸 +1 (800) 692-7753")

        XCTAssertEqual(formatter.sanitizeDisplayValue(from: "118006927753"), "118006927753")
        XCTAssertEqual(formatter.sanitizeDisplayValue(from: "18006927753"), "18006927753")
        XCTAssertEqual(formatter.sanitizeDisplayValue(from: "🇺🇸 +1 (800) 692-7753"), "18006927753")
    }

    func testDoubleNumberFormatter() {
        let formatter = DecimalTextFieldFormatter(isCurrency: false, isEmptyZero: true)
        XCTAssertEqual(formatter.transformToValue("100"), 100)
        XCTAssertEqual(formatter.transformToValue("100.99"), 100.99)
        XCTAssertEqual(formatter.transformToValue("100.991"), 100.991)
        XCTAssertEqual(formatter.transformToValue("100."), 100)
        XCTAssertEqual(formatter.transformToString(100.99), "100.99")
        XCTAssertEqual(formatter.transformToString(100.991), "100.991")
        XCTAssertEqual(formatter.transformToString(100), "100")

        // Display
        XCTAssertEqual(formatter.displayValue(from: "100"), "100")
        XCTAssertEqual(formatter.displayValue(from: "100."), "100.")
        XCTAssertEqual(formatter.displayValue(from: "100.0"), "100.0")
        XCTAssertEqual(formatter.displayValue(from: "100.0123"), "100.0123")
        XCTAssertEqual(formatter.displayValue(from: "1000.0123"), "1,000.0123")
        XCTAssertEqual(formatter.displayValue(from: "1000000.0123"), "1,000,000.0123")
    }

    func testCurrencyNumberFormatter() {
        let formatter = DecimalTextFieldFormatter(isCurrency: true, isEmptyZero: true)
        XCTAssertEqual(formatter.transformToValue("100"), 100)
        XCTAssertEqual(formatter.transformToValue("100.99"), 100.99)
        XCTAssertEqual(formatter.transformToValue("100.991"), 100.991)
        XCTAssertEqual(formatter.transformToValue("100."), 100)
        XCTAssertEqual(formatter.transformToString(100.99), "100.99")
        XCTAssertEqual(formatter.transformToString(100.991), "100.991")
        XCTAssertEqual(formatter.transformToString(100), "100")

        // Display
        XCTAssertEqual(formatter.displayValue(from: "100"), "$100")
        XCTAssertEqual(formatter.displayValue(from: "100."), "$100.")
        XCTAssertEqual(formatter.displayValue(from: "100.0"), "$100.0")
        XCTAssertEqual(formatter.displayValue(from: "100.0123"), "$100.01")
        XCTAssertEqual(formatter.displayValue(from: "1000.0123"), "$1,000.01")
        XCTAssertEqual(formatter.displayValue(from: "1000000.0123"), "$1,000,000.01")
    }
}
