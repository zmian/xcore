//
// ReflectionTests.swift
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
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
