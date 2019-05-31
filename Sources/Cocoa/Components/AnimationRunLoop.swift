//
// AnimationRunLoop.swift
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

import UIKit

/// A class to report in-flight animation progress.
///
/// `UIView.animate(withDuration:)` doesn't provide any way for us to observe
/// "in-flight" animation value for the animated properties. Without "in-flight"
/// animation values we are unable to observe content inset to make adjustments
/// to UI.
final public class AnimationRunLoop {
    private var displayLink: CADisplayLink?
    private var beginTime: CFTimeInterval = 0
    private var endTime: CFTimeInterval = 0
    private var duration: TimeInterval = 0.25
    private var animations: ((_ progress: Double) -> Void)?
    private var completion: (() -> Void)?

    public init() {}

    public func start(
        duration: TimeInterval,
        animations: @escaping (_ progress: Double) -> Void,
        completion: @escaping () -> Void
    ) {
        self.duration = duration
        self.animations = animations
        self.completion = completion

        stop()
        let displayLink = CADisplayLink(target: self, selector: #selector(step))
        displayLink.add(to: .main, forMode: .common)
        self.displayLink = displayLink
    }

    public func stop() {
        displayLink?.invalidate()
        displayLink = nil
        beginTime = CACurrentMediaTime()
        endTime = duration + beginTime
    }

    @objc private func step(_ displayLink: CADisplayLink) {
        let now = CACurrentMediaTime()
        var percent = (now - beginTime) / duration
        percent = min(1, max(0, percent))
        animations?(percent)

        if now >= endTime {
            stop()
            completion?()
        }
    }
}
