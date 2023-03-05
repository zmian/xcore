//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class OpenURLClientTests: TestCase {
    func testInMemoryVariant() async {
        let openedUrlIsolated = ActorIsolated<URL?>(nil)

        let viewModel = withDependencies {
            $0.openUrl = .init { adaptiveUrl in
                await openedUrlIsolated.setValue(adaptiveUrl.url)
                return true
            }
        } operation: {
            ViewModel()
        }

        var openedUrl = await openedUrlIsolated.value
        XCTAssertNil(openedUrl)

        await viewModel.openMailApp()
        openedUrl = await openedUrlIsolated.value
        XCTAssertEqual(openedUrl, .mailApp)

        await viewModel.openSettingsApp()
        openedUrl = await openedUrlIsolated.value
        XCTAssertEqual(openedUrl, .settingsApp)

        await viewModel.openSomeUrl()
        openedUrl = await openedUrlIsolated.value
        XCTAssertEqual(openedUrl, URL(string: "https://example.com"))
    }
}

private final class ViewModel {
    @Dependency(\.openUrl) var openUrl

    func openMailApp() async {
        await openUrl(.mailApp)
    }

    func openSettingsApp() async {
        await openUrl(.settingsApp)
    }

    func openSomeUrl() async {
        await openUrl(URL(string: "https://example.com"))
    }
}
