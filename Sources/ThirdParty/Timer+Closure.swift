//
// Timer+Closure.swift
// Nate Cook
//

import Foundation

extension Timer {
    /// Creates and schedules a one-time `NSTimer` instance.
    ///
    /// - parameters:
    ///    - delay: The delay before execution.
    ///    - handler: A closure to execute after `delay`.
    ///
    /// - returns: The newly-created `NSTimer` instance.
    @discardableResult
    public class func schedule(delay: TimeInterval, _ handler: @escaping () -> Void) -> Timer {
        let fireDate = delay + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, 0, 0, 0) { _ in
            handler()
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }

    /// Creates and schedules a repeating `NSTimer` instance.
    ///
    /// - parameters:
    ///     - repeatInterval: The interval (in seconds) between each execution of
    ///       `handler`. Note that individual calls may be delayed; subsequent calls
    ///       to `handler` will be based on the time the timer was created.
    ///     - handler: A closure to execute at each `repeatInterval`.
    ///
    /// - returns: The newly-created `NSTimer` instance.
    public class func schedule(repeatInterval interval: TimeInterval, _ handler: @escaping () -> Void) -> Timer {
        let fireDate = interval + CFAbsoluteTimeGetCurrent()
        let timer = CFRunLoopTimerCreateWithHandler(kCFAllocatorDefault, fireDate, interval, 0, 0) { _ in
            handler()
        }
        CFRunLoopAddTimer(CFRunLoopGetCurrent(), timer, CFRunLoopMode.commonModes)
        return timer!
    }
}

extension Timer {
    private struct AssociatedKey {
        static var timerPauseDate        = "XcoreTimerPauseDate"
        static var timerPreviousFireDate = "XcoreTimerPreviousFireDate"
    }

    private var pauseDate: Date? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.timerPauseDate) as? Date }
        set { objc_setAssociatedObject(self, &AssociatedKey.timerPauseDate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    private var previousFireDate: Date? {
        get { return objc_getAssociatedObject(self, &AssociatedKey.timerPreviousFireDate) as? Date }
        set { objc_setAssociatedObject(self, &AssociatedKey.timerPreviousFireDate, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    public func pause() {
        pauseDate        = Date()
        previousFireDate = fireDate
        fireDate         = Date.distantFuture
    }

    public func resume() {
        guard let pauseDate = pauseDate, let previousFireDate = previousFireDate else { return }
        fireDate = Date(timeInterval: -pauseDate.timeIntervalSinceNow, since: previousFireDate)
    }
}

public func delay(by interval: TimeInterval, _ callback: @escaping () -> Void) {
    Timer.schedule(delay: interval, callback)
}
