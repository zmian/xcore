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
    private let cycle: Count
    private var interval: TimeInterval
    private var pagesCount: Int
    private let publisher: Timer.TimerPublisher
    private var cancellable: AnyCancellable?
    private var cyclesCompleted = 0
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
        self.publisher = Timer.publish(every: 0.1, on: .main, in: .default)
    }

    func start() {
        cancellable = publisher.autoconnect().sink { [weak self] _ in
            self?.updateProgress()
        }
    }

    private func updateProgress() {
        var newProgress = progress + (0.1 / interval)

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

        progress = newProgress
    }

    private func restartIfNeeded() {
        if cancellable == nil {
            start()
        }
    }

    func stop() {
        cancellable?.cancel()
        cancellable = nil
    }

    func advance(by number: Int) {
        let newProgress = max((Int(progress) + number) % pagesCount, 0)
        progress = Double(newProgress)
        restartIfNeeded()
    }

    func progress(for index: Int) -> CGFloat {
        min(max((progress - CGFloat(index)), 0), 1)
    }
}
