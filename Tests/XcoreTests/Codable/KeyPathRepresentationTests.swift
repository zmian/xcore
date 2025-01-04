//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct KeyPathRepresentationTests {
    @Test
    func basics() {
        let keyPath = KeyPathRepresentation("user.profile.name")
        #expect(keyPath == "user.profile.name")
        #expect(keyPath.components == ["user", "profile", "name"])

        let updatedKeyPath = keyPath.appending("lastName")
        #expect(updatedKeyPath == "user.profile.name.lastName")

        #expect(updatedKeyPath.contains(segment: "lastName"))
        #expect(!keyPath.contains(segment: "lastName"))
        #expect(keyPath.contains(segment: "profile"))
        #expect(!keyPath.contains(segment: "age"))

        let keyPath2: KeyPathRepresentation = "user.profile.name"
        #expect(keyPath2 == "user.profile.name")
        #expect(keyPath2.components == ["user", "profile", "name"])
    }
}
