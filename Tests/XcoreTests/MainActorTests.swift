//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import UIKit
@_spi(Internal) import Xcore

struct MainActorTests {
    @Test
    func performIsolated() {
        #expect(screenScale == 3.0)
    }

    @Test
    func performIsolated_sync_main() {
        var value = 0.0

        DispatchQueue.main.sync {
            value = screenScale
        }

        #expect(value == 3.0)
    }

    @Test
    func performIsolated_sync_background() {
        var value = 0.0

        DispatchQueue.global().sync {
            value = screenScale
        }

        #expect(value == 3.0)
    }

    @Test
    func performIsolated_task() async {
        let value = await Task {
            screenScale
        }.value

        #expect(value == 3.0)
    }

    @Test
    func performIsolated_task_mainactor() async {
        let value = await Task { @MainActor in
            screenScale
        }.value

        #expect(value == 3.0)
    }

    @Test
    func performIsolated_task_detached() async {
        let value = await Task.detached(priority: .background) {
            screenScale
        }.value

        #expect(value == 3.0)
    }

    @Test
    func performIsolated_async_main() async {
        let value = await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                continuation.resume(returning: screenScale)
            }
        }

        #expect(value == 3.0)
    }

    @Test
    func performIsolated_async_global() async {
        let value = await withCheckedContinuation { continuation in
            DispatchQueue.global().async {
                continuation.resume(returning: screenScale)
            }
        }

        #expect(value == 3.0)
    }

    @Test
    func performIsolated_async_global_main() async {
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
    func performIsolated_actor_custom() async {
        actor CustomActor {
            var screenScale: CGFloat {
                MainActor.performIsolated {
                    UIScreen.main.scale
                }
            }
        }

        let a = CustomActor()
        #expect(await a.screenScale == 3.0)
    }

    @Test
    @MainActor
    func performIsolated_actor_main() async {
        #expect(screenScale == 3.0)
    }

    private var screenScale: CGFloat {
        MainActor.performIsolated {
            UIScreen.main.scale
        }
    }
}
