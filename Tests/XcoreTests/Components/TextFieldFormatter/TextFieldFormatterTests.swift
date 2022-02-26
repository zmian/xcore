//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class TextFieldFormatterTests: TestCase {
    func testPhoneNumberFormatterUS() {
        let formatter = PhoneNumberTextFieldFormatter(style: .us)
        let validation = ValidationRule<String>.phoneNumber(length: 11)

        // Country code is always omited
        XCTAssertEqual(formatter.value(from: "18006927753"), "18006927753")
        XCTAssertEqual(formatter.string(from: "18006927753"), "18006927753")
        XCTAssertTrue(formatter.string(from: "18006927753").validate(rule: validation))
        XCTAssertEqual(formatter.string(from: "18006927753").validate(rule: validation), "18006927753".validate(rule: validation))

        // Display
        XCTAssertEqual(formatter.format("18006927753"), "🇺🇸 +1 (800) 692-7753")
        XCTAssertEqual(formatter.format("8006927753"), "🇺🇸 +1 (800) 692-7753")

        // Test the input as if user is entering it.
        XCTAssertEqual(formatter.format("1"), "🇺🇸 +1")
        XCTAssertEqual(formatter.format("18"), "🇺🇸 +1 (8")
        XCTAssertEqual(formatter.format("180"), "🇺🇸 +1 (80")
        XCTAssertEqual(formatter.format("1800"), "🇺🇸 +1 (800")
        XCTAssertEqual(formatter.format("18006"), "🇺🇸 +1 (800) 6")
        XCTAssertEqual(formatter.format("180069"), "🇺🇸 +1 (800) 69")
        XCTAssertEqual(formatter.format("1800692"), "🇺🇸 +1 (800) 692")
        XCTAssertEqual(formatter.format("18006927"), "🇺🇸 +1 (800) 692-7")
        XCTAssertEqual(formatter.format("180069277"), "🇺🇸 +1 (800) 692-77")
        XCTAssertEqual(formatter.format("1800692775"), "🇺🇸 +1 (800) 692-775")
        XCTAssertEqual(formatter.format("18006927753"), "🇺🇸 +1 (800) 692-7753")

        // Test if country code is repeated it is removed and replaced with correct value (e.g., iOS Autocompletion).
        XCTAssertEqual(formatter.format("118006927753"), "🇺🇸 +1 (800) 692-7753")

        XCTAssertEqual(formatter.unformat("118006927753"), "118006927753")
        XCTAssertEqual(formatter.unformat("18006927753"), "18006927753")
        XCTAssertEqual(formatter.unformat("🇺🇸 +1 (800) 692-7753"), "18006927753")

        // Full loop
        // string(from:) → unformat(_:)  → format(_:)             → unformat(_:)  → value(from:)
        // "18006927753" → "18006927753" → "🇺🇸 +1 (800) 692-7753" → "18006927753" → "18006927753"
        let initialValue = "18006927753"
        let stringValue = formatter.string(from: initialValue)
        let unformattedValue1 = formatter.unformat(stringValue)
        let formattedValue = formatter.format(unformattedValue1)
        let unformattedValue2 = formatter.unformat(formattedValue!)
        let originalValue = formatter.value(from: unformattedValue2)

        XCTAssertEqual(initialValue, "18006927753")
        XCTAssertEqual(stringValue, "18006927753")
        XCTAssertEqual(unformattedValue1, "18006927753")
        XCTAssertEqual(formattedValue, "🇺🇸 +1 (800) 692-7753")
        XCTAssertEqual(unformattedValue2, "18006927753")
        XCTAssertEqual(originalValue, "18006927753")
        XCTAssertEqual(originalValue, initialValue)
    }

    func testPhoneNumberFormatterAU() {
        let formatter = PhoneNumberTextFieldFormatter(style: .au)
        let validation = ValidationRule<String>.phoneNumber(length: 11)

        // Country code is always omited
        XCTAssertEqual(formatter.value(from: "61423456789"), "61423456789")
        XCTAssertEqual(formatter.string(from: "61423456789"), "61423456789")
        XCTAssertTrue(formatter.string(from: "61423456789").validate(rule: validation))
        XCTAssertEqual(formatter.string(from: "61423456789").validate(rule: validation), "61423456789".validate(rule: validation))

        // Display
        XCTAssertEqual(formatter.format("61423456789"), "🇦🇺 +61 423 456 789")
        XCTAssertEqual(formatter.format("423456789"), "🇦🇺 +61 423 456 789")

        // Test the input as if user is entering it.
        XCTAssertEqual(formatter.format("61"), "🇦🇺 +61")
        XCTAssertEqual(formatter.format("614"), "🇦🇺 +61 4")
        XCTAssertEqual(formatter.format("6142"), "🇦🇺 +61 42")
        XCTAssertEqual(formatter.format("61423"), "🇦🇺 +61 423")
        XCTAssertEqual(formatter.format("614234"), "🇦🇺 +61 423 4")
        XCTAssertEqual(formatter.format("6142345"), "🇦🇺 +61 423 45")
        XCTAssertEqual(formatter.format("61423456"), "🇦🇺 +61 423 456")
        XCTAssertEqual(formatter.format("614234567"), "🇦🇺 +61 423 456 7")
        XCTAssertEqual(formatter.format("6142345678"), "🇦🇺 +61 423 456 78")
        XCTAssertEqual(formatter.format("61423456789"), "🇦🇺 +61 423 456 789")

        // Test if country code is repeated it is removed and replaced with correct value (e.g., iOS Autocompletion).
        XCTAssertEqual(formatter.format("6161423456789"), "🇦🇺 +61 423 456 789")

        XCTAssertEqual(formatter.unformat("6161423456789"), "6161423456789")
        XCTAssertEqual(formatter.unformat("61423456789"), "61423456789")
        XCTAssertEqual(formatter.unformat("🇦🇺 +61 423 456 789"), "61423456789")

        // Full loop
        // string(from:) → unformat(_:)  → format(_:)           → unformat(_:)  → value(from:)
        // "61423456789" → "61423456789" → "🇦🇺 +61 423 456 789" → "61423456789" → "61423456789"
        let initialValue = "61423456789"
        let stringValue = formatter.string(from: initialValue)
        let unformattedValue1 = formatter.unformat(stringValue)
        let formattedValue = formatter.format(unformattedValue1)
        let unformattedValue2 = formatter.unformat(formattedValue!)
        let originalValue = formatter.value(from: unformattedValue2)

        XCTAssertEqual(initialValue, "61423456789")
        XCTAssertEqual(stringValue, "61423456789")
        XCTAssertEqual(unformattedValue1, "61423456789")
        XCTAssertEqual(formattedValue, "🇦🇺 +61 423 456 789")
        XCTAssertEqual(unformattedValue2, "61423456789")
        XCTAssertEqual(originalValue, "61423456789")
        XCTAssertEqual(originalValue, initialValue)
    }

    func testDoubleNumberFormatter() {
        let formatter = DecimalTextFieldFormatter(isCurrency: false)
        XCTAssertEqual(formatter.value(from: "100"), 100)
        XCTAssertEqual(formatter.value(from: "100.99"), 100.99)
        XCTAssertEqual(formatter.value(from: "100.991"), 100.991)
        XCTAssertEqual(formatter.value(from: "100."), 100)
        XCTAssertEqual(formatter.string(from: 100.99), "100.99")
        XCTAssertEqual(formatter.string(from: 100.991), "100.991")
        XCTAssertEqual(formatter.string(from: 100), "100")

        // Display
        XCTAssertEqual(formatter.format("100"), "100")
        XCTAssertEqual(formatter.format("100."), "100.")
        XCTAssertEqual(formatter.format("100.0"), "100.0")
        XCTAssertEqual(formatter.format("100.0123"), "100.0123")
        XCTAssertEqual(formatter.format("1000.0123"), "1,000.0123")
        XCTAssertEqual(formatter.format("1000000.0123"), "1,000,000.0123")
    }

    func testCurrencyNumberFormatter() {
        let formatter = DecimalTextFieldFormatter(isCurrency: true)
        XCTAssertEqual(formatter.value(from: "100"), 100)
        XCTAssertEqual(formatter.value(from: "100.99"), 100.99)
        XCTAssertEqual(formatter.value(from: "100.991"), 100.991)
        XCTAssertEqual(formatter.value(from: "100."), 100)
        XCTAssertEqual(formatter.string(from: 100.99), "100.99")
        XCTAssertEqual(formatter.string(from: 100.991), "100.991")
        XCTAssertEqual(formatter.string(from: 100), "100")

        // Display
        XCTAssertEqual(formatter.format("100"), "$100")
        XCTAssertEqual(formatter.format("100."), "$100.")
        XCTAssertEqual(formatter.format("100.0"), "$100.0")
        XCTAssertEqual(formatter.format("100.0123"), "$100.01")
        XCTAssertEqual(formatter.format("1000.0123"), "$1,000.01")
        XCTAssertEqual(formatter.format("1000000.0123"), "$1,000,000.01")

        // Full loop
        //              string(from:)  → unformat(_:) → format(_:)      → unformat(_:) → value(from:)
        // 1000000.01 → "1,000,000.01" → "1000000.01" → "$1,000,000.01" → "1000000.01" → 1000000.01
        let initialValue = 1000000.01
        let stringValue = formatter.string(from: initialValue)
        let unformattedValue1 = formatter.unformat(stringValue)
        let formattedValue = formatter.format(unformattedValue1)
        let unformattedValue2 = formatter.unformat(formattedValue!)
        let originalValue = formatter.value(from: unformattedValue2)

        XCTAssertEqual(initialValue, 1000000.01)
        XCTAssertEqual(stringValue, "1,000,000.01")
        XCTAssertEqual(unformattedValue1, "1000000.01")
        XCTAssertEqual(formattedValue, "$1,000,000.01")
        XCTAssertEqual(unformattedValue2, "1000000.01")
        XCTAssertEqual(originalValue, 1000000.01)
        XCTAssertEqual(originalValue, initialValue)
    }
}
