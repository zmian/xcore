//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

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
}
