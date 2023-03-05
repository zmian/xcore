//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import Combine

/// Provides functionality for sending and receiving events.
///
/// **Usage**
///
/// ```swift
/// enum MyEvent {
///     case red
///     case green
///     case yellow
/// }
///
/// typealias MyEventClient = EventsClient<MyEvent>
///
/// // MARK: - Dependency
///
/// extension DependencyValues {
///     private struct MyEventClientKey: DependencyKey {
///         static let defaultValue: MyEventClient = .live
///     }
///
///     var myEvent: MyEventClient {
///         get { self[MyEventClientKey.self] }
///         set { self[MyEventClientKey.self] = newValue }
///     }
///
///     @discardableResult
///     static func myEvent(_ value: MyEventClient) -> Self.Type {
///         self[\.myEvent] = value
///         return Self.self
///     }
/// }
///
/// class ViewModel {
///     @Dependency(\.myEvent) var myEvent
///
///     func usage() {
///         myEvent.receive.sink { event in
///             print(event)
///         }
///
///         // Send event
///         myEvent.send(.green)
///
///         // prints "green"
///     }
/// }
/// ```
public struct EventsClient<Event> {
    /// Sends the give event.
    public var send: @Sendable (Event) -> Void

    /// Receive events.
    public var receive: AnyPublisher<Event, Never>

    /// Creates a client that sends and receive events.
    ///
    /// - Parameters:
    ///   - send: The closure to send the give event.
    ///   - receive: Receive events.
    public init(
        send: @escaping @Sendable (Event) -> Void,
        receive: AnyPublisher<Event, Never>
    ) {
        self.send = send
        self.receive = receive
    }
}

// MARK: - Variants

extension EventsClient {
    /// Returns noop variant of `EventsClient`.
    public static var noop: Self {
        .init(
            send: { _ in },
            receive: .none
        )
    }

    /// Returns unimplemented variant of `EventsClient`.
    public static var unimplemented: Self {
        .init(
            send: { _ in
                XCTFail("\(Self.self).send is unimplemented")
            },
            receive: .unimplemented("\(Self.self).receive")
        )
    }

    /// Returns live variant of `EventsClient`.
    public static var live: Self {
        let subject = PassthroughSubject<Event, Never>()

        return .init(
            send: { subject.send($0) },
            receive: subject.share().eraseToAnyPublisher()
        )
    }
}
