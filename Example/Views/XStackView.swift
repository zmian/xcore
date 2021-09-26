//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct XStackView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        List {
            XStack {
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

            XStack("Version")

            XStack("Version", value: Bundle.main.versionBuildNumber)
                .xstackStyle(.keyTitle)

            XStack("First Name", value: "John")
                .xstackStyle(.keyValue)

            XStack("Price", money: 10)

            XStack("Quantity", value: 1000)
                .foregroundColor(theme.textSecondaryColor)

            favorites

            complexView
        }
    }

    @ViewBuilder
    private var favorites: some View {
        XStack("Favorite") {
            Image(system: .star)
        }

        XStack("Favorite", value: Image(system: .star))

        XStack("Favorite", systemImage: .star)

        XStack("Favorite", image: .disclosureIndicator)
    }

    @ViewBuilder
    private var complexView: some View {
        XStack(image: Image(system: .docOnDoc)) {
            VStack(alignment: .leading) {
                Text("Apple")
                Text("AAPL")
                    .font(.app(.footnote))
                    .foregroundColor(theme.textSecondaryColor)
            }
        }

        XStack(systemImage: .docOnDoc) {
            VStack(alignment: .leading) {
                Text("Apple")
                Text("AAPL")
                    .font(.app(.footnote))
                    .foregroundColor(theme.textSecondaryColor)
            }
        }

        XStack("Apple", subtitle: "AAPL") {
            Image(system: .docOnDoc)
        }

        XStack("Apple", subtitle: "AAPL", value: Image(system: .docOnDoc))

        XStack("Apple", subtitle: "AAPL", systemImage: .docOnDoc)
    }
}

// MARK: - Previews

struct XStackView_Previews: PreviewProvider {
    static var previews: some View {
        XStackView()
            .embedInNavigation()
    }
}

// MARK: - KeyValue

struct KeyValueXStackStyle: XStackStyle {
    @Environment(\.theme) private var theme
    var isTitleKey: Bool

    public func makeBody(configuration: Self.Configuration) -> some View {
        HStack(spacing: .s5) {
            configuration.title
                .applyIf(!isTitleKey) {
                    $0.foregroundColor(theme.textSecondaryColor)
                }
            Spacer()
            configuration.value
                .symbol(.chevronRight)
                .applyIf(isTitleKey) {
                    $0.foregroundColor(theme.textSecondaryColor)
                }
        }
    }
}

// MARK: - Dot Syntax Support

extension XStackStyle where Self == KeyValueXStackStyle {
    static var keyTitle: Self { .init(isTitleKey: true) }

    static var keyValue: Self { .init(isTitleKey: false) }
}
