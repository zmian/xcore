//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore
#if canImport(UIKit)
import UIKit
#endif

/// Regression tests for ADR 0001: production `DependencyKey` types must default to safe test values.
///
/// Swift Testing does not install dependency `testValue`s automatically (unlike XCTest); scope each
/// case with `withDependencies` and the production `testValue` variant.
struct DependencyKeyDefaultsTests {
    @Test
    func sessionCounterTestValueIsInert() {
        withDependencies {
            $0.sessionCounter = .unimplemented
        } operation: {
            let harness = SessionCounterHarness()
            let initial = harness.sessionCounter.count()
            harness.sessionCounter.increment()
            #expect(harness.sessionCounter.count() == initial)
        }
    }

    @Test
    func openURLTestValueDoesNotOpen() async {
        await withDependencies {
            $0.openURL = .unimplemented
        } operation: {
            let harness = OpenURLHarness()
            let opened = await harness.openURL(URL(string: "https://example.com"))
            #expect(opened == false)
        }
    }

    #if canImport(UIKit)
    @Test
    func pasteboardTestValueDoesNotMutateSystemPasteboard() {
        withDependencies {
            $0.pasteboard = .unimplemented
        } operation: {
            let marker = "xcore-governance-pasteboard-test"
            UIPasteboard.general.string = marker
            let harness = PasteboardHarness()
            harness.pasteboard.copy("should-not-replace")
            #expect(UIPasteboard.general.string == marker)
        }
    }
    #endif
}

private final class SessionCounterHarness: @unchecked Sendable {
    @Dependency(\.sessionCounter) var sessionCounter
}

private final class OpenURLHarness: @unchecked Sendable {
    @Dependency(\.openURL) var openURL
}

private final class PasteboardHarness: @unchecked Sendable {
    @Dependency(\.pasteboard) var pasteboard
}