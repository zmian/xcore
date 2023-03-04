//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
@testable import Xcore

extension FeatureFlag {
    public static func setValues(_ values: [String: Any]) {
        let testProviderId = "xctest"
        unregister(id: testProviderId)
        register(BlockFeatureFlagProvider(id: testProviderId) { key in
            if let value = values[key.rawValue] {
                return .init(value)
            }

            let example = "FeatureFlag.setValues([\"my_key\": \"hello_world\"])"
            XCTFail("You are trying to access \"\(key)\" feature flag value in this test case without assigning it. You can set the value as: \(example)")
            // Returning empty string to avoid fallthrough to other providers.
            return .init("")
        }, at: 0)
    }

    public static func setValue(_ values: [String], forKey key: Key) {
        setValue(String(describing: values), forKey: key)
    }

    public static func setValue(_ value: String, forKey key: Key) {
        setValues([key.rawValue: value])
    }

    public static func enable(_ keys: Key...) {
        setValues(.init(uniqueKeysWithValues: keys.map { ($0.rawValue, true) }))
    }

    public static func disable(_ keys: Key...) {
        setValues(.init(uniqueKeysWithValues: keys.map { ($0.rawValue, false) }))
    }

    static func resetProviders() {
        setValues([:])
    }
}
