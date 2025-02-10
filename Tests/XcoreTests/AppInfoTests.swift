//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct AppInfoTests {
    @Test
    func traits() {
        let actual = AppInfo.traits

        let expected = [
            "app_version": Bundle.main.versionNumber,
            "app_build_number": Bundle.main.buildNumber,
            "app_bundle_id": Bundle.main.identifier,
            "device_name": Device.current.model.description,
            "device_model": Device.current.model.identifier,
            "device_family": Device.current.model.family,
            "os": Bundle.main.osNameVersion,
            "locale": Locale.current.identifier
        ]

        #expect(actual == expected)
    }

    @Test
    func userAgent() {
        let appVersionNumber = Bundle.main.versionNumber
        let appBuildNumber = Bundle.main.buildNumber
        let osNameVersion = Bundle.main.osNameVersion
        let deviceModel = Device.current.model.identifier

        #expect(
            AppInfo.userAgent ==
            "xctest/\(appVersionNumber) (com.apple.dt.xctest.tool; build:\(appBuildNumber); \(deviceModel); \(osNameVersion)) en_US"
        )
    }
}
