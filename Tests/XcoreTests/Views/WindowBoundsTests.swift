//
// Xcore
// Copyright © 2026 Xcore
// MIT license, see LICENSE file for details
//

import Testing
import SwiftUI
@testable import Xcore

@MainActor
struct WindowBoundsTests {
    @Test
    func tracksWindowResizingFromFixedSizeView() async {
        var bounds: [CGRect] = []
        let content = Color.clear
            .frame(width: 100, height: 100)
            .onWindowBoundsChange { bounds.append($0) }
        let host = UIHostingController(rootView: content)
        let window = UIWindow(frame: CGRect(x: 0, y: 0, width: 800, height: 600))
        window.rootViewController = host
        window.isHidden = false
        defer { window.isHidden = true }
        window.layoutIfNeeded()
        await drainCallbacks()
        #expect(bounds == [CGRect(x: 0, y: 0, width: 800, height: 600)])

        window.bounds.size = CGSize(width: 400, height: 700)
        window.layoutIfNeeded()
        await drainCallbacks()
        #expect(bounds.count == 2)
        #expect(bounds.last == window.bounds)

        window.bounds.size = CGSize(width: 400, height: 800)
        window.layoutIfNeeded()
        await drainCallbacks()
        #expect(bounds.count == 3)
        #expect(bounds.last == window.bounds)

        window.setNeedsLayout()
        window.layoutIfNeeded()
        await drainCallbacks()
        #expect(bounds.count == 3)

        host.view.removeFromSuperview()
        window.bounds.size = CGSize(width: 200, height: 800)
        window.layoutIfNeeded()
        await drainCallbacks()
        #expect(bounds.count == 3)
    }

    private func drainCallbacks() async {
        await withCheckedContinuation { continuation in
            DispatchQueue.main.async {
                continuation.resume()
            }
        }
    }
}
