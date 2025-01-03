//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

extension FeatureFlag {
    public static func setValues(
        _ values: [String: Sendable],
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        let testProviderId = "xctest"
        unregister(id: testProviderId)
        register(BlockFeatureFlagProvider(id: testProviderId) { key in
            if let value = values[key.rawValue] {
                return .init(value)
            }

            let example = "FeatureFlag.setValues([\"my_key\": \"hello_world\"])"
            Issue.record(
                "You are trying to access \"\(key)\" feature flag value in this test case without assigning it. You can set the value as: \(example)",
                sourceLocation: sourceLocation
            )
            // Returning empty string to avoid fallthrough to other providers.
            return .init("")
        }, at: 0)
    }

    public static func setValue(
        _ values: [String],
        forKey key: Key,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        setValue(
            String(describing: values),
            forKey: key,
            sourceLocation: sourceLocation
        )
    }

    public static func setValue(
        _ value: String,
        forKey key: Key,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        setValues(
            [key.rawValue: value],
            sourceLocation: sourceLocation
        )
    }

    public static func enable(
        _ keys: Key...,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        setValues(
            .init(uniqueKeysWithValues: keys.map { ($0.rawValue, true) }),
            sourceLocation: sourceLocation
        )
    }

    public static func disable(
        _ keys: Key...,
        sourceLocation: SourceLocation = #_sourceLocation
    ) {
        setValues(
            .init(uniqueKeysWithValues: keys.map { ($0.rawValue, false) }),
            sourceLocation: sourceLocation
        )
    }

    static func resetProviders() {
        setValues([:])
    }
}
