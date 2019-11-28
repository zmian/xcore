//
// Interstitial+Item+DisplayPolicy.swift
//
// Copyright © 2018 Xcore
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import UIKit

extension Interstitial.Item {
    /// A struct to check any necessary condition before presenting the interstitial
    /// item.
    public struct DisplayPolicy {
        /// A boolean property indicating whether interstitial item is dismissable.
        public let isDismissable: Bool

        /// An optional property to specify delay interval before this interstitial item
        /// is displayed again.
        public let replayDelay: TimeInterval?

        /// This method is invoked before this interstitial item is presented.
        public let precondition: (_ userState: Interstitial.UserState) -> Bool

        public init(
            dismissable: Bool = false,
            replayDelay: TimeInterval? = nil,
            precondition: @escaping (_ userState: Interstitial.UserState) -> Bool
        ) {
            self.isDismissable = dismissable
            self.replayDelay = replayDelay
            self.precondition = precondition
        }

        public static func precondition(_ condition: @escaping (_ userState: Interstitial.UserState) -> Bool) -> Self {
            .init(precondition: condition)
        }

        public static var never: Self {
            .init(precondition: { _ in false })
        }

        public static var always: Self {
            always(dismissable: false)
        }

        public static func always(dismissable: Bool) -> Self {
            .init(dismissable: dismissable, precondition: { _ in true })
        }
    }
}

// MARK: - FeatureFlag

extension Interstitial.Item.DisplayPolicy {
    func updateFromFeatureFlag(id interstitialId: Interstitial.Identifier) -> Self {
        let key = FeatureFlag.Key(rawValue: "interstitial_" + interstitialId.rawValue)

        guard let dictionary: [String: Any] = key.value(), !dictionary.isEmpty else {
            return self
        }

        let isEnabled = dictionary["enabled"] as? Bool ?? true

        return .init(
            dismissable: dictionary["dismissable"] as? Bool ?? isDismissable,
            replayDelay: dictionary["replayDelay"] as? TimeInterval ?? replayDelay,
            precondition: isEnabled ? precondition : { _ in false }
        )
    }
}
