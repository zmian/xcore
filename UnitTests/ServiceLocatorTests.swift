//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class ServiceLocatorTests: TestCase {
    func testFlow() {
        register()

        let model = Model()
        model.avatarChanged(UIImage())
        XCTAssertTrue(didCallAvatarChange)
    }
}

private var didCallAvatarChange = false

// 1. Create a service protocol
private protocol ProfileServiceProtocol: AnyObject {
    func avatarDidChange(_ image: UIImage)
}

// 2. Implement service protocol
private class ProfileService: ProfileServiceProtocol {
    func avatarDidChange(_ image: UIImage) {
        didCallAvatarChange = true
    }
}

// 3. Register service with service locator
private func register() {
    ServiceLocator.register(ProfileService(), for: ProfileServiceProtocol.self)
}

// 4. Usage
private class Model {
    // Use the @Inject property wrapper and the service locator will resolve the
    // service.
    @Inject private var profileService: ProfileServiceProtocol

    func avatarChanged(_ image: UIImage) {
        profileService.avatarDidChange(image)
    }
}
