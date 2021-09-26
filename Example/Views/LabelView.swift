//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

struct LabelView: View {
    @Environment(\.theme) private var theme

    var body: some View {
        List {
            Label {
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
            .labelStyle(.titleOnly)

            Label("Version")

            Label("Version", value: Bundle.main.versionBuildNumber)
                .labelStyle(.keyTitle)

            Label("First Name", value: "John")
                .labelStyle(.keyValue)

            Label("Price", money: 10)

            Label("Quantity", value: 1000)
                .foregroundColor(theme.textSecondaryColor)

            favorites

            complexView
        }
        .labelStyle(.row)
    }

    @ViewBuilder
    private var favorites: some View {
        Label("Favorite") {
            Image(system: .star)
        }

        Label("Favorite", icon: Image(system: .star))

        Label("Favorite", systemImage: .star)

        Label("Favorite", image: .disclosureIndicator)
    }

    @ViewBuilder
    private var complexView: some View {
        Label(image: Image(system: .docOnDoc)) {
            VStack(alignment: .leading) {
                Text("Apple")
                Text("AAPL")
                    .font(.app(.footnote))
                    .foregroundColor(theme.textSecondaryColor)
            }
        }

        Label(systemImage: .docOnDoc) {
            VStack(alignment: .leading) {
                Text("Apple")
                Text("AAPL")
                    .font(.app(.footnote))
                    .foregroundColor(theme.textSecondaryColor)
            }
        }

        Label("Apple", subtitle: "AAPL") {
            Image(system: .docOnDoc)
        }

        Label("Apple", subtitle: "AAPL", icon: Image(system: .docOnDoc))

        Label("Apple", subtitle: "AAPL", systemImage: .docOnDoc)
    }
}

// MARK: - Previews

struct LabelView_Previews: PreviewProvider {
    static var previews: some View {
        LabelView()
            .embedInNavigation()
    }
}

// MARK: - KeyValue

struct KeyValueLabelStyle: LabelStyle {
    @Environment(\.theme) private var theme
    var isTitleKey: Bool

    public func makeBody(configuration: Self.Configuration) -> some View {
        HStack(spacing: .s5) {
            configuration.title
                .applyIf(!isTitleKey) {
                    $0.foregroundColor(theme.textSecondaryColor)
                }
            Spacer()
            configuration.icon
                .symbol(.chevronRight)
                .applyIf(isTitleKey) {
                    $0.foregroundColor(theme.textSecondaryColor)
                }
        }
    }
}

// MARK: - Dot Syntax Support

extension LabelStyle where Self == KeyValueLabelStyle {
    static var keyTitle: Self { .init(isTitleKey: true) }

    static var keyValue: Self { .init(isTitleKey: false) }
}

// MARK: - Row

struct RowLabelStyle: LabelStyle {
    var alignment: VerticalAlignment
    var spacing: CGFloat?

    func makeBody(configuration: Self.Configuration) -> some View {
        HStack(alignment: alignment, spacing: spacing) {
            configuration.title
            Spacer()
            configuration.icon
        }
    }
}

// MARK: - Dot Syntax Support

extension LabelStyle where Self == RowLabelStyle {
    static var row: Self { row() }

    /// Sets the style for `XStack` within this view to a style with a custom
    /// appearance and standard interaction behavior.
    static func row(
        alignment: VerticalAlignment = .center,
        spacing: CGFloat? = .s5
    ) -> Self {
        RowLabelStyle(
            alignment: alignment,
            spacing: spacing
        )
    }
}
