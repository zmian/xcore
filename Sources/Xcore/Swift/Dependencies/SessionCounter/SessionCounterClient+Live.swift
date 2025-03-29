//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Combine

extension SessionCounterClient {
    /// Returns live variant of `SessionCounterClient`.
    public static var live: Self {
        let client = LiveSessionCounterClient()

        return .init {
            client.count
        } increment: {
            client.increment()
        }
    }
}

// MARK: - Implementation

private final class LiveSessionCounterClient: @unchecked Sendable {
    @Dependency(\.pond) private var pond
    @Dependency(\.appStatus) private var appStatus
    @Dependency(\.requestReview) private var requestReview
    private var appStatusTask: Task<Void, Never>?

    fileprivate init() {
        addObserver()
    }

    deinit {
        appStatusTask?.cancel()
    }

    private func addObserver() {
        appStatusTask = Task {
            for await appStatus in appStatus.receive.values where appStatus == .session(.unlocked) {
                increment()
            }
        }
    }

    public var count: Int {
        pond.sessionCount
    }

    public func increment() {
        pond.incrementSessionCount()
        requestReviewIfNeeded()
    }

    private func requestReviewIfNeeded() {
        let multipleOfValue = FeatureFlag.reviewPromptVisitMultipleOf

        guard
            multipleOfValue > 0,
            count > 0,
            count.isMultiple(of: multipleOfValue)
        else {
            return
        }

        requestReview()
    }
}

// MARK: - Pond

extension Pond {
    fileprivate var sessionCount: Int {
        `get`(sessionCountKey, default: 0)
    }

    fileprivate func incrementSessionCount() {
        let currentValue = sessionCount
        try? set(sessionCountKey, value: currentValue + 1)
    }

    private var sessionCountKey: PondKey {
        .userDefaults(#function)
    }
}
