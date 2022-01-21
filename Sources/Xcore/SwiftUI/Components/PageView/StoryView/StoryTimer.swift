//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

/// - SeeAlso: https://trailingclosure.com/swiftui-instagram-story-tutorial
final class StoryTimer: ObservableObject {
    @Published var progress: Double
    private let tick = 0.1
    private let cycle: Count
    private var interval: TimeInterval
    private var pagesCount: Int
    private var cancellable: AnyCancellable?
    private var cyclesCompleted = 0
    private var paused = false
    var onCycleComplete: ((_ remainingCycles: Count) -> Void)?

    init(
        pagesCount: Int,
        interval: TimeInterval,
        cycle: Count
    ) {
        self.pagesCount = pagesCount
        self.interval = interval
        self.cycle = cycle
        self.progress = 0
        start()
    }

    deinit {
        stop()
    }

    func start() {
        guard cancellable == nil else {
            return
        }

        cancellable = Timer
            .publish(every: tick, on: .main, in: .common)
            .autoconnect()
            .merge(with: Just(Date()))
            .sink { [weak self] _ in
                self?.updateProgress()
            }
    }

    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }

    func resume() {
        paused = false
    }

    func pause() {
        paused = true
    }

    func advance(by number: Int) {
        let newProgress = max((Int(progress) + number) % pagesCount, 0)
        progress = Double(newProgress)
        restartIfNeeded()
    }

    func progress(for index: Int) -> CGFloat {
        min(max(progress - CGFloat(index), 0), 1)
    }

    private func restartIfNeeded() {
        if cancellable == nil {
            start()
        }
    }

    private func updateProgress() {
        guard !paused else {
            return
        }

        var newProgress = progress + (tick / interval)

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
            let currentIndex = max((Int(newProgress)) % pagesCount, 0)
            let previousIndex = max((Int(progress)) % pagesCount, 0)
            if currentIndex > previousIndex {
                pause()
                return
            }
        }
        progress = newProgress
    }
}
