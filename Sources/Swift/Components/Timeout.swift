//
// Timeout.swift
//
// Copyright © 2019 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

public final class Timeout {
    private var timer: Timer?
    private var callback: (() -> Void)?
    private var didTimeout: Bool

    /// Creates an instance of the `Timeout`.
    ///
    /// - Parameters:
    ///     - interval: The timeout interval before `callback` is invoked.
    ///     - callback: A closure to invoke after given timeout `interval`.
    public init(after interval: TimeInterval, callback: (() -> Void)? = nil) {
        self.didTimeout = interval == 0
        self.callback = callback
        timer = Timer.schedule(delay: interval) { [weak self] in
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
