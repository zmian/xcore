//
// Intents+Extensions.swift
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

import Foundation
import Intents

extension INIntent {
    /// The donation shortcut interaction.
    ///
    /// Converts `self` into appropriate intent and donates it as an interaction
    /// to the system so that the intent can be suggested in the future or turned
    /// into a voice shortcut for quickly running the task in the future.
    public var interaction: INInteraction {
        return INInteraction(intent: self, response: nil).apply {
            guard let customIdentifier = customIdentifier else { return }
            $0.identifier = customIdentifier
        }
    }
}

extension INIntent {
    private struct AssociatedKey {
        static var customIdentifier = "customIdentifier"
    }

    /// The unique custom identifier of the intent.
    ///
    /// The custom identifier is used to match with the donation so
    /// the interaction can be deleted if an intent is removed.
    public var customIdentifier: String? {
        get { return associatedObject(&AssociatedKey.customIdentifier) }
        set { setAssociatedObject(&AssociatedKey.customIdentifier, value: newValue) }
    }
}
