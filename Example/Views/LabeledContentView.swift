//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct LabeledContentView: View {
    @Environment(\.theme) private var theme
    @State private var isPresented = false

    var body: some View {
        VStack {
            LabeledContent("Apple", subtitle: "AAPL") {
                Button {
                    isPresented = true
                } label: {
                    Image(system: .infoCircle)
                }
            }
            .popup(isPresented: $isPresented) {
                StandardPopupAlert(Text("Hello")) {
                    Button("Dismiss") {
                        isPresented = false
                    }
                    .buttonStyle(.capsuleOutline)
                }
            }
            .padding(.horizontal, .defaultSpacing)

            List {
                Text(
                    """
                    Apple Inc. is an American multinational technology company that specializes in \
                    consumer electronics, computer software, and online services. Apple is the \
                    world's largest technology company by revenue and, since January 2021, the \
                    world's most valuable company.
                    """
                )
                .multilineTextAlignment(.trailing)

                LabeledContent("Language", value: "The Swift Programing Language by Apple")
                    .labeledContentStyle(dim: .value, alignment: .firstTextBaseline)

                Text("Version")

                LabeledContent("Version", value: Bundle.main.versionBuildNumber)
                    .labeledContentStyle(dim: .value)

                LabeledContent("First Name", value: "Sam")
                    .labeledContentStyle(dim: .label)

                LabeledContent("Price", money: 10)
                    .foregroundStyle(theme.positiveSentimentColor)

                LabeledContent("Quantity", value: 1000, format: .asNumber)
                    .foregroundStyle(theme.textSecondaryColor)

                LabeledContent("Quantity", value: 1000, format: .asAbbreviated)
                    .foregroundStyle(.indigo)

                favorites

                complexView
            }
        }
    }

    @ViewBuilder
    private var favorites: some View {
        LabeledContent("Favorite") {
            Image(system: .star)
        }

        LabeledContent("Favorite", systemImage: .star)

        LabeledContent("Favorite", image: .blueJay)
    }

    @ViewBuilder
    private var complexView: some View {
        LabeledContent(image: Image(system: .docOnDoc)) {
            VStack(alignment: .leading) {
                Text("Apple")
                Text("AAPL")
                    .font(.app(.footnote))
                    .foregroundStyle(theme.textSecondaryColor)
            }
        }

        LabeledContent(systemImage: .docOnDoc) {
            VStack(alignment: .leading) {
                Text("Apple")
                Text("AAPL")
                    .font(.app(.footnote))
                    .foregroundStyle(theme.textSecondaryColor)
            }
        }

        LabeledContent("Apple", subtitle: "AAPL") {
            Image(system: .docOnDoc)
        }

        LabeledContent("Apple", subtitle: "AAPL", value: Image(system: .docOnDoc))
    }
}

// MARK: - Preview

#Preview {
    LabeledContentView()
        .embedInNavigation()
}
