//
// ReflectionTests.swift
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

final class ReflectionTests: TestCase {
    func testName() {
        let myViewControllerInstance = MyViewController()
        XCTAssert(typeName(of: myViewControllerInstance) == "UnitTests.MyViewController")
        XCTAssert(typeName(of: MyViewController.self) == "UnitTests.MyViewController")
        XCTAssert(typeName(of: MyView.self) == "UnitTests.MyView")
        XCTAssert(MyProtocolClass().typeName == "UnitTests.MyProtocolClass")
        XCTAssert(MyProtocolClass().instanceName == "UnitTests.MyProtocolClass")
        XCTAssert(MyProtocolClass.staticTypeName_1 == "UnitTests.MyProtocolClass")
        XCTAssert(MyProtocolClass.staticTypeName_2 == "UnitTests.MyProtocolClass")

        // Class
        XCTAssert(typeName(of: DynamicTableView.self) == "Xcore.DynamicTableView")
        XCTAssert(typeName(of: DynamicTableView()) == "Xcore.DynamicTableView")
        // Enum
        XCTAssert(typeName(of: FeatureFlag.self) == "Xcore.FeatureFlag")
        XCTAssert(typeName(of: StringSourceType.self) == "Xcore.StringSourceType")
        XCTAssert(typeName(of: StringSourceType.string("Hello")) == "Xcore.StringSourceType")
        // Struct
        XCTAssert(typeName(of: Version.self) == "Xcore.Version")
        XCTAssert(typeName(of: Version(rawValue: "1.0.0")) == "Xcore.Version")
    }
}

func typeName(of value: Any) -> String {
    name(of: value)
}

private class MyViewController: UIViewController { }
private class MyView: UIView { }
private protocol MyProtocol { }
extension MyProtocol {
    var instanceName: String {
        return name(of: self)
    }

    var typeName: String {
        return name(of: Self.self)
    }

    static var staticTypeName_1: String {
        return name(of: Self.self)
    }

    static var staticTypeName_2: String {
        return name(of: self)
    }
}

private class MyProtocolClass: MyProtocol { }
