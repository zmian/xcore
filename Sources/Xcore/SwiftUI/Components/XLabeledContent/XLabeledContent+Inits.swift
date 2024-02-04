//
// Xcore
// Copyright © 2021 Xcore
// MIT license, see LICENSE file for details
//

import SwiftUI

// MARK: - Configuration

extension XLabeledContent<XLabeledContentStyleConfiguration.Label, XLabeledContentStyleConfiguration.Content> {
    /// Creates labeled content based on a labeled content style configuration.
    ///
    /// You can use this initializer within the ``makeBody(configuration:)`` method
    /// of a ``XLabeledContentStyle`` to create a labeled content instance. This is
    /// useful for custom styles that only modify the current style, as opposed to
    /// implementing a brand new style.
    ///
    /// For example, the following style adds a red border around the labeled
    /// content, but otherwise preserves the current style:
    ///
    /// ```swift
    /// struct RedBorderLabeledContentStyle: XLabeledContentStyle {
    ///     func makeBody(configuration: Configuration) -> some View {
    ///         XLabeledContent(configuration)
    ///             .border(Color.red)
    ///     }
    /// }
    /// ```
    ///
    /// - Parameter configuration: The configuration of the labeled content.
    public init(_ configuration: XLabeledContentStyleConfiguration) {
        self.init(content: { configuration.content }, label: { configuration.label })
    }
}

// MARK: - Label Only

extension XLabeledContent where Content == Never {
    /// Creates a label of the labeled content.
    ///
    /// ```swift
    /// XLabeledContent {
    ///     Text("Hello")
    ///         .multilineTextAlignment(.trailing)
    /// }
    /// ```
    public init(@ViewBuilder label: @escaping () -> Label) {
        self.init {
            fatalError()
        } label: {
            label()
        }
    }
}

extension XLabeledContent<Text, Never> {
    /// Creates a label of the labeled content generated from a string.
    ///
    /// ```swift
    /// XLabeledContent("Version")
    /// ```
    public init(_ label: some StringProtocol) {
        self.init {
            Text(label)
        }
    }
}

extension XLabeledContent where Label == Text {
    /// Creates a labeled content with a label generated from a string and a value.
    ///
    /// ```swift
    /// XLabeledContent("Favorite") {
    ///     Image(system: .star)
    /// }
    /// ```
    public init(
        _ title: some StringProtocol,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.init {
            content()
        } label: {
            Text(title)
        }
    }
}

extension XLabeledContent where Label == Text {
    /// Creates a labeled content with a title generated from a string and a value.
    ///
    /// ```swift
    /// XLabeledContent("Favorite", value: Image(system: .star))
    /// ```
    public init(_ title: some StringProtocol, value: Content) {
        self.init {
            value
        } label: {
            Text(title)
        }
    }
}

extension XLabeledContent<Text, Text?> {
    /// Creates a labeled content with a title and a value generated from a string.
    ///
    /// ```swift
    /// XLabeledContent("First Name", value: "Sam")
    /// ```
    public init(_ title: some StringProtocol, value: (some StringProtocol)?) {
        self.init {
            value.map(Text.init)
        } label: {
            Text(title)
        }
    }
}

// MARK: - Money

extension XLabeledContent<Text, Money?> {
    /// Creates a labeled content with a title generated from a string and a value
    /// formatted as money.
    ///
    /// ```swift
    /// XLabeledContent("Price", money: 10) // formats the value as "$10.00"
    /// ```
    public init(_ title: some StringProtocol, money: Decimal?) {
        self.init {
            Money(money)
        } label: {
            Text(title)
        }
    }

    /// Creates a labeled content with a title generated from a string and a value
    /// formatted as money.
    ///
    /// ```swift
    /// XLabeledContent("Price", money: 10) // formats the value as "$10.00"
    /// ```
    @_disfavoredOverload
    public init(_ title: some StringProtocol, money: Double?) {
        self.init {
            Money(money)
        } label: {
            Text(title)
        }
    }
}

// MARK: - Double

extension XLabeledContent<Text, Text?> {
    /// Creates a labeled content with a title generated from a string and a value
    /// formatted using number formatter.
    ///
    /// ```swift
    /// XLabeledContent("Quantity", value: 1000) // formats the value as "1,000"
    /// ```
    public init(_ title: some StringProtocol, value: Double?) {
        self.init {
            value.map { Text($0.formatted(.asNumber)) }
        } label: {
            Text(title)
        }
    }
}

// MARK: - Image

extension XLabeledContent<Text, Image?> {
    /// Creates a labeled content with a title generated from a string and a value
    /// with a system image.
    ///
    /// ```swift
    /// XLabeledContent("Favorite", systemImage: .star)
    /// ```
    public init(_ title: some StringProtocol, systemImage: SystemAssetIdentifier?) {
        self.init {
            systemImage.map(Image.init(system:))
        } label: {
            Text(title)
        }
    }

    /// Creates a labeled content with a title generated from a string and a value
    /// with an image.
    ///
    /// ```swift
    /// XLabeledContent("Favorite", image: .disclosureIndicator)
    /// ```
    public init(_ title: some StringProtocol, image: ImageAssetIdentifier?) {
        self.init {
            image.map(Image.init(assetIdentifier:))
        } label: {
            Text(title)
        }
    }
}

extension XLabeledContent where Content == Image {
    /// Creates a labeled content with a title and a value with an image.
    ///
    /// ```swift
    /// XLabeledContent(image: Image(system: .docOnDoc)) {
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
    /// XLabeledContent(systemImage: .docOnDoc) {
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

extension XLabeledContent where Label == _XIVTSSV {
    /// Creates a labeled content with a title and subtitle generated from string
    /// and a value.
    ///
    /// ```swift
    /// XLabeledContent("Apple", subtitle: "AAPL") {
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
    /// XLabeledContent("Apple", subtitle: "AAPL", value: Image(system: .docOnDoc))
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
    /// XLabeledContent("Apple", subtitle: "AAPL", systemImage: .docOnDoc)
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
    /// XLabeledContent("Apple", subtitle: "AAPL", image: .disclosureIndicator)
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

extension XLabeledContent where Label == _XIVTSSV {
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
    /// XLabeledContent(Text("Apple"), subtitle: subtitle) {
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
    /// XLabeledContent(Text("Apple"), subtitle: subtitle, value: Image(system: .docOnDoc))
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
    /// XLabeledContent(Text("Apple"), subtitle: subtitle, systemImage: .docOnDoc)
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
    /// XLabeledContent(Text("Apple"), subtitle: subtitle, image: .disclosureIndicator)
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

extension XLabeledContent<_XIVTSSV, Never> {
    /// Creates a labeled content with a title and subtitle generated from strings.
    ///
    /// ```swift
    /// XLabeledContent("Apple", subtitle: "AAPL")
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
    /// XLabeledContent(Text("Apple"), subtitle: subtitle)
    /// ```
    public init(
        _ title: Text,
        subtitle: Text?,
        spacing: CGFloat? = nil
    ) {
        self.init(title, subtitle: subtitle, spacing: spacing, content: { fatalError() })
    }
}
