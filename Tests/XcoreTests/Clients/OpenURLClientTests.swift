//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class OpenURLClientTests: TestCase {
    func testInMemoryVariant() {
        let viewModel = ViewModel()

        var openedUrl: URL?

        DependencyValues.openUrl(.init(id: "inline") { adaptiveUrl in
            openedUrl = adaptiveUrl.url
        })
        XCTAssertEqual(viewModel.openUrl.id, "inline")

        XCTAssertNil(openedUrl)

        viewModel.openMailApp()
        XCTAssertEqual(openedUrl, .mailApp)

        viewModel.openSettingsApp()
        XCTAssertEqual(openedUrl, .settingsApp)

        viewModel.openSomeUrl()
        XCTAssertEqual(openedUrl, URL(string: "https://example.com"))
    }

    func testNoopVariantId() {
        let viewModel = ViewModel()
        DependencyValues.openUrl(.noop)
        XCTAssertEqual(viewModel.openUrl.id, "noop")
    }

    private struct ViewModel {
        @Dependency(\.openUrl) var openUrl

        func openMailApp() {
            openUrl(.mailApp)
        }

        func openSettingsApp() {
            openUrl(.settingsApp)
        }

        func openSomeUrl() {
            openUrl(URL(string: "https://example.com"))
        }
    }
}
