//
// SiriDomain.swift
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

@available(iOS 10.0, *)
open class SiriDomain: Hashable, With {
    private var didUpdateDonations = false
    private var didUpdateSuggestions = false
    private var updateDonationsWhenIntentsUpdated = true
    public let identifier: String
    private var dynamicIntents: (() -> [INIntent])? = nil
    /// A list of intents managed by the domain.
    private var staticIntents: [INIntent] {
        didSet {
            guard oldValue != staticIntents else { return }
            didUpdateDonations = false
        }
    }

    public init(identifier: String, intents: @escaping () -> [INIntent]) {
        self.identifier = identifier
        self.staticIntents = []
        self.dynamicIntents = intents
    }

    public init(identifier: String, intents: [INIntent]) {
        self.identifier = identifier
        self.staticIntents = intents
    }

    public convenience init(identifier: String, intent: INIntent) {
        self.init(identifier: identifier, intents: [intent])
    }

    public convenience init(identifier: String) {
        self.init(identifier: identifier, intents: [])
    }

    open func intents() -> [INIntent] {
        return dynamicIntents?() ?? staticIntents
    }

    open func setIntents(_ intents: [INIntent]) {
        return staticIntents = intents
    }

    // MARK: Donations

    /// Donates intents as shortcuts to the system.
    private func donate() {
        intents().forEach { intent in
            let interaction = intent.interaction
            interaction.groupIdentifier = identifier
            interaction.donate { [weak self] error in
                guard let strongSelf = self, let error = error else { return }
                Console.error("[\(strongSelf.identifier)]", "Interaction donation failed: \(error)")
            }
        }
    }

    /// Removes all previous donations and then donates them again.
    open func updateDonations() {
        removeAllDonations { [weak self] error in
            self?.donate()
        }

        didUpdateDonations = true
    }

    /// Removes all previous donations and then donates them again if
    /// they weren't done updated before.
    open func updateDonationsIfNeeded() {
        guard !didUpdateDonations else { return }
        updateDonations()
    }

    /// Remove interaction using the intent identifier.
    open func removeDonation(intentIdentifier: String, completion: ((Error?) -> Void)? = nil) {
        removeDonation(intentIdentifiers: [intentIdentifier], completion: completion)
    }

    /// Remove interaction using the intent identifiers.
    open func removeDonation(intentIdentifiers: [String], completion: ((Error?) -> Void)? = nil) {
        INInteraction.delete(with: intentIdentifiers) { [weak self] error in
            completion?(error)
            guard let strongSelf = self, let error = error else { return }
            Console.error("[\(strongSelf.identifier)]", "Interaction donation deletion failed: \(error)")
        }
    }

    /// Remove all interactions for the domain using the identifier.
    open func removeAllDonations(completion: ((Error?) -> Void)? = nil) {
        INInteraction.delete(with: identifier) { [weak self] error in
            completion?(error)
            guard let strongSelf = self, let error = error else { return }
            Console.error("[\(strongSelf.identifier)]", "Failed to delete donations: \(error)")
        }
    }

    // MARK: Hashable & Equatable

    open func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }

    open static func == (lhs: SiriDomain, rhs: SiriDomain) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}
