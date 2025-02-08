//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@MainActor
@Observable
final class StoryTimer {
    private let tick = Duration.seconds(0.01)
    private var duration: Duration
    private let cycle: Count
    private var pagesCount: Int
    private var cyclesCompleted = 0
    private var isPaused = false
    private var timerTask: Task<Void, any Error>?
    var onCycleComplete: ((_ remainingCycles: Count) -> Void)?
    var progress: Double

    init(pagesCount: Int, duration: Duration, cycle: Count) {
        self.pagesCount = pagesCount
        self.duration = duration
        self.cycle = cycle
        self.progress = 0
    }

    func start() {
        timerTask?.cancel()
        timerTask = Task {
            while !Task.isCancelled {
                try await Task.sleep(for: tick)
                updateProgress()
            }
        }
    }

    func stop() {
        timerTask?.cancel()
        timerTask = nil
    }

    func resume() {
        isPaused = false
    }

    func pause() {
        isPaused = true
    }

    func advance(by number: Int) {
        let newProgress = max((Int(progress) + number) % pagesCount, 0)
        progress = Double(newProgress)
        if timerTask == nil {
            start()
        }
    }

    func progress(for index: Int) -> CGFloat {
        min(max(progress - CGFloat(index), 0), 1)
    }

    private func updateProgress() {
        guard !isPaused else {
            return
        }

        var newProgress = progress + (tick / duration)

        // Cycle complete
        if Int(newProgress) >= pagesCount {
            cyclesCompleted += 1

            switch cycle {
                case .infinite:
                    newProgress = 0
                    onCycleComplete?(.infinite)
                case let .times(count):
                    let remainingCount = max(0, count - cyclesCompleted)
                    onCycleComplete?(.times(remainingCount))

                    if remainingCount == 0 {
                        stop()
                        return
                    } else {
                        newProgress = 0
                    }
            }
        }

        if UIAccessibility.isVoiceOverRunning {
            let currentIndex = max(Int(newProgress) % pagesCount, 0)
            let previousIndex = max(Int(progress) % pagesCount, 0)
            if currentIndex > previousIndex {
                pause()
                return
            }
        }

        progress = newProgress
    }
}
