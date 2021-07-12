//
// Xcore
// Copyright © 2018 Xcore
// MIT license, see LICENSE file for details
//

import Foundation
import Intents

extension INIntent {
    /// The donation shortcut interaction.
    ///
    /// Converts `self` into appropriate intent and donates it as an interaction to
    /// the system so that the intent can be suggested in the future or turned into
    /// a voice shortcut for quickly running the task in the future.
    var interaction: INInteraction {
        INInteraction(intent: self, response: nil).apply {
            guard let customIdentifier = customIdentifier else { return }
            $0.identifier = customIdentifier
        }
    }
}

// MARK: - Identifiers

extension INIntent {
    private enum AssociatedKey {
        static var groupIdentifier = "groupIdentifier"
        static var customIdentifier = "customIdentifier"
    }

    /// The unique group identifier of the intent.
    ///
    /// The group identifier is used to match group of intents that can be deleted
    /// if an intent is removed.
    var groupIdentifier: String? {
        get { associatedObject(&AssociatedKey.groupIdentifier) }
        set { setAssociatedObject(&AssociatedKey.groupIdentifier, value: newValue) }
    }

    /// The unique custom identifier of the intent.
    ///
    /// The custom identifier is used to match with the donation so the interaction
    /// can be deleted if an intent is removed.
    var customIdentifier: String? {
        get { associatedObject(&AssociatedKey.customIdentifier) }
        set { setAssociatedObject(&AssociatedKey.customIdentifier, value: newValue) }
    }
}

// MARK: - Convenience

extension INCurrencyAmount {
    /// Initializes a currency amount object with the specified values.
    ///
    /// - Parameters:
    ///   - amount: The decimal number representing the amount of money.
    ///   - currencyCode: The ISO 4217 currency code to apply to the specified
    ///     amount. You can get a list of possible currency codes using the
    ///     `isoCurrencyCodes` method of `Locale`. For example, the string “USD”
    ///     corresponds to United States dollars.
    public convenience init(amount: NSDecimalNumber, currencyCode: Locale.CurrencyCode = .usd) {
        self.init(amount: amount, currencyCode: currencyCode.rawValue)
    }

    /// Initializes a currency amount object with the specified values.
    ///
    /// - Parameters:
    ///   - amount: The decimal number representing the amount of money.
    ///   - currencyCode: The ISO 4217 currency code to apply to the specified
    ///     amount. You can get a list of possible currency codes using the
    ///     `isoCurrencyCodes` method of `Locale`. For example, the string “USD”
    ///     corresponds to United States dollars.
    public convenience init(amount: FloatLiteralType, currencyCode: Locale.CurrencyCode = .usd) {
        self.init(amount: NSDecimalNumber(value: amount), currencyCode: currencyCode)
    }
}

extension INBalanceAmount {
    /// Initializes a balance amount with a monetary amount.
    ///
    /// - Parameters:
    ///   - amount: The monetary amount to assign to the balance.
    ///   - currencyCode: The ISO 4217 currency code that applies to the monetary
    ///     amount.
    public convenience init(amount: Double, currencyCode: Locale.CurrencyCode = .usd) {
        self.init(amount: NSDecimalNumber(decimal: Decimal(amount)), currencyCode: currencyCode.rawValue)
    }
}
