//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI
import Combine

/// An enumeration representing the status of a timer button.
public enum TimerButtonStatus {
    case active
    case loading
    case countdown

    fileprivate init(_ data: DataStatus<some Hashable>) {
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
    private enum InternalState: Hashable {
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
    @State private var monotonicTimer = MonotonicTimer.Uptime()
    @State private var timer = makeTimer()
    private let status: TimerButtonStatus
    private let countdown: Int
    private let action: () -> Void
    private let label: Label

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
        .onReceive(timer) { _ in
            if state.remainingSeconds > 0 {
                state = .ticked(countdown - monotonicTimer.secondsElapsed())
            } else {
                state = .active
            }
        }
        .onChange(of: state) { state in
            switch state {
                case .idle, .ticked:
                    break
                case .active, .loading:
                    stopTimer()
                case .startTimer:
                    restartTimer()
            }
        }
        .onChange(of: status) { status in
            onStatus(status)
        }
        .onAppear {
            onStatus(status)
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
        timer = Self.makeTimer()
        monotonicTimer.saveValue()
    }

    private func stopTimer() {
        timer.upstream.connect().cancel()
    }

    private var showRemainingSeconds: Bool {
        state.remainingSeconds > 0
    }

    private var isButtonHidden: Bool {
        switch state {
            case .loading:
                return true
            case .idle, .active, .startTimer:
                return false
            case let .ticked(remainingSeconds):
                return remainingSeconds > 0
        }
    }

    private static func makeTimer() -> Publishers.Autoconnect<Timer.TimerPublisher> {
        Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
    }
}

// MARK: - Inits

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

    public init(
        _ title: some StringProtocol,
        countdown countdownSeconds: Int = 15,
        status: DataStatus<some Hashable>,
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

extension TimerButton {
    public init<V: Hashable>(
        countdown countdownSeconds: Int = 15,
        status: DataStatus<V>,
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

// MARK: - Convenience

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
    public static func resend<V: Hashable>(
        countdown countdownSeconds: Int = 15,
        status: DataStatus<V>,
        action: @escaping () -> Void
    ) -> some View {
        resend(
            countdown: countdownSeconds,
            status: .init(status),
            action: action
        )
    }
}
