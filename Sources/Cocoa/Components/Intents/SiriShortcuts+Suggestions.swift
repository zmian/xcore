//
// SiriShortcuts+Suggestions.swift
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

import Intents

/// Suggesting Shortcuts to Users.
///
/// Make suggestions for shortcuts the user may want to add to Siri.
///
/// After the user performs an action in your app, the app should donate a shortcut that
/// accelerates user access to the action. However, sometimes there are actions in your app the
/// user hasn’t performed that might be of interest to them. For example, perhaps your
/// soup-ordering app features a special soup every day. The user has never ordered the daily soup
/// special, but they might be interested in the option to add a _soup-of-the-day_ shortcut to Siri.
/// Your app can provide this option by making a shortcut suggestion.
///
/// - Note:
/// Shortcut suggestions are available to the user only in the **Settings** app under the **Siri & Search**
/// section. This differs from donated shortcuts, which Siri shows to the user in places such as Spotlight
/// search, Lock Screen, and the Siri watch face.
///
/// - SeeAlso: https://developer.apple.com/documentation/sirikit/shortcut_management/suggesting_shortcuts_to_users
extension SiriShortcuts {
    @available(iOS 12.0, *)
    final public class Suggestions: With {
        private var didUpdate = false
        public var intents: [INIntent] = [] {
            didSet {
                guard oldValue != intents else { return }
                didUpdate = false
            }
        }

        /// Suggest a shortcut to an action that the user hasn't
        /// performed but may want to add to Siri.
        public func suggest() {
            let suggestions = intents.compactMap {
                INShortcut(intent: $0)
            }

            INVoiceShortcutCenter.shared.setShortcutSuggestions(suggestions)
        }

        public func updateIfNeeded() {
            guard !didUpdate else { return }
            update()
        }

        public func update() {
            didUpdate = true
            suggest()
        }

        /// Replace given intents for the intent group identifier.
        public func replace(intents: [INIntent], groupIdentifier: String) {
            remove(groupIdentifier: groupIdentifier)
            self.intents.append(contentsOf: intents)
        }

        /// Replace given intents for the intent custom identifier.
        public func replace(intents: [INIntent], identifiers: [String]) {
            remove(identifiers: identifiers)
            self.intents.append(contentsOf: intents)
        }

        /// Replace given intent for the intent custom identifier.
        public func replace(intent: INIntent, identifier: String) {
            remove(identifier: identifier)
            self.intents.append(contentsOf: intents)
        }

        /// Remove shortcuts using the intent custom identifier.
        public func remove(identifier: String) {
            remove(identifiers: [identifier])
        }

        /// Remove shortcuts using the intent custom identifiers.
        public func remove(identifiers: [String]) {
            intents.removeAll { intent -> Bool in
                if let customIdentifier = intent.customIdentifier, identifiers.contains(customIdentifier) {
                    return true
                }

                return false
            }
        }

        /// Remove shortcuts using the intent group identifier.
        public func remove(groupIdentifier: String) {
            intents.removeAll { intent -> Bool in
                if let intentGroupIdentifier = intent.groupIdentifier, intentGroupIdentifier == groupIdentifier {
                    return true
                }

                return false
            }
        }

        /// Remove all shortcuts suggestions.
        public func removeAll() {
            intents = []
            INVoiceShortcutCenter.shared.setShortcutSuggestions([])
        }
    }
}
