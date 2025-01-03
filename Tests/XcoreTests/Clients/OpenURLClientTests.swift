//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import Foundation
@testable import Xcore

struct OpenURLClientTests {
    @Test
    func inMemoryVariant() async {
        let openedUrl = LockIsolated<URL?>(nil)

        let viewModel = withDependencies {
            $0.openUrl = .init { adaptiveUrl in
                openedUrl.setValue(adaptiveUrl.url)
                return true
            }
        } operation: {
            ViewModel()
        }

        #expect(openedUrl.value == nil)

        await viewModel.openMailApp()
        #expect(openedUrl.value == .mailApp)

        await viewModel.openSettingsApp()
        #expect(openedUrl.value == .settingsApp)

        await viewModel.openSomeUrl()
        #expect(openedUrl.value == URL(string: "https://example.com"))
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
