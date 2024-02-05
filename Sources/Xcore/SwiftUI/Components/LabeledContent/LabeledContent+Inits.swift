//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Money

extension LabeledContent<Text, Money?> {
    /// Creates a labeled content with a title generated from a string and a value
    /// formatted as money.
    ///
    /// ```swift
    /// LabeledContent("Price", money: 10) // formats the value as "$10.00"
    /// ```
    public init(_ title: some StringProtocol, money: Decimal?) {
        self.init(title) {
            Money(money)
        }
    }

    /// Creates a labeled content with a title generated from a string and a value
    /// formatted as money.
    ///
    /// ```swift
    /// LabeledContent("Price", money: 10) // formats the value as "$10.00"
    /// ```
    @_disfavoredOverload
    public init(_ title: some StringProtocol, money: Double?) {
        self.init(title) {
            Money(money)
        }
    }
}

// MARK: - Image

extension LabeledContent<Text, Image?> {
    /// Creates a labeled content with a title generated from a string and a value
    /// with a system image.
    ///
    /// ```swift
    /// LabeledContent("Favorite", systemImage: .star)
    /// ```
    public init(_ title: some StringProtocol, systemImage: SystemAssetIdentifier?) {
        self.init(title) {
            systemImage.map(Image.init(system:))
        }
    }

    /// Creates a labeled content with a title generated from a string and a value
    /// with an image.
    ///
    /// ```swift
    /// LabeledContent("Favorite", image: .disclosureIndicator)
    /// ```
    public init(_ title: some StringProtocol, image: ImageAssetIdentifier?) {
        self.init(title) {
            image.map(Image.init(assetIdentifier:))
        }
    }
}

extension LabeledContent where Label: View, Content == Image {
    /// Creates a labeled content with a title and a value with an image.
    ///
    /// ```swift
    /// LabeledContent(image: Image(system: .docOnDoc)) {
    ///     VStack(alignment: .leading) {
    ///         Text("Apple")
    ///         Text("AAPL")
    ///             .font(.app(.footnote))
    ///             .foregroundStyle(theme.textSecondaryColor)
    ///     }
    /// }
    /// ```
    public init(
        image: Image,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.init {
            image
        } label: {
            label()
        }
    }

    /// Creates a labeled content with a title and a value with a system image.
    ///
    /// ```swift
    /// LabeledContent(systemImage: .docOnDoc) {
    ///     VStack(alignment: .leading) {
    ///         Text("Apple")
    ///         Text("AAPL")
    ///             .font(.app(.footnote))
    ///             .foregroundStyle(theme.textSecondaryColor)
    ///     }
    /// }
    /// ```
    public init(
        systemImage: SystemAssetIdentifier,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.init(image: Image(system: systemImage), label: label)
    }
}

// MARK: - Title & Subtitle with Strings

extension LabeledContent where Label == _XIVTSSV, Content: View {
    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value.
    ///
    /// ```swift
    /// LabeledContent("Apple", subtitle: "AAPL") {
    ///     Image(system: .docOnDoc)
    /// }
    /// ```
    public init(
        _ title: some StringProtocol,
        subtitle: (some StringProtocol)?,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init {
            content()
        } label: {
            _XIVTSSV(
                title: title,
                subtitle: subtitle,
                spacing: spacing
            )
        }
    }

    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value.
    ///
    /// ```swift
    /// LabeledContent("Apple", subtitle: "AAPL", value: Image(system: .docOnDoc))
    /// ```
    public init(
        _ title: some StringProtocol,
        subtitle: (some StringProtocol)?,
        spacing: CGFloat? = nil,
        value: Content
    ) {
        self.init(title, subtitle: subtitle, spacing: spacing, content: { value })
    }

    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value with a system image.
    ///
    /// ```swift
    /// LabeledContent("Apple", subtitle: "AAPL", systemImage: .docOnDoc)
    /// ```
    public init(
        _ title: some StringProtocol,
        subtitle: (some StringProtocol)?,
        systemImage: SystemAssetIdentifier,
        spacing: CGFloat? = nil
    ) where Content == Image {
        self.init(title, subtitle: subtitle, spacing: spacing, value: Image(system: systemImage))
    }

    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value with an image.
    ///
    /// ```swift
    /// LabeledContent("Apple", subtitle: "AAPL", image: .disclosureIndicator)
    /// ```
    public init(
        _ title: some StringProtocol,
        subtitle: (some StringProtocol)?,
        image: ImageAssetIdentifier,
        spacing: CGFloat? = nil
    ) where Content == Image {
        self.init(title, subtitle: subtitle, spacing: spacing, value: Image(assetIdentifier: image))
    }
}

// MARK: - Title & Subtitle with Text

extension LabeledContent where Label == _XIVTSSV, Content: View {
    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value.
    ///
    /// ```swift
    /// var subtitle: Text {
    ///     Text("AAPL")
    ///         .font(.caption)
    ///         .foregroundStyle(.green)
    /// }
    ///
    /// LabeledContent(Text("Apple"), subtitle: subtitle) {
    ///     Image(system: .docOnDoc)
    /// }
    /// ```
    public init(
        _ title: Text,
        subtitle: Text?,
        spacing: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init {
            content()
        } label: {
            _XIVTSSV(
                title: title,
                subtitle: subtitle,
                spacing: spacing
            )
        }
    }

    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value.
    ///
    /// ```swift
    /// var subtitle: Text {
    ///     Text("AAPL")
    ///         .font(.caption)
    ///         .foregroundStyle(.green)
    /// }
    ///
    /// LabeledContent(Text("Apple"), subtitle: subtitle, value: Image(system: .docOnDoc))
    /// ```
    public init(
        _ title: Text,
        subtitle: Text?,
        spacing: CGFloat? = nil,
        value: Content
    ) {
        self.init(title, subtitle: subtitle, spacing: spacing, content: { value })
    }

    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value with a system image.
    ///
    /// ```swift
    /// var subtitle: Text {
    ///     Text("AAPL")
    ///         .font(.caption)
    ///         .foregroundStyle(.green)
    /// }
    ///
    /// LabeledContent(Text("Apple"), subtitle: subtitle, systemImage: .docOnDoc)
    /// ```
    public init(
        _ title: Text,
        subtitle: Text?,
        systemImage: SystemAssetIdentifier,
        spacing: CGFloat? = nil
    ) where Content == Image {
        self.init(title, subtitle: subtitle, spacing: spacing, value: Image(system: systemImage))
    }

    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value with an image.
    ///
    /// ```swift
    /// var subtitle: Text {
    ///     Text("AAPL")
    ///         .font(.caption)
    ///         .foregroundStyle(.green)
    /// }
    ///
    /// LabeledContent(Text("Apple"), subtitle: subtitle, image: .disclosureIndicator)
    /// ```
    public init(
        _ title: Text,
        subtitle: Text?,
        image: ImageAssetIdentifier,
        spacing: CGFloat? = nil
    ) where Content == Image {
        self.init(title, subtitle: subtitle, spacing: spacing, value: Image(assetIdentifier: image))
    }
}

extension LabeledContent<_XIVTSSV, Never> {
    /// Creates a labeled content with a title and subtitle generated from strings.
    ///
    /// ```swift
    /// LabeledContent("Apple", subtitle: "AAPL")
    /// ```
    public init(
        _ title: some StringProtocol,
        subtitle: (some StringProtocol)?,
        spacing: CGFloat? = nil
    ) {
        self.init(title, subtitle: subtitle, spacing: spacing, content: { fatalError() })
    }

    /// Creates a labeled content with a title and subtitle generated from strings.
    ///
    /// ```swift
    /// var subtitle: Text {
    ///     Text("AAPL")
    ///         .font(.caption)
    ///         .foregroundStyle(.green)
    /// }
    ///
    /// LabeledContent(Text("Apple"), subtitle: subtitle)
    /// ```
    public init(
        _ title: Text,
        subtitle: Text?,
        spacing: CGFloat? = nil
    ) {
        self.init(title, subtitle: subtitle, spacing: spacing, content: { fatalError() })
    }
}
