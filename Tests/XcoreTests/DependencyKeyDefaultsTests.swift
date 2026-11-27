//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

/// Regression tests for ADR 0001: production `DependencyKey` types must default to safe test values.
struct DependencyKeyDefaultsTests {
    @Test
    func sessionCounterTestValueIsInert() {
        @Dependency(\.sessionCounter) var sessionCounter
        let initial = sessionCounter.count()
        sessionCounter.increment()
        #expect(sessionCounter.count() == initial)
    }

    @Test
    func openURLTestValueDoesNotOpen() async {
        @Dependency(\.openURL) var openURL
        let opened = await openURL(URL(string: "https://example.com"))
        #expect(opened == false)
    }
}