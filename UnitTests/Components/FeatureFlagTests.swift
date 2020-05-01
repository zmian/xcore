//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class FeatureFlagTests: TestCase {
    func testGetValue() {
        XCTAssert(TestFeature.flag(.validBool).value(default: false) == true)
        XCTAssert(TestFeature.flag(.invalidBool).value(default: false) == false)

        XCTAssert(TestFeature.flag(.validInt).value(default: 0) == Int(1213))
        XCTAssert(TestFeature.flag(.invalidInt).value(default: 0) == Int(0))

        XCTAssert(TestFeature.flag(.validFloat).value(default: 0) == Float(20.34))
        XCTAssert(TestFeature.flag(.invalidFloat).value(default: 0) == Float(0))

        XCTAssert(TestFeature.flag(.validDouble).value(default: 0) == Double(100.76))
        XCTAssert(TestFeature.flag(.invalidDouble).value(default: 0) == Double(0))

        let defaultUrl = URL(string: "https://github.com/zmian/xcore.swift")!
        XCTAssert(TestFeature.flag(.validUrl).value(default: defaultUrl) == URL(string: "https://swift.org/")!)
        XCTAssert(TestFeature.flag(.invalidUrl).value(default: defaultUrl) == defaultUrl)

        let defaultString = "hello world"
        XCTAssert(TestFeature.flag(.validString).value(default: defaultString) == "dark")
        XCTAssert(TestFeature.flag(.invalidString).value(default: defaultString) == defaultString)

        let defaultArray: [String] = ["swift", "objc"]
        XCTAssert(TestFeature.flag(.validArray).value(default: defaultArray) == ["red", "blue", "green"])
        XCTAssert(TestFeature.flag(.invalidArray).value(default: defaultArray) == defaultArray)

        let validDictionary = [
            "name": "zmian",
            "framework": "Xcore",
            "language": "Swift"
        ]

        let defaultDictionary: [String: String] = ["hello": "world"]
        XCTAssert(TestFeature.flag(.validDictionary).value(default: defaultDictionary) == validDictionary)
        XCTAssert(TestFeature.flag(.invalidDictionary).value(default: defaultDictionary) == defaultDictionary)

        let expectedValueDark = TestFeature.flag(.validRawRepresentable).value(default: TestTheme.light)
        let shouldBeDarkTheme = expectedValueDark == .dark
        XCTAssert(shouldBeDarkTheme)

        let expectedValueLight = TestFeature.flag(.invalidRawRepresentable1).value(default: TestTheme.light)
        let shouldBeLightTheme = expectedValueLight == .light
        XCTAssert(shouldBeLightTheme)

        let expectedValueDark2 = TestFeature.flag(.invalidRawRepresentable2).value(default: TestTheme.dark)
        let shouldBeDarkTheme2 = expectedValueDark2 == .dark
        XCTAssert(shouldBeDarkTheme2)
    }
}

// MARK: - CustomFeatureFlag

private struct CustomFeatureFlag: FeatureFlagProvider {
    private var storage: [String: Any] = [:]

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

        storage[FeatureFlagItem.validBool.rawValue] = true
        storage[FeatureFlagItem.invalidBool.rawValue] = "no"

        storage[FeatureFlagItem.validInt.rawValue] = 1213
        storage[FeatureFlagItem.invalidInt.rawValue] = "two"

        storage[FeatureFlagItem.validFloat.rawValue] = 20.34
        storage[FeatureFlagItem.invalidFloat.rawValue] = "two"

        storage[FeatureFlagItem.validDouble.rawValue] = 100.76
        storage[FeatureFlagItem.invalidDouble.rawValue] = "two"

        storage[FeatureFlagItem.validUrl.rawValue] = "https://swift.org/"
        storage[FeatureFlagItem.invalidUrl.rawValue] = "hello world"

        storage[FeatureFlagItem.validString.rawValue] = "dark"
        storage[FeatureFlagItem.invalidString.rawValue] = InvalidString()

        storage[FeatureFlagItem.validArray.rawValue] = arraryExample
        storage[FeatureFlagItem.invalidArray.rawValue] = dictionaryExample

        storage[FeatureFlagItem.validDictionary.rawValue] = dictionaryExample
        storage[FeatureFlagItem.invalidDictionary.rawValue] = ""

        storage[FeatureFlagItem.validRawRepresentable.rawValue] = "dark"
        storage[FeatureFlagItem.invalidRawRepresentable1.rawValue] = "not dark"
        storage[FeatureFlagItem.invalidRawRepresentable2.rawValue] = 232
    }

    func value(forKey key: FeatureFlag.Key) -> FeatureFlag.Value? {
        StringConverter(storage[key.rawValue]!)
    }

    struct InvalidString { }
}

// MARK: - FeatureFlag

private enum FeatureFlagItem: String {
    case validBool
    case invalidBool

    case validInt
    case invalidInt

    case validFloat
    case invalidFloat

    case validDouble
    case invalidDouble

    case validUrl
    case invalidUrl

    case validString
    case invalidString

    case validArray
    case invalidArray

    case validDictionary
    case invalidDictionary

    case validRawRepresentable
    case invalidRawRepresentable1
    case invalidRawRepresentable2
}

// MARK: - FeatureFlag.Key

extension FeatureFlag.Key {
    fileprivate var storageValue: FeatureFlag.Value? {
        CustomFeatureFlag().value(forKey: self)
    }

    fileprivate func value<T>(default defaultValue: @autoclosure () -> T) -> T {
        storageValue?.get() ?? defaultValue()
    }

    fileprivate func value<T>(default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        storageValue?.get() ?? defaultValue()
    }
}

// MARK: - TestFeature

private enum TestFeature {
    static func flag(_ key: FeatureFlagItem) -> FeatureFlag.Key {
        .init(rawValue: key.rawValue)
    }
}

// MARK: - TestFeature

private enum TestTheme: String {
    case dark
    case light
}
