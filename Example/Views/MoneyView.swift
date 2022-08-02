//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

@available(iOS 15.0, *)
struct MoneyView: View {
    @State private var amount: Decimal = 9.99
    @State private var crypto: Decimal = 0.00000001

    var body: some View {
        List {
            XStack("Default", value: Money(amount))

            XStack("Default Large Font") {
                Money(-amount)
                    .font(.app(.largeTitle))
            }

            XStack("Superscript", subtitle: "Currency Symbol") {
                Money(amount)
                    .font(.app(.largeTitle).currencySymbolSuperscript())
            }

            XStack("Superscript", subtitle: "Minor Unit") {
                Money(amount)
                    .font(.superscript(.largeTitle))
            }

            XStack("Superscript", subtitle: "Minor Unit & Currency Symbol") {
                Money(amount)
                    .font(.superscript(.largeTitle).currencySymbolSuperscript())
            }

            XStack("Superscript", subtitle: "Currency Symbol") {
                Money(amount)
                    .font(.app(.jumbo3).currencySymbolSuperscript())
            }

            XStack("Colored") {
                HStack {
                    Money(amount)
                        .color(color)

                    Money(-amount)
                        .color(color)

                    Money(0)
                        .color(color)
                }
            }

            XStack("BTC") {
                Money(crypto)
                    .currencySymbol("BTC", position: .suffix)
            }

            XStack("Format") {
                Text(
                    Money(amount)
                        .color(color)
                        .font(.superscript(.body).currencySymbolSuperscript())
                        .attributedString(format: "The price is %@ per month")
                )
                .foregroundColor(.gray)
            }
        }
    }

    private var color: Money.Color {
        .init(positive: .green, negative: .red, zero: .primary)
    }
}

// MARK: - CustomTextStyle

extension Font.CustomTextStyle {
    /// `48`
    fileprivate static let jumbo3 = Self(size: 48, relativeTo: .largeTitle)
}
