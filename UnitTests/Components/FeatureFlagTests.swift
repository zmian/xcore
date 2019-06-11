//
// FeatureFlagTests.swift
//
// Copyright © 2019 Xcore
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

        storage[FeatureFlag.validBool.rawValue] = true
        storage[FeatureFlag.invalidBool.rawValue] = "no"

        storage[FeatureFlag.validInt.rawValue] = 1213
        storage[FeatureFlag.invalidInt.rawValue] = "two"

        storage[FeatureFlag.validFloat.rawValue] = 20.34
        storage[FeatureFlag.invalidFloat.rawValue] = "two"

        storage[FeatureFlag.validDouble.rawValue] = 100.76
        storage[FeatureFlag.invalidDouble.rawValue] = "two"

        storage[FeatureFlag.validUrl.rawValue] = "https://swift.org/"
        storage[FeatureFlag.invalidUrl.rawValue] = "hello world"

        storage[FeatureFlag.validString.rawValue] = "dark"
        storage[FeatureFlag.invalidString.rawValue] = 200

        storage[FeatureFlag.validArray.rawValue] = arraryExample
        storage[FeatureFlag.invalidArray.rawValue] = dictionaryExample

        storage[FeatureFlag.validDictionary.rawValue] = dictionaryExample
        storage[FeatureFlag.invalidDictionary.rawValue] = ""

        storage[FeatureFlag.validRawRepresentable.rawValue] = "dark"
        storage[FeatureFlag.invalidRawRepresentable1.rawValue] = "not dark"
        storage[FeatureFlag.invalidRawRepresentable2.rawValue] = 232
    }

    func value(forKey key: FeatureFlagKey) -> FeatureFlagValue? {
        let value = storage[key.rawValue]

        return .init(
            string: value as? String,
            number: value as? NSNumber,
            bool: value as? Bool ?? false
        )
    }
}

// MARK: - FeatureFlag

private enum FeatureFlag: String {
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

// MARK: - FeatureFlagKey

extension FeatureFlagKey {
    fileprivate var storageValue: FeatureFlagValue? {
        return CustomFeatureFlag().value(forKey: self)
    }

    fileprivate func value<T>(default defaultValue: @autoclosure () -> T) -> T {
        return storageValue?.get() ?? defaultValue()
    }

    fileprivate func value<T>(default defaultValue: @autoclosure () -> T) -> T where T: RawRepresentable, T.RawValue == String {
        return storageValue?.get() ?? defaultValue()
    }
}

// MARK: - TestFeature

private enum TestFeature {
    static func flag(_ key: FeatureFlag) -> FeatureFlagKey {
        return FeatureFlagKey(rawValue: key.rawValue)
    }
}

// MARK: - TestFeature

private enum TestTheme: String {
    case dark
    case light
}
