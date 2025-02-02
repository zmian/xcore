//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct UserInfoKeyTests {
    @Test
    func basics() {
        var instance = MyType()

        instance[userInfoKey: .name] = "Sam"
        #expect(instance[userInfoKey: .name] == "Sam")

        instance.name = "Swift"
        #expect(instance.name == "Swift")

        // Use default value
        #expect(instance[userInfoKey: "age", default: 10] == 10)

        // Ignores default value when value is set
        #expect(instance[userInfoKey: .name, default: "World"] == "Swift")
    }
}

private struct MyType: UserInfoContainer {
    var userInfo: UserInfo = [:]
}

extension UserInfoKey<MyType> {
    fileprivate static var name: Self { #function }
}

extension MyType {
    fileprivate var name: String? {
        get { self[userInfoKey: .name] }
        set { self[userInfoKey: .name] = newValue }
    }
}
