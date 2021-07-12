//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Intents

extension SiriShortcuts {
    /// Suggesting Shortcuts to Users.
    ///
    /// Make suggestions for shortcuts the user may want to add to Siri.
    ///
    /// After the user performs an action in your app, the app should donate a
    /// shortcut that accelerates user access to the action. However, sometimes
    /// there are actions in your app the user hasn’t performed that might be of
    /// interest to them. For example, perhaps your soup-ordering app features a
    /// special soup every day. The user has never ordered the daily soup special,
    /// but they might be interested in the option to add a _soup-of-the-day_
    /// shortcut to Siri. Your app can provide this option by making a shortcut
    /// suggestion.
    ///
    /// - Note: Shortcut suggestions are available to the user only in the
    ///   **Settings** app under the **Siri & Search** section. This differs from
    ///   donated shortcuts, which Siri shows to the user in places such as
    ///   Spotlight search, Lock Screen, and the Siri watch face.
    ///
    /// - SeeAlso: https://developer.apple.com/documentation/sirikit/shortcut_management/suggesting_shortcuts_to_users
    final class Suggestions: Appliable {
        private var didUpdate = false
        var intents: [INIntent] = [] {
            didSet {
                guard oldValue != intents else { return }
                didUpdate = false
            }
        }

        /// Suggest a shortcut to an action that the user hasn't performed but may want
        /// to add to Siri.
        func suggest() {
            let suggestions = intents.compactMap {
                INShortcut(intent: $0)
            }

            INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
        }

        func updateIfNeeded() {
            guard !didUpdate else { return }
            update()
        }

        func update() {
            didUpdate = true
            suggest()
        }

        /// Replace given intents for the intent group identifier.
        func replace(intents: [INIntent], groupIdentifier: String) {
            remove(groupIdentifier: groupIdentifier)
            self.intents.append(contentsOf: intents)
        }

        /// Replace given intents for the intent custom identifier.
        func replace(intents: [INIntent], identifiers: [String]) {
            remove(identifiers: identifiers)
            self.intents.append(contentsOf: intents)
        }

        /// Replace given intent for the intent custom identifier.
        func replace(intent: INIntent, identifier: String) {
            remove(identifier: identifier)
            self.intents.append(contentsOf: intents)
        }

        /// Remove shortcuts using the intent custom identifier.
        func remove(identifier: String) {
            remove(identifiers: [identifier])
        }

        /// Remove shortcuts using the intent custom identifiers.
        func remove(identifiers: [String]) {
            intents.removeAll { intent -> Bool in
                guard
                    let customIdentifier = intent.customIdentifier,
                    identifiers.contains(customIdentifier)
                else {
                    return false
                }

                return true
            }
        }

        /// Remove shortcuts using the intent group identifier.
        func remove(groupIdentifier: String) {
            intents.removeAll { intent -> Bool in
                guard
                    let intentGroupIdentifier = intent.groupIdentifier,
                    intentGroupIdentifier == groupIdentifier
                else {
                    return false
                }

                return true
            }
        }

        /// Remove all shortcuts suggestions.
        func removeAll() {
            intents = []
            INVoiceShortcutCenter.shared.setShortcutSuggestions([])
        }
    }
}
