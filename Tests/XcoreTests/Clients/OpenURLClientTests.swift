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
            $0.openURL = .init { urlDescriptor in
                openedUrl.setValue(urlDescriptor.url)
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
    @Dependency(\.openURL) var openURL

    func openMailApp() async {
        await openURL(.mailApp)
    }

    func openSettingsApp() async {
        await openURL(.settingsApp)
    }

    func openSomeUrl() async {
        await openURL(URL(string: "https://example.com"))
    }
}
