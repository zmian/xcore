//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import Dispatch
import Foundation
import Testing
import UIKit
@testable import Xcore

@MainActor
struct ImageViewLoadingTests {
    @Test
    func `failed load calls completion`() async {
        let view = UIImageView(image: UIImage())
        let result: UIImage? = await withCheckedContinuation { continuation in
            view.setImage("xcore-missing-image-for-failure-test") {
                continuation.resume(returning: $0)
            }
        }
        #expect(result == nil)
        #expect(view.image == nil)
    }

    @Test
    func `failed load uses fallback`() async {
        let view = UIImageView()
        let fallback = UIImage()
        let result: UIImage? = await withCheckedContinuation { continuation in
            view.setImage("xcore-missing-image-for-fallback-test", default: fallback) {
                continuation.resume(returning: $0)
            }
        }
        #expect(result === fallback)
        #expect(view.image === fallback)
    }

    @Test
    func `newer request supersedes queued request`() async {
        let view = UIImageView()
        let expected = UIImage()
        let result: UIImage? = await withCheckedContinuation { continuation in
            view.setImage("xcore-superseded-image") { _ in
                Issue.record("A superseded request must not call its completion")
            }
            view.setImage(expected) {
                continuation.resume(returning: $0)
            }
        }
        #expect(result === expected)
        #expect(view.image === expected)
    }

    @Test
    func transformsOffMainActorAndCompletesOnMainActor() async {
        let view = UIImageView()
        let transformed = UIImage()
        let source = UIImage().transform(BlockImageTransform(id: "off-main") { _, _ in
            #expect(!Thread.isMainThread)
            return transformed
        })
        let result: UIImage? = await withCheckedContinuation { continuation in
            view.setImage(source) { image in
                MainActor.assertIsolated()
                continuation.resume(returning: image)
            }
        }
        #expect(result === transformed)
        #expect(view.image === transformed)
        #expect(view.imageSetTask == nil)
    }

    @Test(arguments: [false, true])
    func discardsInFlightTransform(cancelOnly: Bool) async throws {
        let view = UIImageView()
        let initial = try #require(UIImage(systemName: "circle"))
        view.image = initial
        let replacement = try #require(UIImage(systemName: "square"))
        let release = DispatchSemaphore(value: 0)
        let (started, continuation) = AsyncStream<Void>.makeStream()
        let source = UIImage().transform(BlockImageTransform(id: "controlled") { image, _ in
            #expect(!Thread.isMainThread)
            continuation.yield(())
            continuation.finish()
            // Don't block the main actor if executor isolation regresses.
            guard !Thread.isMainThread else { return image }
            #expect(release.wait(timeout: .now() + 10) == .success)
            #expect(Task.isCancelled)
            return image
        })
        defer { release.signal() }

        view.setImage(source, default: UIImage()) { _ in
            Issue.record("A cancelled or superseded transform must not complete or load a fallback")
        }
        let oldTask = try #require(view.imageSetTask)
        var iterator = started.makeAsyncIterator()
        _ = await iterator.next()

        if cancelOnly {
            view.cancelSetImageRequest()
        } else {
            let result: UIImage? = await withCheckedContinuation { continuation in
                view.setImage(replacement) { continuation.resume(returning: $0) }
            }
            #expect(result === replacement)
        }

        #expect(oldTask.isCancelled)
        release.signal()
        await oldTask.value
        #expect(view.image === (cancelOnly ? initial : replacement))
        #expect(view.imageSetTask == nil)
    }
}
