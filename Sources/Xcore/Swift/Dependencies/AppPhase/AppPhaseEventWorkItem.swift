//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Combine

/// The work you want to perform, encapsulated in a way that lets you schedule
/// and cancel automatically on provided phases.
///
/// Schedules the provided work when the app enters in `"schedulePhase"` and if
/// app enters `"cancelPhase"` before the work is executed then the work be
/// cancelled and it will be reschduled when app enters in `"schedulePhase"`.
///
/// ```swift
/// // Schedule some work when app enters background.
/// AppPhaseEventWorkItem(
///     after: .seconds(1),
///     schedulePhase: .background,
///     cancelPhase: .willEnterForeground
/// ) {
///     // ... work
/// }
/// ```
public final class AppPhaseEventWorkItem {
    @Dependency(\.appPhase) private var appPhase
    private var cancellable: AnyCancellable?
    private var workItem: DispatchWorkItem?
    private let work: () -> Void
    private let interval: DispatchTimeInterval
    private let schedulePhase: AppPhase
    private let cancelPhase: AppPhase

    /// Creates a new app phase event work item.
    ///
    /// - Parameters:
    ///   - interval: The time at which to schedule the work block for execution
    ///     after app enters the `"schedulePhase"`.
    ///   - schedulePhase: The phase that schedule the work to be executed at the
    ///     provided `interval`.
    ///   - cancelPhase: The phase that cancels the pending work if it's not
    ///     executed before the app enters this state.
    ///   - work: The block that performs the work.
    public init(
        after interval: DispatchTimeInterval,
        schedulePhase: AppPhase,
        cancelPhase: AppPhase,
        work: @escaping () -> Void
    ) {
        precondition(schedulePhase != cancelPhase, "Schedule and cancel work phases must be different.")
        self.work = work
        self.interval = interval
        self.schedulePhase = schedulePhase
        self.cancelPhase = cancelPhase
        cancellable = appPhase.receive.sink { [weak self] appPhase in
            self?.onReceive(appPhase)
        }
    }

    private func onReceive(_ appPhase: AppPhase) {
        switch appPhase {
            case schedulePhase:
                schedule(true)
            case cancelPhase:
                schedule(false)
            default:
                break
        }
    }

    private func schedule(_ schedule: Bool) {
        workItem?.cancel()
        workItem = nil

        guard schedule else {
            return
        }

        let workItem = DispatchWorkItem(block: work)
        self.workItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + interval, execute: workItem)
    }
}
