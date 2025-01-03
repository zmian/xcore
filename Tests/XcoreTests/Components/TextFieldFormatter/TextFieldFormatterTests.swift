//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct TextFieldFormatterTests {
    @Test
    func phoneNumberFormatterUS() {
        let formatter = PhoneNumberTextFieldFormatter(style: .us)
        let validation = ValidationRule<String>.phoneNumber(length: 11)

        // Country code is always omited
        #expect(formatter.value(from: "18006927753") == "18006927753")
        #expect(formatter.string(from: "18006927753") == "18006927753")
        #expect(formatter.string(from: "18006927753").validate(rule: validation))
        #expect(formatter.string(from: "18006927753").validate(rule: validation) == "18006927753".validate(rule: validation))

        // Display
        #expect(formatter.format("18006927753") == "🇺🇸 +1 (800) 692-7753")
        #expect(formatter.format("8006927753") == "🇺🇸 +1 (800) 692-7753")

        // Test the input as if user is entering it.
        #expect(formatter.format("1") == "🇺🇸 +1")
        #expect(formatter.format("18") == "🇺🇸 +1 (8")
        #expect(formatter.format("180") == "🇺🇸 +1 (80")
        #expect(formatter.format("1800") == "🇺🇸 +1 (800")
        #expect(formatter.format("18006") == "🇺🇸 +1 (800) 6")
        #expect(formatter.format("180069") == "🇺🇸 +1 (800) 69")
        #expect(formatter.format("1800692") == "🇺🇸 +1 (800) 692")
        #expect(formatter.format("18006927") == "🇺🇸 +1 (800) 692-7")
        #expect(formatter.format("180069277") == "🇺🇸 +1 (800) 692-77")
        #expect(formatter.format("1800692775") == "🇺🇸 +1 (800) 692-775")
        #expect(formatter.format("18006927753") == "🇺🇸 +1 (800) 692-7753")

        // Test if country code is repeated it is removed and replaced with correct value (e.g., iOS Autocompletion).
        #expect(formatter.format("118006927753") == "🇺🇸 +1 (800) 692-7753")

        #expect(formatter.unformat("118006927753") == "118006927753")
        #expect(formatter.unformat("18006927753") == "18006927753")
        #expect(formatter.unformat("🇺🇸 +1 (800) 692-7753") == "18006927753")

        // Full loop
        // string(from:) → unformat(_:)  → format(_:)             → unformat(_:)  → value(from:)
        // "18006927753" → "18006927753" → "🇺🇸 +1 (800) 692-7753" → "18006927753" → "18006927753"
        let initialValue = "18006927753"
        let stringValue = formatter.string(from: initialValue)
        let unformattedValue1 = formatter.unformat(stringValue)
        let formattedValue = formatter.format(unformattedValue1)
        let unformattedValue2 = formatter.unformat(formattedValue!)
        let originalValue = formatter.value(from: unformattedValue2)

        #expect(initialValue == "18006927753")
        #expect(stringValue == "18006927753")
        #expect(unformattedValue1 == "18006927753")
        #expect(formattedValue == "🇺🇸 +1 (800) 692-7753")
        #expect(unformattedValue2 == "18006927753")
        #expect(originalValue == "18006927753")
        #expect(originalValue == initialValue)
    }

    @Test
    func phoneNumberFormatterAU() {
        let formatter = PhoneNumberTextFieldFormatter(style: .au)
        let validation = ValidationRule<String>.phoneNumber(length: 11)

        // Country code is always omited
        #expect(formatter.value(from: "61423456789") == "61423456789")
        #expect(formatter.string(from: "61423456789") == "61423456789")
        #expect(formatter.string(from: "61423456789").validate(rule: validation))
        #expect(formatter.string(from: "61423456789").validate(rule: validation) == "61423456789".validate(rule: validation))

        // Display
        #expect(formatter.format("61423456789") == "🇦🇺 +61 423 456 789")
        #expect(formatter.format("423456789") == "🇦🇺 +61 423 456 789")

        // Test the input as if user is entering it.
        #expect(formatter.format("61") == "🇦🇺 +61")
        #expect(formatter.format("614") == "🇦🇺 +61 4")
        #expect(formatter.format("6142") == "🇦🇺 +61 42")
        #expect(formatter.format("61423") == "🇦🇺 +61 423")
        #expect(formatter.format("614234") == "🇦🇺 +61 423 4")
        #expect(formatter.format("6142345") == "🇦🇺 +61 423 45")
        #expect(formatter.format("61423456") == "🇦🇺 +61 423 456")
        #expect(formatter.format("614234567") == "🇦🇺 +61 423 456 7")
        #expect(formatter.format("6142345678") == "🇦🇺 +61 423 456 78")
        #expect(formatter.format("61423456789") == "🇦🇺 +61 423 456 789")

        // Test if country code is repeated it is removed and replaced with correct value (e.g., iOS Autocompletion).
        #expect(formatter.format("6161423456789") == "🇦🇺 +61 423 456 789")

        #expect(formatter.unformat("6161423456789") == "6161423456789")
        #expect(formatter.unformat("61423456789") == "61423456789")
        #expect(formatter.unformat("🇦🇺 +61 423 456 789") == "61423456789")

        // Full loop
        // string(from:) → unformat(_:)  → format(_:)           → unformat(_:)  → value(from:)
        // "61423456789" → "61423456789" → "🇦🇺 +61 423 456 789" → "61423456789" → "61423456789"
        let initialValue = "61423456789"
        let stringValue = formatter.string(from: initialValue)
        let unformattedValue1 = formatter.unformat(stringValue)
        let formattedValue = formatter.format(unformattedValue1)
        let unformattedValue2 = formatter.unformat(formattedValue!)
        let originalValue = formatter.value(from: unformattedValue2)

        #expect(initialValue == "61423456789")
        #expect(stringValue == "61423456789")
        #expect(unformattedValue1 == "61423456789")
        #expect(formattedValue == "🇦🇺 +61 423 456 789")
        #expect(unformattedValue2 == "61423456789")
        #expect(originalValue == "61423456789")
        #expect(originalValue == initialValue)
    }

    @Test
    func doubleNumberFormatter() {
        let formatter = DecimalTextFieldFormatter(isCurrency: false)
        #expect(formatter.value(from: "100") == 100)
        #expect(formatter.value(from: "100.99") == 100.99)
        #expect(formatter.value(from: "100.991") == 100.991)
        #expect(formatter.value(from: "100.") == 100)
        #expect(formatter.string(from: 100.99) == "100.99")
        #expect(formatter.string(from: 100.991) == "100.991")
        #expect(formatter.string(from: 100) == "100")

        // Display
        #expect(formatter.format("100") == "100")
        #expect(formatter.format("100.") == "100.")
        #expect(formatter.format("100.0") == "100.0")
        #expect(formatter.format("100.0123") == "100.0123")
        #expect(formatter.format("1000.0123") == "1,000.0123")
        #expect(formatter.format("1000000.0123") == "1,000,000.0123")
    }

    @Test
    func currencyNumberFormatter() {
        let formatter = DecimalTextFieldFormatter(isCurrency: true)
        #expect(formatter.value(from: "100") == 100)
        #expect(formatter.value(from: "100.99") == 100.99)
        #expect(formatter.value(from: "100.991") == 100.991)
        #expect(formatter.value(from: "100.") == 100)
        #expect(formatter.string(from: 100.99) == "100.99")
        #expect(formatter.string(from: 100.991) == "100.991")
        #expect(formatter.string(from: 100) == "100")

        // Display
        #expect(formatter.format("100") == "$100")
        #expect(formatter.format("100.") == "$100.")
        #expect(formatter.format("100.0") == "$100.0")
        #expect(formatter.format("100.0123") == "$100.01")
        #expect(formatter.format("1000.0123") == "$1,000.01")
        #expect(formatter.format("1000000.0123") == "$1,000,000.01")

        // Full loop
        //              string(from:)  → unformat(_:) → format(_:)      → unformat(_:) → value(from:)
        // 1000000.01 → "1,000,000.01" → "1000000.01" → "$1,000,000.01" → "1000000.01" → 1000000.01
        let initialValue = 1_000_000.01
        let stringValue = formatter.string(from: initialValue)
        let unformattedValue1 = formatter.unformat(stringValue)
        let formattedValue = formatter.format(unformattedValue1)
        let unformattedValue2 = formatter.unformat(formattedValue!)
        let originalValue = formatter.value(from: unformattedValue2)

        #expect(initialValue == 1_000_000.01)
        #expect(stringValue == "1,000,000.01")
        #expect(unformattedValue1 == "1000000.01")
        #expect(formattedValue == "$1,000,000.01")
        #expect(unformattedValue2 == "1000000.01")
        #expect(originalValue == 1_000_000.01)
        #expect(originalValue == initialValue)
    }
}
