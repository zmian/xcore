//
// Intents+Extensions.swift
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
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
        INInteraction(intent: self, response: nil).apply {
            guard let customIdentifier = customIdentifier else { return }
            $0.identifier = customIdentifier
        }
    }
}

extension INIntent {
    private struct AssociatedKey {
        static var customIdentifier = "customIdentifier"
        static var groupIdentifier = "groupIdentifier"
    }

    /// The unique custom identifier of the intent.
    ///
    /// The custom identifier is used to match with the donation so
    /// the interaction can be deleted if an intent is removed.
    public var customIdentifier: String? {
        get { associatedObject(&AssociatedKey.customIdentifier) }
        set { setAssociatedObject(&AssociatedKey.customIdentifier, value: newValue) }
    }

    /// The unique group identifier of the intent.
    ///
    /// The group identifier is used to match group of intents that can be deleted
    /// if an intent is removed.
    public var groupIdentifier: String? {
        get { associatedObject(&AssociatedKey.groupIdentifier) }
        set { setAssociatedObject(&AssociatedKey.groupIdentifier, value: newValue) }
    }
}

extension INCurrencyAmount {
    public convenience init(_ value: NSDecimalNumber) {
        self.init(amount: value, currencyCode: "USD")
    }

    public convenience init(_ value: FloatLiteralType) {
        self.init(NSDecimalNumber(value: value))
    }
}

extension INBalanceAmount {
    public convenience init(_ value: Double) {
        self.init(amount: NSDecimalNumber(decimal: Decimal(value)), currencyCode: "USD")
    }
}
