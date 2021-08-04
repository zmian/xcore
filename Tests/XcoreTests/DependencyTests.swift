//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import XCTest
@testable import Xcore

final class DependencyTests: TestCase {
    func testDefault() throws {
        struct ViewModel {
            @Dependency(\.pasteboard) var pasteboard

            func copy() {
                pasteboard.copy("hello")
            }
        }

        let viewModel = ViewModel()
        XCTAssertEqual(viewModel.pasteboard.id, "noop")

        DependencyValues.set(\.pasteboard, LivePasteboardClient())
        XCTAssertEqual(viewModel.pasteboard.id, "live")

        DependencyValues.set(\.pasteboard, NoopPasteboardClient())
        XCTAssertEqual(viewModel.pasteboard.id, "noop")

        // nil out the pasteboard
        UIPasteboard.general.string = nil
        XCTAssertNil(UIPasteboard.general.string)

        viewModel.copy()
        XCTAssertNil(UIPasteboard.general.string) // current client is noop

        DependencyValues.set(\.pasteboard, LivePasteboardClient())
        viewModel.copy()
        XCTAssertEqual(UIPasteboard.general.string, "hello") // current client is live
    }

    func testDependencyVariant() {
        struct ViewModel {
            @Dependency(\.myPasteboard) var pasteboard

            func copy() {
                pasteboard.copy("hello")
            }
        }

        let viewModel = ViewModel()
        XCTAssertEqual(viewModel.pasteboard.id, "failing")

        DependencyValues.set(\.myPasteboard, .live)
        XCTAssertEqual(viewModel.pasteboard.id, "live")

        DependencyValues.set(\.myPasteboard, .failing)
        XCTAssertEqual(viewModel.pasteboard.id, "failing")

        // nil out the pasteboard
        UIPasteboard.general.string = nil
        XCTAssertNil(UIPasteboard.general.string)

        DependencyValues.set(\.myPasteboard, .live)
        viewModel.copy()
        XCTAssertEqual(UIPasteboard.general.string, "hello") // current client is live

        // Force all of the variant dependencies to be failing.
        DependencyValues.resetAll(toVariant: .failing)
        XCTAssertEqual(viewModel.pasteboard.id, "failing")

        XCTExpectFailure()
        viewModel.copy()
        XCTAssertNil(UIPasteboard.general.string) // current client is failing
    }
}

// MARK: - Helpers

private protocol PasteboardClient {
    var id: String { get }

    func copy(_ text: String)
}

private struct LivePasteboardClient: PasteboardClient {
    let id = "live"

    func copy(_ text: String) {
        UIPasteboard.general.string = text
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
        static let defaultValue: PasteboardClient = NoopPasteboardClient()
    }

    fileprivate var pasteboard: PasteboardClient {
        get { self[PasteboardClientKey.self] }
        set { self[PasteboardClientKey.self] = newValue }
    }
}

// MARK: - Dependency Variant

private struct MyPasteboard: DependencyVariant {
    let id: String
    let copy: (String) -> Void
}

extension MyPasteboard {
    static var live: Self {
        .init(id: #function) {
            UIPasteboard.general.string = $0
        }
    }

    static var failing: Self {
        .init(id: #function) { _ in
            XCTFail("MyPasteboard is unimplemented")
        }
    }
}

extension DependencyValues {
    private struct MyPasteboardClientKey: DependencyVariantKey {
        static let defaultValue: MyPasteboard = .failing
    }

    fileprivate var myPasteboard: MyPasteboard {
        get { self[MyPasteboardClientKey.self] }
        set { self[MyPasteboardClientKey.self] = newValue }
    }
}
