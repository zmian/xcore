//
// Xcore
// Copyright © 2015 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

extension Timer {
    /// Creates a one-time timer and schedules it on the current run loop in the
    /// default mode.
    ///
    /// After interval seconds have elapsed, the timer fires, executing block.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// Timer.after(5) {
    ///     print("Hi once")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///    - interval: The number of seconds between firings of the timer. If
    ///      interval is less than or equal to `0.0`, this method chooses the
    ///      nonnegative value of `0.0001` seconds instead.
    ///    - work: A closure to be executed when the timer fires.
    /// - Returns: A new Timer object, configured according to the specified
    ///   parameters.
    @discardableResult
    public class func after(_ interval: TimeInterval, _ work: @escaping () -> Void) -> Timer {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
            work()
        }
    }

    /// Creates a repeating timer and schedules it on the current run loop in the
    /// default mode.
    ///
    /// After interval seconds have elapsed, the timer fires, executing block.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// var count = 0
    ///
    /// Timer.every(5) {
    ///     count += 1
    ///     print("Hi, count: \(count)")
    /// }
    /// ```
    ///
    /// - Parameters:
    ///    - interval: The number of seconds between firings of the timer. If
    ///      interval is less than or equal to `0.0`, this method chooses the
    ///      nonnegative value of `0.0001` seconds instead.
    ///    - work: A closure to be executed when the timer fires.
    /// - Returns: A new Timer object, configured according to the specified
    ///   parameters.
    @discardableResult
    public class func every(_ interval: TimeInterval, _ work: @escaping () -> Void) -> Timer {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
            work()
        }
    }

    /// Creates a repeating timer and schedules it on the current run loop in the
    /// default mode.
    ///
    /// After interval seconds have elapsed, the timer fires, executing block.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// var count = 0
    ///
    /// Timer.every(5) { timer in
    ///     count += 1
    ///     print("Hi, count: \(count)")
    ///
    ///     if count == 10 {
    ///         timer.invalidate()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///    - interval: The number of seconds between firings of the timer. If
    ///      interval is less than or equal to `0.0`, this method chooses the
    ///      nonnegative value of `0.0001` seconds instead.
    ///    - work: A closure to be executed when the timer fires. The block takes a
    ///      single `Timer` parameter and has no return value.
    /// - Returns: A new Timer object, configured according to the specified
    ///   parameters.
    @discardableResult
    public class func every(_ interval: TimeInterval, _ work: @escaping (Timer) -> Void) -> Timer {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: true) {
            work($0)
        }
    }
}

// MARK: - Pause and Resume

extension Timer {
    private enum AssociatedKey {
        static var pauseDate = "pauseDate"
        static var previousFireDate = "previousFireDate"
    }

    /// A property indicating the date when the timer was paused.
    private var pauseDate: Date? {
        get { associatedObject(&AssociatedKey.pauseDate) }
        set { setAssociatedObject(&AssociatedKey.pauseDate, value: newValue) }
    }

    /// A property indicating the last fire date for the timer.
    private var previousFireDate: Date? {
        get { associatedObject(&AssociatedKey.previousFireDate) }
        set { setAssociatedObject(&AssociatedKey.previousFireDate, value: newValue) }
    }

    /// A method to pause the timer.
    public func pause() {
        pauseDate = Date()
        previousFireDate = fireDate
        fireDate = Date.distantFuture
    }

    /// A method to resume the timer if it has been paused.
    public func resume() {
        guard
            let pauseDate = pauseDate,
            let previousFireDate = previousFireDate
        else {
            return
        }

        fireDate = Date(timeInterval: -pauseDate.timeIntervalSinceNow, since: previousFireDate)
    }
}
