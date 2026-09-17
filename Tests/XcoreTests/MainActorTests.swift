//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@_spi(Internal) import Xcore

struct MainActorTests {
    @MainActor private static let mainActorValue: CGFloat = 3

    @Test
    func `run immediately`() {
        #expect(screenScale == 3.0)
    }

    @Test
    func `run immediately sync main`() {
        var value = 0.0

        DispatchQueue.main.sync {
            value = screenScale
        }

        #expect(value == 3.0)
    }

    @Test
    func `run immediately sync background`() {
        var value = 0.0

        DispatchQueue.global().sync {
            value = screenScale
        }

        #expect(value == 3.0)
    }

    @Test
    func `run immediately task`() async {
        let value = await Task {
            screenScale
        }.value

        #expect(value == 3.0)
    }

    @Test
    func `run immediately task mainactor`() async {
        let value = await Task { @MainActor in
            screenScale
        }.value

        #expect(value == 3.0)
    }

    @Test
    func `run immediately task detached`() async {
        let value = await Task.detached(priority: .background) {
            screenScale
        }.value

        #expect(value == 3.0)
    }

    @Test
    func `run immediately async main`() async {
        let value = await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                continuation.resume(returning: screenScale)
            }
        }

        #expect(value == 3.0)
    }

    @Test
    func `run immediately async global`() async {
        let value = await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                continuation.resume(returning: screenScale)
            }
        }

        #expect(value == 3.0)
    }

    @Test
    func `run immediately async global main`() async {
        let value = await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                DispatchQueue.main.async {
                    continuation.resume(returning: screenScale)
                }
            }
        }

        #expect(value == 3.0)
    }

    @Test
    func `run immediately actor custom`() async {
        actor CustomActor {
            var screenScale: CGFloat {
                MainActor.runImmediately {
                    MainActor.preconditionIsolated()
                    return MainActorTests.mainActorValue
                }
            }
        }

        let a = CustomActor()
        #expect(await a.screenScale == 3.0)
    }

    @Test
    @MainActor
    func `run immediately actor main`() {
        #expect(screenScale == 3.0)
    }

    private var screenScale: CGFloat {
        MainActor.runImmediately {
            MainActor.preconditionIsolated()
            return Self.mainActorValue
        }
    }
}
