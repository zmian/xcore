//
// Xcore
// Copyright © 2019 Xcore
// MIT license, see LICENSE file for details
//

import UIKit

/// A class to report in-flight animation progress.
///
/// `UIView.animate(withDuration:)` doesn't provide any way for us to observe
/// "in-flight" animation value for the animated properties. Without "in-flight"
/// animation values we are unable to observe content inset to make adjustments
/// to UI.
public final class AnimationRunLoop {
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

    @objc
    private func step(_ displayLink: CADisplayLink) {
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
