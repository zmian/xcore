//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Combine

/// The operation you want to perform, encapsulated in a way that lets you
/// schedule and cancel automatically on provided app phases.
///
/// Schedules the provided operation when the app enters the specified
/// `schedulePhase`. If the app enters `cancelPhase` before the operation is
/// executed, then the operation is cancelled. It will be rescheduled when the
/// app re-enters `schedulePhase`.
///
/// ```swift
/// // Schedule some operation when app enters background.
/// AppPhaseOperation(
///     after: .seconds(1),
///     schedulePhase: .background,
///     cancelPhase: .willEnterForeground
/// ) {
///     // ... operation
/// }
/// ```
@MainActor
public final class AppPhaseOperation {
    @Dependency(\.appPhase) private var appPhase
    private enum SchedulingPhase: Equatable {
        case idle
        case scheduled
    }

    private var schedulingPhase = SchedulingPhase.idle
    private var appPhaseTask: Task<Void, Never>?
    private var scheduledTask: Task<Void, any Error>?
    private let delay: Duration
    private let schedulePhase: AppPhase
    private let cancelPhase: AppPhase
    private let operation: @MainActor @Sendable () -> Void

    /// Creates a new app phase event operation.
    ///
    /// - Parameters:
    ///   - delay: The time delay after which to execute the operation block when
    ///     the app enters the `schedulePhase`.
    ///   - schedulePhase: The phase that triggers the scheduling of the operation.
    ///   - cancelPhase: The phase that cancels any pending operation if the app
    ///     enters this state.
    ///   - operation: The block that performs the operation.
    public init(
        after delay: Duration,
        schedulePhase: AppPhase,
        cancelPhase: AppPhase,
        operation: @escaping @MainActor @Sendable () -> Void
    ) {
        precondition(schedulePhase != cancelPhase, "Schedule and cancel operation phases must be different.")
        self.operation = operation
        self.delay = delay
        self.schedulePhase = schedulePhase
        self.cancelPhase = cancelPhase
        observeAppPhases()
    }

    private func observeAppPhases() {
        appPhaseTask = Task {
            for await appPhase in appPhase.receive.values {
                switch appPhase {
                    case schedulePhase:
                        shouldSchedule(true)
                    case cancelPhase:
                        shouldSchedule(false)
                    default:
                        break
                }
            }
        }
    }

    private func shouldSchedule(_ schedule: Bool) {
        guard schedule else {
            scheduledTask?.cancel()
            scheduledTask = nil
            schedulingPhase = .idle
            return
        }

        guard schedulingPhase == .idle else {
            return
        }

        schedulingPhase = .scheduled
        scheduledTask = Task {
            defer { schedulingPhase = .idle }
            try await Task.sleep(for: delay, tolerance: .zero)
            try Task.checkCancellation()
            operation()
        }
    }

    deinit {
        appPhaseTask?.cancel()
        scheduledTask?.cancel()
    }
}
