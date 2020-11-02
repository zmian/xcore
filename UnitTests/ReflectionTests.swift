//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class ReflectionTests: TestCase {
    func testName() {
        let myViewControllerInstance = MyViewController()
        XCTAssertEqual(typeName(of: myViewControllerInstance), "UnitTests.MyViewController")
        XCTAssertEqual(typeName(of: MyViewController.self), "UnitTests.MyViewController")
        XCTAssertEqual(typeName(of: MyView.self), "UnitTests.MyView")
        XCTAssertEqual(MyProtocolClass().typeName, "UnitTests.MyProtocolClass")
        XCTAssertEqual(MyProtocolClass().instanceName, "UnitTests.MyProtocolClass")
        XCTAssertEqual(MyProtocolClass.staticTypeName_1, "UnitTests.MyProtocolClass")
        XCTAssertEqual(MyProtocolClass.staticTypeName_2, "UnitTests.MyProtocolClass")

        // Class
        XCTAssertEqual(typeName(of: DynamicTableView.self), "Xcore.DynamicTableView")
        XCTAssertEqual(typeName(of: DynamicTableView()), "Xcore.DynamicTableView")
        // Enum
        XCTAssertEqual(typeName(of: FeatureFlag.self), "Xcore.FeatureFlag")
        XCTAssertEqual(typeName(of: StringSourceType.self), "Xcore.StringSourceType")
        XCTAssertEqual(typeName(of: StringSourceType.string("Hello")), "Xcore.StringSourceType")
        // Struct
        XCTAssertEqual(typeName(of: Version.self), "Xcore.Version")
        XCTAssertEqual(typeName(of: Version(rawValue: "1.0.0")), "Xcore.Version")
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
        name(of: self)
    }

    var typeName: String {
        name(of: Self.self)
    }

    static var staticTypeName_1: String {
        name(of: Self.self)
    }

    static var staticTypeName_2: String {
        name(of: self)
    }
}

private class MyProtocolClass: MyProtocol { }
