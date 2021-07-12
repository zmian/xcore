//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

public final class Timeout {
    private var timer: Timer?
    private var callback: (() -> Void)?
    private var didTimeout: Bool

    /// Creates an instance of the `Timeout`.
    ///
    /// - Parameters:
    ///   - interval: The timeout interval before `callback` is invoked.
    ///   - callback: A closure to invoke after given timeout `interval`.
    public init(after interval: TimeInterval, callback: (() -> Void)? = nil) {
        self.didTimeout = interval == 0
        self.callback = callback
        timer = Timer.after(interval) { [weak self] in
            self?.notify()
        }
    }

    private func notify() {
        timer?.invalidate()
        timer = nil
        callback?()
        // Release the block as the caller should be notified only once.
        callback = nil
        didTimeout = true
    }

    /// A closure invoked when `self` times out.
    ///
    /// - Note: This is only fired once.
    public func then(_ callback: @escaping () -> Void) {
        // If already finished invoke callback immediately.
        if didTimeout {
            callback()
        } else {
            self.callback = callback
        }
    }

    public func cancel() {
        timer?.invalidate()
        timer = nil
        callback = nil
    }

    deinit {
        cancel()
    }
}
