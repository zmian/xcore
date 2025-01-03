//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct PasteboardClientTests {
    @Test
    func inMemoryVariant() {
        let viewModel = withDependencies {
            $0.pasteboard = .inMemory
        } operation: {
            ViewModel()
        }

        // nil out the pasteboard
        globalPasteboard.setValue(nil)
        #expect(globalPasteboard.value == nil)

        viewModel.copy()
        #expect(globalPasteboard.value == "hello")
    }

    @Test
    func noopVariant() {
        let viewModel = withDependencies {
            $0.pasteboard = .noop
        } operation: {
            ViewModel()
        }
        // nil out the pasteboard
        globalPasteboard.setValue(nil)
        #expect(globalPasteboard.value == nil)

        viewModel.copy()
        #expect(globalPasteboard.value == nil) // current variant is noop
    }
}

private final class ViewModel {
    @Dependency(\.pasteboard) var pasteboard

    func copy() {
        pasteboard.copy("hello")
    }
}

// MARK: - Helpers

private let globalPasteboard = LockIsolated<String?>(nil)

extension PasteboardClient {
    /// Returns in-memory variant of `PasteboardClient`.
    fileprivate static var inMemory: Self {
        .init { string in
            globalPasteboard.setValue(string)
        }
    }
}
