//
// Xcore
// Copyright © 2022 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct MoneyView: View {
    @State private var amount: Decimal = 9.99
    @State private var crypto: Decimal = 0.00000001

    var body: some View {
        List {
            LabeledContent("Default", money: amount)

            LabeledContent("Default Large Font") {
                Money(-amount)
                    .font(.app(.largeTitle))
            }

            LabeledContent("Superscript", subtitle: "Currency Symbol") {
                Money(amount)
                    .font(.app(.largeTitle).currencySymbolSuperscript())
            }

            LabeledContent("Superscript", subtitle: "Minor Unit") {
                Money(amount)
                    .font(.superscript(.largeTitle))
            }

            LabeledContent("Superscript", subtitle: "Minor Unit & Currency Symbol") {
                Money(amount)
                    .font(.superscript(.largeTitle).currencySymbolSuperscript())
            }

            LabeledContent("Superscript", subtitle: "Currency Symbol") {
                Money(amount)
                    .font(.app(.jumbo3).currencySymbolSuperscript())
            }

            LabeledContent("Colored") {
                HStack {
                    Money(amount)
                        .color(color)

                    Money(-amount)
                        .color(color)

                    Money(0)
                        .color(color)
                }
            }

            LabeledContent("BTC") {
                Money(crypto)
                    .currencySymbol("BTC", position: .suffix)
            }

            LabeledContent("Format") {
                Text(
                    Money(amount)
                        .color(color)
                        .font(.superscript(.body).currencySymbolSuperscript())
                        .attributedString(format: "The price is %@ per month")
                )
                .foregroundStyle(.gray)
            }
        }
        .labeledContentStyle(dim: .none)
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
