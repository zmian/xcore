//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct XLabeledContentView: View {
    @Environment(\.theme) private var theme
    @State private var isPresented = false

    var body: some View {
        VStack {
            XLabeledContent("Apple", subtitle: "AAPL") {
                Button {
                    isPresented = true
                } label: {
                    Image(system: .infoCircle)
                }
            }
            .popup(isPresented: $isPresented) {
                Text("Hello")

                Button("Dismiss") {
                    isPresented = false
                }
            }

            List {
                XLabeledContent {
                    Text(
                        """
                        Apple Inc. is an American multinational technology company that specializes in \
                        consumer electronics, computer software, and online services. Apple is the \
                        world's largest technology company by revenue and, since January 2021, the \
                        world's most valuable company.
                        """
                    )
                    .multilineTextAlignment(.trailing)
                }

                XLabeledContent("Language", value: "The Swift Programing Language by Apple")
                    .xlabeledContentStyle(alignment: .firstTextBaseline)

                XLabeledContent("Version")

                XLabeledContent("Version", value: Bundle.main.versionBuildNumber)
                    .xlabeledContentStyle(dim: .value)

                XLabeledContent("First Name", value: "Sam")
                    .xlabeledContentStyle(dim: .label)

                XLabeledContent("Price", money: 10)
                    .foregroundStyle(theme.positiveSentimentColor)

                XLabeledContent("Quantity", value: 1000)
                    .foregroundStyle(theme.textSecondaryColor)

                favorites

                complexView
            }
        }
    }

    @ViewBuilder
    private var favorites: some View {
        XLabeledContent("Favorite") {
            Image(system: .star)
        }

        XLabeledContent("Favorite", value: Image(system: .star))

        XLabeledContent("Favorite", systemImage: .star)

        XLabeledContent("Favorite", image: .blueJay)
    }

    @ViewBuilder
    private var complexView: some View {
        XLabeledContent(image: Image(system: .docOnDoc)) {
            VStack(alignment: .leading) {
                Text("Apple")
                Text("AAPL")
                    .font(.app(.footnote))
                    .foregroundStyle(theme.textSecondaryColor)
            }
        }

        XLabeledContent(systemImage: .docOnDoc) {
            VStack(alignment: .leading) {
                Text("Apple")
                Text("AAPL")
                    .font(.app(.footnote))
                    .foregroundStyle(theme.textSecondaryColor)
            }
        }

        XLabeledContent("Apple", subtitle: "AAPL") {
            Image(system: .docOnDoc)
        }

        XLabeledContent("Apple", subtitle: "AAPL", value: Image(system: .docOnDoc))
    }
}

// MARK: - Preview

#Preview {
    XLabeledContentView()
        .embedInNavigation()
}
