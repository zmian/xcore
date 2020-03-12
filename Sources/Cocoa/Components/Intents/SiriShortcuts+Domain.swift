//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Intents

final public class SiriShortcuts {
    @available(iOS 12.0, *)
    public static let sharedSuggestions = Suggestions()
}

extension SiriShortcuts {
    @available(iOS 10.0, *)
    open class Domain: Hashable, Appliable {
        private var didUpdateDonations = false
        public let id: String
        private var dynamicIntents: (() -> [INIntent])?
        /// A list of intents managed by the domain.
        private var staticIntents: [INIntent] {
            didSet {
                guard oldValue != staticIntents else { return }
                didUpdateDonations = false
            }
        }

        public init(id: String, intents: @escaping () -> [INIntent]) {
            self.id = id
            self.staticIntents = []
            self.dynamicIntents = intents
        }

        public init(id: String, intents: [INIntent]) {
            self.id = id
            self.staticIntents = intents
        }

        public convenience init(id: String, intent: INIntent) {
            self.init(id: id, intents: [intent])
        }

        public convenience init(id: String) {
            self.init(id: id, intents: [])
        }

        open func intents() -> [INIntent] {
            dynamicIntents?() ?? staticIntents
        }

        open func setIntents(_ intents: [INIntent]) {
            staticIntents = intents
        }

        // MARK: Donations

        /// Donates intents as shortcuts to the system.
        private func donate() {
            intents().forEach { intent in
                let interaction = intent.interaction
                interaction.groupIdentifier = id
                interaction.donate { [weak self] error in
                    guard let strongSelf = self, let error = error else { return }
                    Console.error("[\(strongSelf.id)]", "Interaction donation failed: \(error)")
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
                Console.error("[\(strongSelf.id)]", "Interaction donation deletion failed: \(error)")
            }
        }

        /// Remove all interactions for the domain using the identifier.
        open func removeAllDonations(completion: ((Error?) -> Void)? = nil) {
            INInteraction.delete(with: id) { [weak self] error in
                completion?(error)
                guard let strongSelf = self, let error = error else { return }
                Console.error("[\(strongSelf.id)]", "Failed to delete donations: \(error)")
            }
        }

        // MARK: Hashable & Equatable

        open func hash(into hasher: inout Hasher) {
            hasher.combine(id)
        }

        public static func == (lhs: Domain, rhs: Domain) -> Bool {
            lhs.id == rhs.id
        }
    }
}

// MARK: Suggestions

@available(iOS 12.0, *)
extension SiriShortcuts.Domain {
    /// Prepares and removes any outdate intents in `SiriShortcuts.Suggestions` for
    /// this domain.
    ///
    /// - Note:
    /// You must call `SiriShortcuts.Suggestions.update()` to register the
    /// newly replaced suggestions with Siri.
    open func prepareSuggestions() {
        SiriShortcuts.sharedSuggestions.replace(intents: intents(), groupIdentifier: id)
    }
}
