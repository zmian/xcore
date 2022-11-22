//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DependencyTests: TestCase {
    func testProtocolDependency() throws {
        final class ViewModel {
            @Dependency(\.pasteboard) var pasteboard

            func copy() {
                pasteboard.copy("hello")
            }
        }

        let viewModel = ViewModel()

        DependencyValues.withValues {
            $0.pasteboard = LivePasteboardClient()
        } operation: {
            XCTAssertEqual(viewModel.pasteboard.id, "live")
        }

        DependencyValues.withValues {
            $0.pasteboard = NoopPasteboardClient()
        } operation: {
            XCTAssertEqual(viewModel.pasteboard.id, "noop")

            // nil out the pasteboard
            globalPasteboard = nil
            XCTAssertNil(globalPasteboard)

            viewModel.copy()
            XCTAssertNil(globalPasteboard) // current client is noop
        }

        DependencyValues.withValues {
            $0.pasteboard = LivePasteboardClient()
        } operation: {
            viewModel.copy()
            XCTAssertEqual(globalPasteboard, "hello") // current client is live
        }
    }

    func testStructDependency() {
        final class ViewModel {
            @Dependency(\.myPasteboard) var pasteboard

            func copy() {
                pasteboard.copy("hello")
            }
        }

        let viewModel = ViewModel()

        DependencyValues.withValues {
            $0.myPasteboard = .live
        } operation: {
            XCTAssertEqual(viewModel.pasteboard.id, "live")
        }

        DependencyValues.withValues {
            $0.myPasteboard = .noop
        } operation: {
            XCTAssertEqual(viewModel.pasteboard.id, "noop")
        }

        // nil out the pasteboard
        globalPasteboard = nil
        XCTAssertNil(globalPasteboard)

        DependencyValues.withValues {
            $0.myPasteboard = .live
        } operation: {
            viewModel.copy()
            XCTAssertEqual(globalPasteboard, "hello") // current client is live
        }

        XCTExpectFailure()
        viewModel.copy()
        XCTAssertEqual(globalPasteboard, "hello") // current client is live
    }
}

// MARK: - Helpers

private var globalPasteboard: String?

private protocol PasteboardClient {
    var id: String { get }

    func copy(_ text: String)
}

private struct LivePasteboardClient: PasteboardClient {
    let id = "live"

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
    private struct PasteboardClientKey: DependencyKey {
        static let liveValue: PasteboardClient = LivePasteboardClient()
    }

    fileprivate var pasteboard: PasteboardClient {
        get { self[PasteboardClientKey.self] }
        set { self[PasteboardClientKey.self] = newValue }
    }
}

// MARK: - Dependency with Struct

private struct MyPasteboard {
    let id: String
    let copy: (String) -> Void
}

extension MyPasteboard {
    static var live: Self {
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
        static let liveValue: MyPasteboard = .live
    }

    fileprivate var myPasteboard: MyPasteboard {
        get { self[MyPasteboardClientKey.self] }
        set { self[MyPasteboardClientKey.self] = newValue }
    }
}
