//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import WebKit

extension WebView {
    public struct Configuration: Hashable {
        let url: URL
        let cachePolicy: NSURLRequest.CachePolicy
        let timeoutInterval: TimeInterval
        let cookies: [HTTPCookie]
        let localStorageItems: [String: String]
        let messageHandlers: Set<MessageHandler>
        /// Defaults to system when `nil`.
        let userAgent: String?

        public init(
            url: URL,
            cachePolicy: NSURLRequest.CachePolicy = .reloadRevalidatingCacheData,
            timeoutInterval: TimeInterval = 60,
            cookies: [HTTPCookie],
            localStorageItems: [String: String] = [:],
            messageHandlers: Set<MessageHandler> = [],
            userAgent: String? = nil
        ) {
            self.url = url
            self.cachePolicy = cachePolicy
            self.timeoutInterval = timeoutInterval
            self.cookies = cookies
            self.localStorageItems = localStorageItems
            self.messageHandlers = messageHandlers
            self.userAgent = userAgent
        }
    }
}

// MARK: - MessageHandler

extension WebView.Configuration {
    /// A structure representing an interface for receiving and replying to messages
    /// from JavaScript code running in a webpage.
    public struct MessageHandler: Hashable {
        private let messageStream = AsyncPassthroughStream<Message>()
        /// The name of the message handler. This must be unique within the user content
        /// controller and must not be an empty string.
        public let name: String

        /// Creates a message handler with the given name.
        ///
        /// - Parameter name: The name of the message handler to which the message is
        ///   sent. This must be unique within the user content controller and must not
        ///   be an empty string.
        public init(name: String) {
            self.name = name
        }

        func send(_ payload: Message) {
            messageStream.send(payload)
        }

        public var onReceive: AsyncStream<Message> {
            messageStream.makeAsyncStream()
        }

        public static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.name == rhs.name
        }

        public func hash(into hasher: inout Hasher) {
            hasher.combine(name)
        }

        /// A structure representing a message sent by JavaScript code from a webpage.
        public struct Message {
            /// The body of the message.
            public let body: Any

            /// A reply handler block to execute with the response to send back to the
            /// webpage.
            ///
            /// This block has no return value and takes the following parameters:
            ///
            /// - Parameters:
            ///   - reply: An object that contains the data to return to the webpage.
            ///     Allowed types for this parameter are `NSNumber`, `NSString`, `NSDate`,
            ///     `NSArray`, and `NSDictionary`. Specify `nil` if an error occurred.
            ///   - errorMessage: `nil` on success, or a string that describes the error
            ///     that occurred.
            public let reply: ReplyHandler

            /// A structure representing reply handler to execute with the response to send
            /// back to the webpage.
            public struct ReplyHandler {
                private let handler: (_ reply: Any?, _ errorMessage: String?) -> Void

                public init(handler: @escaping (_ reply: Any?, _ errorMessage: String?) -> Void) {
                    self.handler = handler
                }

                public func callAsFunction(_ replyMessage: Any?) {
                    handler(replyMessage, nil)
                }

                public func callAsFunction(error errorMessage: String) {
                    handler(nil, errorMessage)
                }
            }
        }
    }
}
