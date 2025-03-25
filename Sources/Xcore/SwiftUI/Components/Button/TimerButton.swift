//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

/// An enumeration representing the status of a timer button.
public enum TimerButtonStatus: Sendable, Hashable {
    case active
    case loading
    case countdown

    fileprivate init<T>(_ data: DataStatus<T, some Error>) {
        switch data {
            case .idle, .failure:
                self = .active
            case .loading:
                self = .loading
            case .success:
                self = .countdown
        }
    }
}

/// A button that counts down before provided action is invoked subsequently.
public struct TimerButton<Label: View>: View {
    private enum InternalState: Sendable, Hashable {
        case idle
        case active
        case loading
        case startTimer
        case ticked(Int)

        var remainingSeconds: Int {
            if case let .ticked(remainingSeconds) = self {
                return remainingSeconds
            }

            return 0
        }
    }

    private typealias L = Localized
    @Environment(\.theme) private var theme
    @State private var state = InternalState.idle
    @State private var elapsedTime = ElapsedTime()
    @State private var timerTask: Task<(), Never>?
    private let status: TimerButtonStatus
    private let countdown: Int
    private let action: () -> Void
    private let label: Label

    public var body: some View {
        ZStack {
            Button(action: performActionIfNeeded) {
                label
            }
            .hidden(isButtonHidden)

            Text(L.resendAfter(state.remainingSeconds))
                .foregroundStyle(theme.textSecondaryColor)
                .hidden(!showRemainingSeconds)

            ProgressView()
                .hidden(state != .loading)
        }
        .animation(.default, value: isButtonHidden)
        .onChange(of: state) { _, state in
            switch state {
                case .idle, .ticked:
                    break
                case .active, .loading:
                    stopTimer()
                case .startTimer:
                    restartTimer()
            }
        }
        .onChange(of: status) { _, status in
            onStatus(status)
        }
        .onAppear {
            onStatus(status)
        }
    }

    private var showRemainingSeconds: Bool {
        state.remainingSeconds > 0
    }

    private var isButtonHidden: Bool {
        switch state {
            case .loading:
                true
            case .idle, .active, .startTimer:
                false
            case let .ticked(remainingSeconds):
                remainingSeconds > 0
        }
    }

    private func onStatus(_ status: TimerButtonStatus) {
        switch status {
            case .loading:
                state = .loading
            case .active:
                state = .active
            case .countdown:
                state = .startTimer
        }
    }

    private func performActionIfNeeded() {
        guard state == .active else {
            return
        }

        restartTimer()
        action()
    }

    private func restartTimer() {
        state = .ticked(countdown)
        makeTimer()
        elapsedTime.reset()
    }

    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
    }

    private func makeTimer() {
        stopTimer()
        timerTask = Task {
            do {
                while true {
                    try await Task.sleep(for: .seconds(1), tolerance: .zero, clock: .continuous)
                    if state.remainingSeconds > 0 {
                        state = .ticked(countdown - elapsedTime.elapsedSeconds())
                    } else {
                        state = .active
                    }
                }
            } catch {
                state = .active
            }
        }
    }
}

// MARK: - Inits

extension TimerButton {
    public init(
        countdown countdownSeconds: Int = 15,
        status: TimerButtonStatus = .active,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.countdown = countdownSeconds
        self.status = status
        self.action = action
        self.label = label()
    }

    public init<T>(
        countdown countdownSeconds: Int = 15,
        status: DataStatus<T, some Error>,
        action: @escaping () -> Void,
        @ViewBuilder label: () -> Label
    ) {
        self.init(
            countdown: countdownSeconds,
            status: .init(status),
            action: action,
            label: label
        )
    }
}

extension TimerButton<Text> {
    public init(
        _ title: some StringProtocol,
        countdown countdownSeconds: Int = 15,
        status: TimerButtonStatus = .active,
        action: @escaping () -> Void
    ) {
        self.init(
            countdown: countdownSeconds,
            status: status,
            action: action,
            label: {
                Text(title)
            }
        )
    }

    public init<T>(
        _ title: some StringProtocol,
        countdown countdownSeconds: Int = 15,
        status: DataStatus<T, some Error>,
        action: @escaping () -> Void
    ) {
        self.init(
            title,
            countdown: countdownSeconds,
            status: .init(status),
            action: action
        )
    }
}

// MARK: - Convenience: Resend

extension TimerButton<Text> {
    /// A button with `Resend` label and given action.
    public static func resend(
        countdown countdownSeconds: Int = 15,
        status: TimerButtonStatus = .active,
        action: @escaping () -> Void
    ) -> some View {
        TimerButton(
            L.resend,
            countdown: countdownSeconds,
            status: status,
            action: action
        )
        .accessibilityIdentifier("resendButton")
    }

    /// A button with `Resend` label and given action.
    public static func resend<T>(
        countdown countdownSeconds: Int = 15,
        status: DataStatus<T, some Error>,
        action: @escaping () -> Void
    ) -> some View {
        resend(
            countdown: countdownSeconds,
            status: .init(status),
            action: action
        )
    }
}

// MARK: - Preview

#Preview {
    TimerButton.resend(status: .countdown) {
        print("Resend button tapped")
    }
    .buttonStyle(.borderedProminent)
}
