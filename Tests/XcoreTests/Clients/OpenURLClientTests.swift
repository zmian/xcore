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

        DependencyValues.withValues {
            $0.openUrl = .init { adaptiveUrl in
                openedUrl = adaptiveUrl.url
            }
        } operation: {
            XCTAssertNil(openedUrl)

            viewModel.openMailApp()
            XCTAssertEqual(openedUrl, .mailApp)

            viewModel.openSettingsApp()
            XCTAssertEqual(openedUrl, .settingsApp)

            viewModel.openSomeUrl()
            XCTAssertEqual(openedUrl, URL(string: "https://example.com"))
        }
    }

    private final class ViewModel {
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
