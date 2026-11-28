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
/// Swift Testing does not always infer a test dependency context (unlike XCTest); pin `.test` and
/// expect `reportIssue` from production `testValue` (`.unimplemented`).
struct DependencyKeyDefaultsTests {
    @Test
    func sessionCounterTestValueIsInert() {
        withDependencies {
            $0 = .test
        } operation: {
            withExpectedIssue {
                @Dependency(\.sessionCounter) var sessionCounter
                let initial = sessionCounter.count()
                sessionCounter.increment()
                #expect(sessionCounter.count() == initial)
            }
        }
    }

    @Test
    func openURLTestValueDoesNotOpen() async {
        await withDependencies {
            $0 = .test
        } operation: {
            await withExpectedIssue {
                @Dependency(\.openURL) var openURL
                let opened = await openURL(URL(string: "https://example.com"))
                #expect(opened == false)
            }
        }
    }

    #if canImport(UIKit)
    @Test
    func pasteboardTestValueDoesNotMutateSystemPasteboard() {
        withDependencies {
            $0 = .test
        } operation: {
            withExpectedIssue {
                let marker = "xcore-governance-pasteboard-test"
                UIPasteboard.general.string = marker
                @Dependency(\.pasteboard) var pasteboard
                pasteboard.copy("should-not-replace")
                #expect(UIPasteboard.general.string == marker)
            }
        }
    }
    #endif
}