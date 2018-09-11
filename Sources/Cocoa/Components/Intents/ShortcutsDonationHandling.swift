//
// ShortcutsDonationHandling.swift
//
// Copyright © 2018 Zeeshan Mian
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

import Intents

@available(iOS 12.0, *)
public protocol ShortcutsDonationHandling {
    associatedtype IntentType: INIntent

    /// The donation shortcut interaction intent.
    ///
    /// Converts `self` into an appropriate intent.
    var intent: IntentType { get }

    /// Donates shortcut to the system.
    ///
    /// Donates interaction to the system so that the intent can be suggested
    /// in the future or turned into a voice shortcut for quickly running it
    /// in the future.
    func donateShortcut()

    /// The identifier used to create grouped interactions.
    static var groupIdentifier: String { get }
}

@available(iOS 12.0, *)
extension ShortcutsDonationHandling {
    public static var groupIdentifier: String {
        return "\(Self.self)"
    }

    public func donateShortcut() {
        let interaction = intent.interaction
        interaction.groupIdentifier = Self.groupIdentifier
        interaction.donate { error in
            guard let error = error else { return }
            Console.error("[\(Self.self)]", "Interaction donation failed: \(error)")
        }
    }
}

@available(iOS 12.0, *)
extension ShortcutsDonationHandling {
    /// Remove interaction using the intent custom identifier.
    public func removeShortcutDonation(completion: ((Error?) -> Void)? = nil) {
        guard let customIdentifier = intent.customIdentifier else {
            return
        }

        INInteraction.delete(with: [customIdentifier]) { error in
            completion?(error)
            guard let error = error else { return }
            Console.error("[\(Self.self)]", "Interaction donation deletion failed: \(error)")
        }
    }

    /// Remove all interactions using the interaction group identifier.
    public static func removeAllShortcutDonations(completion: ((Error?) -> Void)? = nil) {
        INInteraction.delete(with: groupIdentifier) { error in
            completion?(error)
            guard let error = error else { return }
            Console.error("[\(Self.self)]", "Failed to delete interactions: \(error)")
        }
    }
}
