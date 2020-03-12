//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class StringConverterTests: TestCase {
    func testGetValue() {
        XCTAssert(ConvertItem.validBool.value(default: false) == true)
        XCTAssert(ConvertItem.invalidBool.value(default: false) == false)

        XCTAssert(ConvertItem.validInt.value(default: 0) == Int(1213))
        XCTAssert(ConvertItem.invalidInt.value(default: 0) == Int(0))

        XCTAssert(ConvertItem.validFloat.value(default: 0) == Float(20.34))
        XCTAssert(ConvertItem.invalidFloat.value(default: 0) == Float(0))

        XCTAssert(ConvertItem.validDouble.value(default: 0) == Double(100.76))
        XCTAssert(ConvertItem.invalidDouble.value(default: 0) == Double(0))

        XCTAssert(ConvertItem.validNsNumber.value(default: NSNumber(value: 0)) == NSNumber(value: 10))
        XCTAssert(ConvertItem.invalidNsNumber.value(default: NSNumber(value: 0)) == NSNumber(value: 0))

        let defaultUrl = URL(string: "https://github.com/zmian/xcore.swift")!
        XCTAssert(ConvertItem.validUrl.value(default: defaultUrl) == URL(string: "https://swift.org/")!)
        XCTAssert(ConvertItem.invalidUrl.value(default: defaultUrl) == defaultUrl)

        let defaultString = "hello world"
        XCTAssert(ConvertItem.validString.value(default: defaultString) == "dark")
        XCTAssert(ConvertItem.invalidString.value(default: defaultString) == defaultString)

        let defaultNsString = NSString("greeting world")
        XCTAssert(ConvertItem.validNsString.value(default: defaultNsString) == NSString("darker"))
        XCTAssert(ConvertItem.invalidNsString.value(default: defaultNsString) == defaultNsString)

        let defaultArray: [String] = ["swift", "objc"]
        XCTAssert(ConvertItem.validArray.value(default: defaultArray) == ["red", "blue", "green"])
        XCTAssert(ConvertItem.invalidArray.value(default: defaultArray) == defaultArray)

        let validDictionary = [
            "name": "zmian",
            "framework": "Xcore",
            "language": "Swift"
        ]

        let defaultDictionary: [String: String] = ["hello": "world"]
        XCTAssert(ConvertItem.validDictionary.value(default: defaultDictionary) == validDictionary)
        XCTAssert(ConvertItem.invalidDictionary.value(default: defaultDictionary) == defaultDictionary)

        let expectedValueDark = ConvertItem.validRawRepresentable.value(default: TestTheme.light)
        let shouldBeDarkTheme = expectedValueDark == .dark
        XCTAssert(shouldBeDarkTheme)

        let expectedValueLight = ConvertItem.invalidRawRepresentable1.value(default: TestTheme.light)
        let shouldBeLightTheme = expectedValueLight == .light
        XCTAssert(shouldBeLightTheme)

        let expectedValueDark2 = ConvertItem.invalidRawRepresentable2.value(default: TestTheme.dark)
        let shouldBeDarkTheme2 = expectedValueDark2 == .dark
        XCTAssert(shouldBeDarkTheme2)
    }
}

// MARK: - ConvertValue

private struct ConvertValue {
    private var storage: [ConvertItem: Any] = [:]

    init() {
        let dictionaryExample = """
        {
            "name": "zmian",
            "framework": "Xcore",
            "language": "Swift"
        }
        """

        let arraryExample = """
        ["red", "blue", "green"]
        """

        storage[.validBool] = true
        storage[.invalidBool] = "no"

        storage[.validInt] = 1213
        storage[.invalidInt] = "two"

        storage[.validFloat] = 20.34
        storage[.invalidFloat] = "two"

        storage[.validDouble] = 100.76
        storage[.invalidDouble] = "two"

        storage[.validNsNumber] = NSNumber(value: 10)
        storage[.invalidNsNumber] = "hello world"

        storage[.validUrl] = "https://swift.org/"
        storage[.invalidUrl] = "hello world"

        storage[.validString] = "dark"
        storage[.invalidString] = InvalidString()

        storage[.validNsString] = NSString("darker")
        storage[.invalidNsString] = InvalidString()

        storage[.validArray] = arraryExample
        storage[.invalidArray] = dictionaryExample

        storage[.validDictionary] = dictionaryExample
        storage[.invalidDictionary] = ""

        storage[.validRawRepresentable] = "dark"
        storage[.invalidRawRepresentable1] = "not dark"
        storage[.invalidRawRepresentable2] = 232
    }

    func value(for item: ConvertItem) -> StringConverter? {
        StringConverter(storage[item]!)
    }

    struct InvalidString { }
}

// MARK: - ConvertItem

private enum ConvertItem: String {
    case validBool
    case invalidBool

    case validInt
    case invalidInt

    case validFloat
    case invalidFloat

    case validDouble
    case invalidDouble

    case validNsNumber
    case invalidNsNumber

    case validUrl
    case invalidUrl

    case validString
    case invalidString

    case validNsString
    case invalidNsString

    case validArray
    case invalidArray

    case validDictionary
    case invalidDictionary

    case validRawRepresentable
    case invalidRawRepresentable1
    case invalidRawRepresentable2
}

// MARK: - ConvertItem

extension ConvertItem {
    fileprivate var storageValue: StringConverter? {
        ConvertValue().value(for: self)
    }

    fileprivate func value<T>(default defaultValue: @autoclosure () -> T) -> T {
        storageValue?.get() ?? defaultValue()
    }

    fileprivate func value<T>(default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        storageValue?.get() ?? defaultValue()
    }
}

// MARK: - TestFeature

private enum TestTheme: String {
    case dark
    case light
}
