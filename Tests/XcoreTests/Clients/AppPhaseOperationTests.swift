//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

import Testing
@testable import Xcore

@MainActor
struct AppPhaseOperationTests {
    @Dependency(\.appPhase) private var appPhase

    @Test("The operation should execute after the specified delay when the schedule phase is received.")
    func operationExecutesAfterDelay() async throws {
        var operationExecuted = false

        _ = AppPhaseOperation(
            after: .seconds(0.1),
            schedulePhase: .background,
            cancelPhase: .willEnterForeground,
            operation: {
                operationExecuted = true
            }
        )

        await Task.megaYield()

        // Trigger scheduling by sending the schedule phase.
        appPhase.send(.background)

        // Wait long enough for the operation to be executed.
        try await Task.sleep(for: .seconds(0.2))

        #expect(operationExecuted)
    }

    @Test("The operation does not execute if the cancel phase is received before the delay elapses.")
    func operationCancelledBeforeExecution() async throws {
        var operationExecuted = false

        _ = AppPhaseOperation(
            after: .seconds(0.2),
            schedulePhase: .background,
            cancelPhase: .willEnterForeground,
            operation: {
                operationExecuted = true
            }
        )

        await Task.megaYield()

        // Trigger scheduling.
        appPhase.send(.background)
        // Wait less than the delay.
        try await Task.sleep(for: .seconds(0.1))
        // Send cancel phase to cancel the pending operation.
        appPhase.send(.willEnterForeground)

        // Wait long enough to ensure the operation would have executed if not cancelled.
        try await Task.sleep(for: .seconds(0.2))

        #expect(operationExecuted == false)
    }
}
