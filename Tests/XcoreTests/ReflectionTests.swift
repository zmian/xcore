//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

@MainActor
final class ReflectionTests: TestCase {
    func testName() {
        let myViewControllerInstance = MyViewController()
        XCTAssertEqual(typeName(of: myViewControllerInstance), "XcoreTests.MyViewController")
        XCTAssertEqual(typeName(of: MyViewController.self), "XcoreTests.MyViewController")
        XCTAssertEqual(typeName(of: MyView.self), "XcoreTests.MyView")
        XCTAssertEqual(MyProtocolClass().typeName, "XcoreTests.MyProtocolClass")
        XCTAssertEqual(MyProtocolClass().instanceName, "XcoreTests.MyProtocolClass")
        XCTAssertEqual(MyProtocolClass.staticTypeName_1, "XcoreTests.MyProtocolClass")
        XCTAssertEqual(MyProtocolClass.staticTypeName_2, "XcoreTests.MyProtocolClass")

        // Class
        XCTAssertEqual(typeName(of: SpacerView.self), "Xcore.SpacerView")
        XCTAssertEqual(typeName(of: SpacerView()), "Xcore.SpacerView")
        // Enum
        XCTAssertEqual(typeName(of: FeatureFlag.self), "Xcore.FeatureFlag")
        XCTAssertEqual(typeName(of: ImageSourceType.self), "Xcore.ImageSourceType")
        XCTAssertEqual(typeName(of: ImageSourceType.url("Hello")), "Xcore.ImageSourceType")
        // Struct
        XCTAssertEqual(typeName(of: Version.self), "Xcore.Version")
        XCTAssertEqual(typeName(of: Version(rawValue: "1.0.0")), "Xcore.Version")
    }
}

func typeName(of value: Any) -> String {
    name(of: value)
}

private class MyViewController: UIViewController {}
private class MyView: UIView {}
private protocol MyProtocol {}
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

private class MyProtocolClass: MyProtocol {}
