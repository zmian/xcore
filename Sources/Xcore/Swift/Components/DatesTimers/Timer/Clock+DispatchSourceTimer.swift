//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Foundation

/// A custom `Clock` that uses `DispatchSourceTimer` for sleeping.
///
/// **Usage**
///
/// ```swift
/// let clock = DispatchSourceTimerClock()
/// try await clock.sleep(for: .seconds(1))
/// ```
struct DispatchSourceTimerClock: Clock {
    typealias Duration = Swift.Duration
    typealias Instant = ContinuousClock.Instant

    var now: Instant {
        ContinuousClock().now
    }

    var minimumResolution: Duration {
        .nanoseconds(1)
    }

    init() {}

    func sleep(until deadline: Instant, tolerance: Duration? = nil) async throws {
        let timer = DispatchSource.makeTimerSource(queue: .global(qos: .default))

        try await withTaskCancellationHandler {
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                if Task.isCancelled {
                    timer.cancel()
                    continuation.resume(throwing: CancellationError())
                    return
                }

                timer.schedule(
                    deadline: .now() + now.duration(to: deadline).seconds,
                    repeating: .never,
                    leeway: .nanoseconds(Int(tolerance?.nanoseconds ?? 0))
                )

                timer.setEventHandler { [weak timer] in
                    timer?.cancel()
                    if Task.isCancelled {
                        continuation.resume(throwing: CancellationError())
                    } else {
                        continuation.resume()
                    }
                }

                timer.activate()

                if Task.isCancelled {
                    timer.cancel()
                    continuation.resume(throwing: CancellationError())
                }
            }
        } onCancel: {
            timer.cancel()
        }
    }
}

// MARK: - Dot Syntax Support

extension Clock where Self == DispatchSourceTimerClock {
    /// A custom `Clock` that uses `DispatchSourceTimer` for sleeping.
    ///
    /// **Usage**
    ///
    /// ```swift
    /// try await Task.sleep(for: .seconds(1), clock: .dispatchSourceTimer)
    /// ```
    static var dispatchSourceTimer: Self {
        DispatchSourceTimerClock()
    }
}
