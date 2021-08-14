//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import UIKit
import Combine

/// Provides functionality for sending and receiving events.
public struct EventsClient<Event> where Event: Hashable & CustomStringConvertible {
    /// Send events.
    public var send: (Event) -> Void

    /// Receive the sent events.
    public var receive: AnyPublisher<Event, Never>

    public init(send: @escaping (Event) -> Void, receive: AnyPublisher<Event, Never>) {
        self.send = send
        self.receive = receive
    }
}

// MARK: - Live

extension EventsClient {
    public static var live: Self {
        let subject = PassthroughSubject<Event, Never>()

        return .init(
            send: { subject.send($0) },
            receive: subject.share().eraseToAnyPublisher()
        )
    }
}
