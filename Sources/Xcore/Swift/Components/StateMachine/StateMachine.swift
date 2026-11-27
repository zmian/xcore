//
// Xcore
// Copyright © 2025 Xcore
// MIT license, see LICENSE file for details
//

/// A state value that defines which transitions are permitted.
///
/// Types that model workflow phases (for example ``AppStatus/SessionState``)
/// adopt this protocol so a ``StateMachine`` can reject invalid transitions.
public protocol StateMachineState: Hashable, Sendable {
    /// Whether `self` may transition to `next`.
    func canTransition(to next: Self) -> Bool
}

/// An error thrown when a state machine receives a disallowed transition.
public struct InvalidStateTransition<State: StateMachineState>: Error, CustomStringConvertible, Sendable {
    public let from: State
    public let to: State

    public init(from: State, to: State) {
        self.from = from
        self.to = to
    }

    public var description: String {
        "Invalid transition from \(from) to \(to)"
    }
}

/// A value that holds a single state and enforces transition rules.
///
/// Use this wrapper when invalid state combinations must be rejected at compile
/// time or runtime instead of being represented by unrelated Boolean flags.
///
/// **Usage**
///
/// ```swift
/// var machine = StateMachine(AppStatus.SessionState.signedOut)
/// try machine.transition(to: .unlocked)
/// ```
public struct StateMachine<State: StateMachineState>: Sendable {
    /// The current state.
    public private(set) var state: State

    /// Creates a state machine in the given initial state.
    public init(_ state: State) {
        self.state = state
    }

    /// Transitions to `next` when allowed; otherwise throws
    /// ``InvalidStateTransition``.
    public mutating func transition(to next: State) throws(InvalidStateTransition<State>) {
        guard state.canTransition(to: next) else {
            throw InvalidStateTransition(from: state, to: next)
        }

        state = next
    }

    /// Transitions to `next` when allowed.
    ///
    /// - Returns: Whether a transition occurred.
    @discardableResult
    public mutating func transitionIfAllowed(to next: State) -> Bool {
        guard state.canTransition(to: next) else {
            return false
        }

        state = next
        return true
    }
}
