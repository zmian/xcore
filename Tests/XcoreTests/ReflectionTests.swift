//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@testable import Xcore

@MainActor
struct ReflectionTests {
    @Test
    func nameOfType() {
        let myViewControllerInstance = MyViewController()
        #expect(typeName(of: myViewControllerInstance) == "XcoreTests.MyViewController")
        #expect(typeName(of: MyViewController.self) == "XcoreTests.MyViewController")
        #expect(typeName(of: MyView.self) == "XcoreTests.MyView")
        #expect(MyProtocolClass().typeName == "XcoreTests.MyProtocolClass")
        #expect(MyProtocolClass().instanceName == "XcoreTests.MyProtocolClass")
        #expect(MyProtocolClass.staticTypeName_1 == "XcoreTests.MyProtocolClass")
        #expect(MyProtocolClass.staticTypeName_2 == "XcoreTests.MyProtocolClass")

        // Class
        #expect(typeName(of: UIView()) == "UIView")
        #expect(typeName(of: SpacerView.self) == "Xcore.SpacerView")
        #expect(typeName(of: SpacerView()) == "Xcore.SpacerView")
        // Enum
        #expect(typeName(of: FeatureFlag.self) == "Xcore.FeatureFlag")
        #expect(typeName(of: ImageSourceType.self) == "Xcore.ImageSourceType")
        #expect(typeName(of: ImageSourceType.url("Hello")) == "Xcore.ImageSourceType")
        // Struct
        #expect(typeName(of: Version.self) == "Xcore.Version")
        #expect(typeName(of: Version(rawValue: "1.0.0")) == "Xcore.Version")
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
