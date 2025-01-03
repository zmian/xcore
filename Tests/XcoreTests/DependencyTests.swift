//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

struct DependencyTests {
    @Test
    func protocolDependency() {
        final class ViewModel {
            @Dependency(\.pasteboard) var pasteboard

            func copy() {
                pasteboard.copy("hello")
            }
        }

        let viewModel = ViewModel()

        withDependencies {
            $0.pasteboard = SharedPasteboardClient()
        } operation: {
            #expect(viewModel.pasteboard.id == "shared")
        }

        withDependencies {
            $0.pasteboard = NoopPasteboardClient()
        } operation: {
            #expect(viewModel.pasteboard.id == "noop")

            // nil out the pasteboard
            globalPasteboard = nil
            #expect(globalPasteboard == nil)

            viewModel.copy()
            #expect(globalPasteboard == nil) // current client is noop
        }

        withDependencies {
            $0.pasteboard = SharedPasteboardClient()
        } operation: {
            viewModel.copy()
            #expect(globalPasteboard == "hello") // current client is shared
        }
    }

    @Test
    func structDependency() {
        final class ViewModel {
            @Dependency(\.myPasteboard) var pasteboard

            func copy() {
                pasteboard.copy("hello")
            }
        }

        let viewModel = ViewModel()

        withDependencies {
            $0.myPasteboard = .shared
        } operation: {
            #expect(viewModel.pasteboard.id == "shared")
        }

        withDependencies {
            $0.myPasteboard = .noop
        } operation: {
            #expect(viewModel.pasteboard.id == "noop")
        }

        // nil out the pasteboard
        globalPasteboard = nil
        #expect(globalPasteboard == nil)

        withDependencies {
            $0.myPasteboard = .shared
        } operation: {
            viewModel.copy()
            #expect(globalPasteboard == "hello") // current client is shared
        }

        XCTExpectFailure()
        viewModel.copy()
        #expect(globalPasteboard == "hello") // current client is shared
    }
}

// MARK: - Helpers

nonisolated(unsafe) private var globalPasteboard: String?

private protocol PasteboardClient: Sendable {
    var id: String { get }

    func copy(_ text: String)
}

private struct SharedPasteboardClient: PasteboardClient {
    let id = "shared"

    func copy(_ text: String) {
        globalPasteboard = text
    }
}

private struct NoopPasteboardClient: PasteboardClient {
    let id = "noop"

    func copy(_ text: String) {
        // do nothing
    }
}

extension DependencyValues {
    private enum PasteboardClientKey: DependencyKey {
        static let liveValue: PasteboardClient = SharedPasteboardClient()
    }

    fileprivate var pasteboard: PasteboardClient {
        get { self[PasteboardClientKey.self] }
        set { self[PasteboardClientKey.self] = newValue }
    }
}

// MARK: - Dependency with Struct

private struct MyPasteboard: Sendable {
    let id: String
    let copy: @Sendable (String) -> Void
}

extension MyPasteboard {
    static var shared: Self {
        .init(id: #function) {
            globalPasteboard = $0
        }
    }

    static var noop: Self {
        .init(id: #function) { _ in }
    }
}

extension DependencyValues {
    private struct MyPasteboardClientKey: DependencyKey {
        static let liveValue: MyPasteboard = .shared
        static let testValue: MyPasteboard = .shared
    }

    fileprivate var myPasteboard: MyPasteboard {
        get { self[MyPasteboardClientKey.self] }
        set { self[MyPasteboardClientKey.self] = newValue }
    }
}
